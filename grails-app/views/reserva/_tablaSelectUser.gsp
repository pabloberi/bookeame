<table class="table">
    <tbody>
    <tr class="prop">
        <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Nombre " /></td>
        <td valign="top" class="value">${userSelect?.nombre} ${userSelect?.apellidoPaterno}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name"><g:message code="espacio.valor.label" default="Correo" /></td>
        <td valign="top" class="value">${userSelect?.email}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name"><g:message code="espacio.tiempo.label" default="Celular" /></td>
        <td valign="top" class="value">${userSelect?.celular}</td>
    </tr>
    <tr class="prop">
        <td valign="top" class="name"><g:message code="espacio.tipoEspacio.label" default="Indice Confianza" /></td>
        <td valign="top" class="value">${userSelect?.indiceConfianza} de 5 <i class="fal fa-star"></i></td>
    </tr>
    </tbody>
</table>

<div class="modal-footer">
    <a href="${createLink(controller: 'reserva', action:'crearReservaManual', id: modulo?.espacio?.id)}"><button type="button" class="btn btn-secondary">Cancelar</button></a>
    <a href=" ${createLink(controller:'reserva', action: 'guardarReservaManual', params: [userId: userSelect?.id , moduloId: modulo?.id, fechaReserva: fechaReserva] ) }">
        <button type="button" class="btn btn-primary">Crear</button>
    </a>
</div>
