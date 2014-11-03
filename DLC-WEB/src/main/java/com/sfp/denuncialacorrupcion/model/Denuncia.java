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

package com.sfp.denuncialacorrupcion.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
 
@Entity
@Table (name="denuncias")
public class Denuncia implements Serializable
{
	@Id
    @GeneratedValue
    private Integer id;
	private String nombre;
	private Boolean esAnonima;
	private Date fechaAlta;
	private Integer estatus;
	private String correoElectronico;
	private String evidencias;
	private Double latitud;
	private Double longitud;
	private String calle;
	private String delegacion;
	private String descripcion;
	private String fraccionamiento;
	private String lada;
	private String lugarHechos;
	private String numExterior;
	private String numInterior;
	private String spDomicilioDependencia;
	private String spLugarTrabajo;
	private String spNombre;
	private String spPuesto;
	private String telefono;
	private String usuarioUID;
	private String causa;
	private String comentarios;
	private String folio;
	private String awsTopic;
	
	
	public void setCalle(String calle) {
        this.calle = calle;
    }
	
	public String getCalle() {
        return calle;
    }
	
	public void setDelegacion(String delegacion) {
        this.delegacion = delegacion;
    }
	
	public String getDelegacion() {
        return delegacion;
    }
	
	public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
	
	public String getDescripcion() {
        return descripcion;
    }
	
	public void setFraccionamiento(String fraccionamiento) {
        this.fraccionamiento = fraccionamiento;
    }
	
	public String getFraccionamiento() {
        return fraccionamiento;
    }
	
	public void setLada(String lada) {
        this.lada = lada;
    }
	
	public String getLada() {
        return lada;
    }
	
	public void setLugarHechos(String lugarHechos) {
        this.lugarHechos = lugarHechos;
    }
	
	public String getLugarHechos() {
        return lugarHechos;
    }
	
	public void setNumExterior(String numExterior) {
        this.numExterior = numExterior;
    }
	
	public String getNumExterior() {
        return numExterior;
    }
	
	public void setNumInterior(String numInterior) {
        this.numInterior = numInterior;
    }
	
	public String getNumInterior() {
        return numInterior;
    }
	
	public void setSpDomicilioDependencia(String spDomicilioDependencia){
		this.spDomicilioDependencia = spDomicilioDependencia;
	}
	
	public String getSpDomicilioDependencia(){
		return spDomicilioDependencia;
	}
	
	public void setSpLugarTrabajo(String spLugarTrabajo) {
        this.spLugarTrabajo = spLugarTrabajo;
    }
	
	public String getSpLugarTrabajo() {
        return spLugarTrabajo;
    }
	
	public void setSpNombre(String spNombre) {
        this.spNombre = spNombre;
    }
	
	public String getSpNombre() {
        return spNombre;
    }
	
	public void setSpPuesto(String spPuesto) {
        this.spPuesto = spPuesto;
    }
	
	public String getSpPuesto() {
        return spPuesto;
    }
	
	public void setSpTelefono(String telefono) {
        this.telefono = telefono;
    }
	
	public String getTelefono() {
        return telefono;
    }
	
	public void setId(Integer id) {
        this.id = id;
    }
	
	public Integer getId() {
        return id;
    }
 
	public void EsAnonima(Boolean esAnonima) {
        this.esAnonima = esAnonima;
    }
	
	public Boolean getEsAnonima() {
        return esAnonima;
    }
	
	public void setFechaAlta(Date fechaAlta) {
        this.fechaAlta = fechaAlta;
    }
	
	public Date getFechaAlta(){
		return fechaAlta;
	}
	
	public void setEstatus(Integer estatus) {
        this.estatus = estatus;
    }
	
	public Integer getEstatus() {
        return estatus;
    }
	
	public void setCorreoElectronico(String correoElectronico) {
        this.correoElectronico = correoElectronico;
    }
	
	public String getCorreoElectronico() {
        return correoElectronico;
    }
	
	public void setEvidencias(String evidencias) {
        this.evidencias = evidencias;
    }
	
	public String getEvidencias() {
        return evidencias;
    }
	
	public void setLatitud(Double latitud) {
        this.latitud = latitud;
    }
	
	public Double getLatitud() {
        return latitud;
    }
	
	public void setLongitud(Double longitud) {
        this.longitud = longitud;
    }
	
	public Double getLongitud() {
        return longitud;
    }
	
	public void setNombre(String nombre) {
        this.nombre = nombre;
    }
	
	public String getNombre() {
        return nombre;
    }
	
	public void setIdUsuarioUID(String usuarioUID) {
        this.usuarioUID = usuarioUID;
    }
	
	public String getUsuarioUID() {
        return usuarioUID;
    }
	
	public void setCausa(String causa) {
        this.causa = causa;
    }
	
	public String getCausa() {
        return causa;
    }
	
	public void setComentarios(String comentarios) {
        this.comentarios = comentarios;
    }
	
	public String getComentarios() {
        return comentarios;
    }
	
	public void setFolio(String folio) {
        this.folio = folio;
    }
	
	public String getFolio() {
        return folio;
    }
	public void setAwsTopic(String awsTopic) {
        this.awsTopic = awsTopic;
    }
	
	public String getAwsTopic() {
        return awsTopic;
    }
}