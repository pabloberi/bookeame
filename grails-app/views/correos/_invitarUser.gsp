<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Plantilla</title>
	<style>
	/* Estilos generales */
	body {
		font-family: Arial, sans-serif;
	}

	/* Estilos específicos del correo */
	.container {
		max-width: 600px;
		margin: 0 auto;
		padding: 20px;
		background-color: #f9f9f9;
	}

	.header {
		background-color: #444444;
		color: #ffffff;
		padding: 10px;
		text-align: center;
	}

	.footer {
		background-color: #444444;
		color: #ffffff;
		padding: 10px;
		margin-top: 20px;
		text-align: center;
		font-size: 12px;
	}

	.header img {
		max-width: 200px;
	}

	h1 {
		color: #333333;
	}

	p {
		color: #555555;
	}

	.invoice {
		width: calc(100% - 2em);
		margin: 0 1em;
		border-collapse: collapse;
		margin-top: 20px;
	}

	.invoice th, .invoice td {
		padding: 8px;
		text-align: left;
		border-bottom: 1px solid #000000;
	}

	.additional-info {
		margin-left: 1em;
	}
	</style>
</head>
<body>
<div class="container">
	<div class="header">
		<img src="https://bookeame.cl:8443/img/bookeame-logos/bookeame-full-blanco.png" alt="Logo" />
		<h1 style="color: white;">Registrate Gratis</h1>
%{--		<h4 style="color: white;"></h4>--}%
	</div>
	<table class="invoice">
		<tr>
			<td bgcolor="white">
				<div style="margin-top: 1em; margin-left: 2em;margin-right: 2em;">
					Hola ${user?.nombre},<br><br>
					Hemos visto que una empresa registró tus datos en nuestro sistema. Te invitamos a completar tus datos
					para unirte a esta maravillosa comunidad. <br>Te esperamos!<br>
					Para saber más de nosotros visita <a href="https://bookeame.cl">bookeame.cl</a>
				</div>
				<br>
				<div style="float:right; margin-right: 3em;margin-bottom: 1em;">
					<a href="${link}">
						<button id="boton" type="submit" class="btn btn-block btn-danger btn-lg mt-3">Registrarme</button>
					</a>
				</div>
				<br><br><br>
				<div style="margin-left: 2em;">
					Saludos Cordiales,<br>
					BOOKEAME - Tú Agenda en Línea
				</div>
			</td>
		</tr>
	</table>

	<div class="footer">
		<small>
			Copyright <a href="https://bookeame.cl/">BOOKEAME</a>
			<script>
				document.write(new Date().getFullYear())
			</script>
			. Todos Los Derechos Reservados.</p>
		</small>
	</div>
</div>
</body>
</html>


