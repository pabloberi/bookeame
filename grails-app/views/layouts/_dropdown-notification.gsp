<div class="dropdown-header bg-trans-gradient d-flex justify-content-center align-items-center rounded-top mb-2">
    <h4 class="m-0 text-center color-white">
        <small class="mb-0 opacity-80">Reserva Pendiente de Pago</small>
    </h4>
</div>
%{--<ul class="nav nav-tabs nav-tabs-clean" role="tablist">--}%
%{--    <li class="nav-item">--}%
%{--        <a class="nav-link px-12 fs-md js-waves-on fw-500 btn-success centered" data-toggle="tab" href="#tab-messages" data-i18n="drpdwn.messages">Boton de Pago</a>--}%
%{--    </li>--}%
%{--</ul>--}%
<div class="tab-content tab-notification" style="height: 19em;">
    <table class="table">
        <tbody>
            <tr class="prop">
                <td valign="top" class="name"><g:message code="espacio.tiempo.label" default="Fecha" /></td>
                <td id="fechaReserva" valign="top" class="value">${g.formatDate(format: "dd-MM-yyyy", date: session['temp']?.fechaReserva )}</td>
            </tr>
            <tr class="prop">
                <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Horario" /></td>
                <td id="horaInicio" valign="top" class="value">${session['temp']?.horaInicio} - ${session['temp']?.horaTermino}</td>
            </tr>
            <tr class="prop">
                <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Lugar" /></td>
                <td id="lugar" valign="top" class="value">${session['temp']?.espacio?.nombre}</td>
            </tr>
%{--            <tr class="prop">--}%
%{--                <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Valor" /></td>--}%
%{--                <% def precio = session['temp']?.valor * 1.04 %>--}%
%{--                <td id="valorReserva" valign="top" class="value">$ ${ precio?.toInteger() }</td>--}%
%{--            </tr>--}%
        </tbody>
    </table>

    <div style="margin-right: 1em; margin-left: 1em; ">
        <a id="botonPago" href="${session["link"]}" target="_blank" class=" btn btn-success btn-block" style="float: right;">Pagar</a>
    </div>
</div>

%{--<script>--}%
%{--    function marcarVisto(id) {--}%
%{--        $.ajax({--}%
%{--            type: 'POST',--}%
%{--            async: false,--}%
%{--            url: '${g.createLink(controller: 'notificaciones', action: 'marcarVisto')}',--}%
%{--            data: {id: id},--}%
%{--            success: function (data,textStatus) {} });--}%
%{--    }--}%
%{--</script>--}%
