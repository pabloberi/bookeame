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
		<h1 style="color: white;">Reserva Cancelada</h1>
%{--		<h4 style="color: white;"></h4>--}%
	</div>
	<table class="invoice">
		<tr>
			<td bgcolor="white">
				<div style="margin-right: 2em;margin-top: 1em; margin-left: 2em;">
					Hola ${user?.nombre},<br><br>
					La empresa "${razonSocial}" ha cancelado tu reserva para el espacio "${espacio}" con fecha ${fecha} a las ${hora} hrs.
					Tenemos registro de un pago efectuado a través de la plataforma FLOW el cual ya ha iniciado su proceso de reembolso.<br><br>

					Número de Reembolso: 	${refundReserva?.numeroReembolso} <br>
					Número de Orden: 		${refundReserva?.numeroOrden} <br>
					Monto Reembolso:		${refundReserva?.monto} <br><br>

					Ante cualquier duda o eventualidad, por favor contactános a través de nuestros canales de soporte.
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