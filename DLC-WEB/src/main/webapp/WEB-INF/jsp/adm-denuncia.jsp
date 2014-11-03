<!doctype html>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<meta charset="utf-8">
<title>SFP - Denuncia la corrupción - Nicotina Estudio</title>
<jsp:include page="/tmpl-head.jsp" />
<style type="text/css">
.evidencia{
	float: left;
	margin: 10px;
}
</style>
</head>
<body>
	<!-- Fixed navbar -->
	<jsp:include page="/tmpl-top-menu.jsp" />
	<div class="container">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="page-header">
					<h1>Administrador</h1>
				</div>
				<h3>Detalle denuncia número: ${denuncia.id}</h3>

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">Información</h3>
					</div>
					<div class="panel-body">
						<p>
							<strong>Tipo de denuncia:</strong>
						</p>
						${denuncia.esAnonima ? "Anónima" : "No anónima"}
						<p>
							<strong>FOLIO:</strong>
						</p>
						${denuncia.folio}
						<p>
							<strong>Fecha de interposición de queja o denuncia:</strong>
						</p>
						<fmt:formatDate type="both" value="${denuncia.fechaAlta}" />
						<br />
						<p>
							<strong>Estatus de la denuncia:</strong>
						</p>
						${denuncia.estatus}<br />
						<form:form method="post"
							action="/home/administrador/actualizarDenuncia"
							commandName="denuncia">
							<div class="form-horizontal">

								<form:input type="hidden" path="id" value="${denuncia.id}" />

								<select name="estatus">
									<option value="1">Enviado</option>
									<option value="2">En proceso de investigación</option>
									<option value="3">Finalizado</option>
								</select><br />
								<p>Comentarios de adminsitrador</p>
								<textarea name="comentarios" cols="100" rows="5">${denuncia.comentarios}</textarea>
								<br /> <input type="submit" value="Actualizar" class="btn" />
							</div>
						</form:form>
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">I. Datos del servidor público
							denunciado</h3>
					</div>
					<div class="panel-body">
						<p>
							<strong>Nombre del servidor público:</strong>
						</p>
						${denuncia.spNombre}<br />
						<p>
							<strong>Puesto:</strong>
						</p>
						${denuncia.spPuesto}<br />
						<p>
							<strong>Lugar de trabajo:</strong>
						</p>
						${denuncia.spLugarTrabajo}<br />
						<p>
							<strong>Domicilio de la dependencia:</strong> /
						<p>
							${denuncia.spDomicilioDependencia}<br />
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">II. Hechos que desea denunciar</h3>
					</div>
					<div class="panel-body">
						<p>
							<strong>Motivo de la denuncia</strong>
						</p>
						${denuncia.causa}<br />
						<p>
							<strong>¿Dónde ocurrieron los hechos?</strong>
						</p>
						${denuncia.lugarHechos}<br />
						<p>
							<strong>Narración de los hechos:</strong>
						</p>
						${denuncia.descripcion}<br />
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">III. Evidencias</h3>
					</div>
					<div class="panel-body">
						<c:set var="arrEvicencias"
							value="${fn:split(denuncia.evidencias, '|')}" />

						<c:choose>
							<c:when test="${fn:contains(arrEvicencias[0], 'jpg')}">
								<div class="evidencia">
									<img
										src="https://s3.amazonaws.com/denuncia-la-corrupcion/${arrEvicencias[0]}"
										height="240" />
								</div>
							</c:when>
							<c:otherwise>
								<div class="evidencia">
									<video width="320" height="240" controls>
										<source
											src="https://s3.amazonaws.com/denuncia-la-corrupcion/${arrEvicencias[0]}"
											type="video/mp4">
										<p>Tu navegador no soporta video HTML5.</p>
									</video>
								</div>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${fn:contains(arrEvicencias[1], 'jpg')}">
								<div class="evidencia">
									<img
										src="https://s3.amazonaws.com/denuncia-la-corrupcion/${arrEvicencias[1]}"
										height="240" />
								</div>
							</c:when>
							<c:otherwise>
								<div class="evidencia">
									<video width="320" height="240" controls>
										<source
											src="https://s3.amazonaws.com/denuncia-la-corrupcion/${arrEvicencias[1]}"
											type="video/mp4">
										<p>Tu navegador no soporta video HTML5.</p>
									</video>
								</div>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${fn:contains(arrEvicencias[2], 'jpg')}">
								<div class="evidencia">
									<img
										src="https://s3.amazonaws.com/denuncia-la-corrupcion/${arrEvicencias[2]}"
										height="240" />
								</div>
							</c:when>
							<c:otherwise>
								<div class="evidencia">
									<video width="320" height="240" controls>
										<source
											src="https://s3.amazonaws.com/denuncia-la-corrupcion/${arrEvicencias[2]}"
											type="video/mp4">
										<p>Tu navegador no soporta video HTML5.</p>
									</video>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">IV. Datos del usuario o quejoso</h3>
					</div>
					<div class="panel-body">
						<c:choose>
							<c:when test="${denucia.esAnonima == null}">
								<p>
									<strong>Correo electrónico</strong>
								</p>
						${denuncia.correoElectronico}<br />
							</c:when>
							<c:otherwise>
								<p>
									<strong>Nombre completo</strong>
								</p>
						${denuncia.nombre}<br />
								<p>
									<strong>Calle</strong>
								</p>
						${denuncia.calle}<br />
								<p>
									<strong>Num. Exterior</strong>
								</p>
						${denuncia.numExterior}<br />
								<p>
									<strong>Num. Interior</strong>
								</p>
						${denuncia.numInterior}<br />
								<p>
									<strong>Fraccionamiento ó colonia</strong>
								</p>
						${denuncia.fraccionamiento}<br />
								<p>
									<strong>Delegacion ó municipio</strong>
								</p>
						${denuncia.delegacion}<br />
								<p>
									<strong>Lada</strong>
								</p>
						${denuncia.lada}<br />
								<p>
									<strong>Teléfono</strong>
								</p>
						${denuncia.telefono}<br />
								<p>
									<strong>Correo electrónico</strong>
								</p>
						${denuncia.correoElectronico}<br />
							</c:otherwise>
						</c:choose>

					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="/tmpl-scripts.jsp" />
</body>
</html>
