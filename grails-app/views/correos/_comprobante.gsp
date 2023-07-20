<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Plantilla de correo electrónico</title>
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
        <img src="https://bookeame.cl/img/bookeame-logos/bookeame-full-blanco.png" alt="Logo" />
        <h1 style="color: white;">Comprobante de Pago</h1>
        <h4 style="color: white;"># ${reserva?.codigo}</h4>
    </div>

    <div class="additional-info">
        <p><strong>Fecha de Reserva:</strong> <g:formatDate type="date" style="FULL" date="${reserva?.fechaReserva}"/></p>
        <p><strong>Hora de Reserva:</strong> ${reserva?.horaInicio}</p>
        <p><strong>Nombre del Cliente:</strong> ${reserva?.usuario?.nombreCompleto ?: reserva?.usuario?.email}</p>
        <p><strong>Lugar:</strong> ${reserva?.espacio?.nombre}</p>
    </div>

    <table class="invoice">
        <thead>
        <tr>
            <th>Servicio</th>
            <th>Precio</th>
            <th>Cantidad</th>
            <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <g:if test="${servicioReservaList?.size() > 0}">
            <g:each in="${servicioReservaList}" var="servicioReserva" status="i">
                <tr>
                    <td>${servicioReserva?.servicio?.nombre}</td>
                    <td>$ ${reserva?.valorFinal } .-</td>
                    <td>1</td>
                    <td>$ ${reserva?.valorFinal } .-</td>
                </tr>
            </g:each>
        </g:if>
        <g:else>
            <tr>
                <td>${reserva?.espacio?.nombre}</td>
                <td>$ ${reserva?.valorFinal } .-</td>
                <td>1</td>
                <td>$ ${reserva?.valorFinal } .-</td>
            </tr>
        </g:else>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>Total</td>
            <td>$ ${reserva?.valorFinal } .-</td>
        </tr>
        </tbody>
    </table>

    <div class="footer">
        Comprobante no válido como boleta enviado por <strong>bookeame.cl</strong>.
    </div>
</div>
</body>
</html>
