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

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.ResponseBody;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.sfp.denuncialacorrupcion.model.Denuncia;
import com.sfp.denuncialacorrupcion.service.DenunciaService;

@RestController
@RequestMapping("/api")
public class API 
{
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private DenunciaService denunciaService;

	@PersistenceContext
	EntityManager em;


	@RequestMapping("/")
	public String saludo() {
		return "Bienvenido a la API de la SFP";
	}

	/**
	 * Alta de denuncia
	 * @param denuncia
	 * @return
	 * @throws Exception 
	 */
	@Transactional
	@RequestMapping(value = "/denuncia", method = RequestMethod.POST, produces = "application/json", consumes={"application/json", "text/html;charset=utf-8", "multipart/form-data"})	
	public @ResponseBody String alta(@RequestBody  Denuncia denuncia) throws Exception {

		String folio = denunciaService.agregarDenuncia(denuncia);
		
		return folio;
	}
}