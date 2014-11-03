<!doctype html>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
<meta charset="utf-8">
<title>SFP - Denuncia la corrupción</title>
<jsp:include page="/tmpl-head.jsp" />
</head>
<body>
	<!-- Fixed navbar -->
	<jsp:include page="/tmpl-top-menu.jsp" />
	<div class="container">
		<div class="row">
			<div class="col-md-8 col-md-offset-2">
				<div class="page-header">
					<h1>Prototipo - SFP - Denuncia la corrupción</h1>
				</div>
				<p>Este prototipo incluye las siguientes funcionalidades</p>
				<ol>
					<li>Administrador
						<ul>
							<li><a href="administrador/denuncias">Lista de
									denuncias:</a> Puede ver un listado de las denuncias agregadas.</li>
							<li><a href="administrador/denuncia/1">Detalle de
									denuncias:</a> Puede ver el detalle de cada denuncia asi como
								cambiar el estatus de la denuncia.</li>
						</ul>
					</li>
				</ol>
			</div>
		</div>
	</div>
	<jsp:include page="/tmpl-scripts.jsp" />
</body>
</html>
