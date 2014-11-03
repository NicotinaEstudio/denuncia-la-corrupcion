/**
 * Copyright 2014 Nicotina Estudio
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

package com.sfp.denuncialacorrupcion.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.sns.AmazonSNSClient;
import com.amazonaws.services.sns.model.CreatePlatformEndpointRequest;
import com.amazonaws.services.sns.model.CreatePlatformEndpointResult;
import com.amazonaws.services.sns.model.CreateTopicRequest;
import com.amazonaws.services.sns.model.CreateTopicResult;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.PublishResult;
import com.amazonaws.services.sns.model.SubscribeRequest;
import com.sfp.denuncialacorrupcion.model.Denuncia;

import javax.mail.internet.MimeMessage;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.persistence.metamodel.EntityType;
import javax.persistence.metamodel.Metamodel;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service
public class DenunciaServiceImpl implements DenunciaService 
{
	@PersistenceContext
	EntityManager em;

	@Autowired
	private IQRService qrService;

	@Autowired
	private JavaMailSender mailSender;

	/**
	 * Agregar denuncia
	 * @throws Exception 
	 */
	@Transactional
	public String agregarDenuncia(Denuncia denuncia) throws Exception {

		String folio = UUID.randomUUID().toString(); // Folio de la denuncia
		String correoElectronico = denuncia.getCorreoElectronico();
		denuncia.setFechaAlta(new Date()); // Asginamos la fecha de alta
		denuncia.setFolio(folio);

		em.persist(denuncia);

		File file = new File("qr.png");
		FileOutputStream fileout = new FileOutputStream(file);

		OutputStream output = fileout;

		qrService.generarCodigoQR(200, 200, "http://denuncia-la-corrupcion.herokuapp.com/denuncia/" + denuncia.getId(), output);

		// Subimos a Amazon
		AmazonS3 s3client = new AmazonS3Client(new ClasspathPropertiesFileCredentialsProvider()); 

		try {
			System.out.println("Uploading a new object to S3 from a file\n");
			s3client.putObject(new PutObjectRequest("denuncia-la-corrupcion/qr", folio + ".png", file));

		} catch (AmazonServiceException ase) {
			System.out.println("Caught an AmazonServiceException, which " +
					"means your request made it " +
					"to Amazon S3, but was rejected with an error response" +
					" for some reason.");
			System.out.println("Error Message:    " + ase.getMessage());
			System.out.println("HTTP Status Code: " + ase.getStatusCode());
			System.out.println("AWS Error Code:   " + ase.getErrorCode());
			System.out.println("Error Type:       " + ase.getErrorType());
			System.out.println("Request ID:       " + ase.getRequestId());

		} catch (AmazonClientException ace) {
			System.out.println("Caught an AmazonClientException, which " +
					"means the client encountered " +
					"an internal error while trying to " +
					"communicate with S3, " +
					"such as not being able to access the network.");
			System.out.println("Error Message: " + ace.getMessage());
		}

		// Damos del alta en SNS

		// Creamos un nuevlo cliente SNS y aisgnamos el nuevo endpoint
		AmazonSNSClient snsClient = new AmazonSNSClient(new ClasspathPropertiesFileCredentialsProvider()); 
		snsClient.setRegion(Region.getRegion(Regions.US_EAST_1));

		String platformApplicationArn = "arn:aws:sns:us-east-1:510874473233:app/APNS_SANDBOX/denuncia-la-corrupcion";
		String customPushData = "prototipo funcional";

		// Si es la primera vez de la denuncia resgistramos el endpoint
		List<Denuncia> arrDenuncias = this.obtenerDenuncias(denuncia.getUsuarioUID());
		System.out.println("****** DENUNCIAS DE ESE USUARIO - " + arrDenuncias.size());
		String endPointARN = "";

		if(arrDenuncias.size() < 1 || arrDenuncias.size() == 1)
		{	
			CreatePlatformEndpointRequest platformEndpointRequest = new CreatePlatformEndpointRequest();
			platformEndpointRequest.setCustomUserData(customPushData);
			platformEndpointRequest.setToken(denuncia.getUsuarioUID()); // Usuario Id = Device token
			platformEndpointRequest.setPlatformApplicationArn(platformApplicationArn);
			CreatePlatformEndpointResult result = snsClient.createPlatformEndpoint(platformEndpointRequest);

			// Obtenemos el end pont para utilizarlo al suscribir al Topic SNS
			endPointARN = result.getEndpointArn();
			System.out.println("Amazon Push reg result: " + result);
		}
		else
		{
			// Si no es la primera vez obtenemos el Endpoint
			endPointARN = "arn:aws:sns:us-east-1:510874473233:endpoint/APNS_SANDBOX/denuncia-la-corrupcion/a4acd564-6a5e-3cc0-bf53-0331ee286586";
		}

		// Creamos un nuevo SNS topic para que reciba solo sus notificaciones - Con el nombre de su folio
		CreateTopicRequest createTopicRequest = new CreateTopicRequest(denuncia.getFolio()); 
		CreateTopicResult createTopicResult = snsClient.createTopic(createTopicRequest); 
		System.out.println(createTopicResult);

		// Obtenemos el ARN del Topic SNS
		String topicArn = createTopicResult.getTopicArn();
		System.out.println("CreateTopicRequest - " + topicArn);

		// Subscribimos al SNS topic
		SubscribeRequest subRequest = new SubscribeRequest(topicArn, "application", endPointARN);
		snsClient.subscribe(subRequest);

		System.out.println("SubscribeRequest - " + snsClient.getCachedResponseMetadata(subRequest));

		// Publicamos un mensage de estatus con el folio de la denuncia
		String msg = "¡Gracias por tu denuncia! el folio es: " + denuncia.getFolio();
		PublishRequest publishRequest = new PublishRequest(topicArn, msg);
		PublishResult publishResult = snsClient.publish(publishRequest);
		System.out.println("MessageId - " + publishResult.getMessageId());

		// Guardamos el topi de la denuncia
		denuncia.setAwsTopic(topicArn);
		em.merge(denuncia);

		// Enviamos el correo

		String para = correoElectronico;
		String asunto = "Denuncia recibida - Denuncia la corrupción";

		// creates a simple e-mail object
		MimeMessage mimeMessage = mailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, false, "utf-8");
		String mensaje = "Tu denuncia se ha dado de alta satisfactoriamente con el folio " + folio + "<br/><br/>" +
				"Puedes darle seguimiento a tu denuncia escanenado el código QR con la aplicación de Denuncia la Corrupción<br/>" +
				"<img src='https://s3.amazonaws.com/denuncia-la-corrupcion/qr/" + folio + ".png' />";
		mimeMessage.setContent(mensaje, "text/html");
		helper.setTo(para);
		helper.setSubject(asunto);
		helper.setFrom("dlc@nicotinaestudio.mx");

		// sends the e-mail
		mailSender.send(mimeMessage);

		String jsonFolio = "{ \"folio\" : \"" + folio + "\" }";

		return jsonFolio;
	}

	/**
	 * Actualizar denuncia
	 */
	@Transactional
	public void actualizarDenuncia(Denuncia denuncia) {
		Denuncia denunciaExistente = em.find(Denuncia.class, denuncia.getId());
		denunciaExistente.setEstatus(denuncia.getEstatus()); // Actualizamos el estatus de la denuncia
		denunciaExistente.setComentarios(denuncia.getComentarios()); // Actualizamos los comentarios
		em.merge(denunciaExistente);

		// Push Notification con el estatus de su denuncia
		String topicArn = denunciaExistente.getAwsTopic();
		System.out.println("topicArn - " + topicArn);
		AmazonSNSClient snsClient = new AmazonSNSClient(new ClasspathPropertiesFileCredentialsProvider()); 

		String msg = "Ha cambiado el estatus de tu denuncia a " + denuncia.getEstatus();

		PublishRequest publishRequest = new PublishRequest(topicArn, msg);
		PublishResult publishResult = snsClient.publish(publishRequest);

		System.out.println("MessageId - " + publishResult.getMessageId());
	}

	/**
	 * Lista de denuncias
	 */
	@Transactional
	public List<Denuncia> listaDenuncias() {
		CriteriaQuery<Denuncia> c = em.getCriteriaBuilder().createQuery(Denuncia.class);
		Root<Denuncia> from = c.from(Denuncia.class);
		c.orderBy(em.getCriteriaBuilder().asc(from.get("id")));
		return em.createQuery(c).getResultList();
	}

	public List<Denuncia> obtenerDenuncias(String deviceToken){

		CriteriaBuilder cb = em.getCriteriaBuilder();

		CriteriaQuery<Denuncia> cq = cb.createQuery(Denuncia.class);
		Metamodel m = em.getMetamodel();
		EntityType<Denuncia> Denuncia_ = m.entity(Denuncia.class);
		Root<Denuncia> denuncia = cq.from(Denuncia.class);
		cq.select(denuncia);
		cq.where(cb.equal(denuncia.get("usuarioUID"), deviceToken));

		TypedQuery<Denuncia> tq = em.createQuery(cq);
		List<Denuncia> todasLasDenuncias = tq.getResultList();

		return todasLasDenuncias;
	}

	/**
	 * Detalle de denuncia
	 */
	@Transactional
	public Denuncia detalleDenuncia(Integer id)
	{
		Denuncia denuncia = em.find(Denuncia.class, id);
		return denuncia;
	}
}
