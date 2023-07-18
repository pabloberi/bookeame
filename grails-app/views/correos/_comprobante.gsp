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
    </div>

    <div class="additional-info">
        <p><strong>Fecha de Reserva:</strong> 18 de julio de 2023</p>
        <p><strong>Hora de Reserva:</strong> 15:00</p>
        <p><strong>Nombre del Cliente:</strong> John Doe</p>
        <p><strong>Lugar:</strong> Ciudad Ejemplo</p>
    </div>

    <table class="invoice">
        <thead>
        <tr>
            <th>Producto</th>
            <th>Precio</th>
            <th>Cantidad</th>
            <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>Producto 1</td>
            <td>$10</td>
            <td>2</td>
            <td>$20</td>
        </tr>
        <tr>
            <td>Producto 2</td>
            <td>$15</td>
            <td>1</td>
            <td>$15</td>
        </tr>
        <tr>
            <td>Producto 3</td>
            <td>$5</td>
            <td>3</td>
            <td>$15</td>
        </tr>
        <tr>
            <td></td>
            <td></td>
            <td>Total</td>
            <td>$15</td>
        </tr>
        </tbody>
    </table>

    <div class="footer">
        Comprobante no válido como boleta enviado por <strong>bookeame.cl</strong>.
    </div>
</div>
</body>
</html>
