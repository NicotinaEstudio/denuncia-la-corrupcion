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

package com.sfp.denuncialacorrupcion.controller;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.amazonaws.auth.ClasspathPropertiesFileCredentialsProvider;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.sns.AmazonSNSClient;
import com.amazonaws.services.sns.model.CreatePlatformEndpointRequest;
import com.amazonaws.services.sns.model.CreatePlatformEndpointResult;
import com.amazonaws.services.sns.model.CreateTopicRequest;
import com.amazonaws.services.sns.model.CreateTopicResult;
import com.amazonaws.services.sns.model.PublishRequest;
import com.amazonaws.services.sns.model.PublishResult;
import com.amazonaws.services.sns.model.SubscribeRequest;
import com.sfp.denuncialacorrupcion.model.Denuncia;
import com.sfp.denuncialacorrupcion.service.DenunciaService;
import com.sfp.denuncialacorrupcion.service.IQRService;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/administrador")
public class AdministradorController {

	@Autowired
	private DenunciaService denunciaService;
	
	@Autowired
	private IQRService qrService;

	/**
	 * Lista de denuncias
	 * @param map
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/denuncias")
	public String listaDenuncias(Map<String, Object> map) throws Exception {
		
		map.put("listaDenuncias", denunciaService.listaDenuncias());
		return "adm-denuncias";
	}

	/**
	 * Detalle de denuncia
	 * @param id
	 * @param map
	 * @return
	 */
	@RequestMapping("/denuncia/{id}")
	public String detalleDenuncia(@PathVariable("id") Integer id, Map<String, Object> map) {

		map.put("denuncia", denunciaService.detalleDenuncia(id));
		return "adm-denuncia";
	}

	/**
	 * Actualizar denuncias
	 * @param request
	 * @param denuncia
	 * @param result
	 * @return
	 */
	@RequestMapping(value = "/actualizarDenuncia", method = RequestMethod.POST)
	public String actualizarPagina(HttpServletRequest request, @ModelAttribute("denuncia") Denuncia denuncia, BindingResult result) {

		denunciaService.actualizarDenuncia(denuncia);

		String referer = request.getHeader("Referer");
		return "redirect:"+ referer;
	}
}
