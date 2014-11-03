<!doctype html>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<html>
<head>
<meta charset="utf-8">
<title>SFP - Denuncia la corrupción - Nicotina Estudio</title>
<jsp:include page="/tmpl-head.jsp" />
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

				<c:if test="${!empty listaDenuncias}">
					<h3>Denuncias</h3>
					<table class="table table-bordered table-striped">
						<thead>
							<tr>
								<th>Id</th>
								<th>Fecha alta</th>
								<th>Tipo denuncia</th>
								<th>Nombre del servidor público</th>
								<th>Opciones</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${listaDenuncias}" var="denuncia">
								<tr>
									<td>${denuncia.id}</td>
									<td><fmt:formatDate type="both"
											value="${denuncia.fechaAlta}" /></td>
									<td>${denuncia.esAnonima ? "Anónima" : "No anónima"}</td>
									<td>${denuncia.spNombre}</td>
									<td><a href="denuncia/${denuncia.id}">detalles</a></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</c:if>
			</div>
		</div>
	</div>
	<jsp:include page="/tmpl-scripts.jsp" />
</body>
</html>
