<sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_ADMIN">
    <g:if test="${ esReservaVigente }">
        <g:if test="${esReservaPosPagoPendiente}">
            <div class="row" style="margin-bottom: 1em; display: flex; justify-content: center;">
                <div class="col-md-5 ">
                    <a href="${createLink(controller: 'reserva', action: 'aprobarSolicitud', id: reserva?.id)}" class="btn btn-info btn-block btn-md mt-3" title="Aprobar">
                        Aprobar
                    </a>
                </div>
                <div class="col-md-5">
                    <a href="${createLink(controller: 'reserva', action: 'cancelarSolicitud', id: reserva?.id)}" class="btn btn-danger btn-block btn-md mt-3" title="Rechazar" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                        Rechazar
                    </a>
                </div>
            </div>
        </g:if>
        <g:else>
            <div class="row"  style="margin-bottom: 1em; display: flex; justify-content: center;">
                <g:if test="${ reserva?.tipoReserva?.id != 2 }">
                    <div class="col-md-5">
                        <g:link controller="reserva" action="eliminarReserva" id="${reserva?.id}">
                            <button class="btn btn-danger btn-block btn-md mt-3" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Eliminar Reserva</button>
                        </g:link>
                    </div>
                </g:if>

                <div class="col-md-5" style="color: white;">
                    <a   data-toggle="modal" data-target="#modalReagendar"
                         class="btn btn-success btn-block btn-md mt-3" title="Reagendar">
                        Reagendar Reserva
                    </a>
                </div>
            </div>
        </g:else>
    </g:if>
</sec:ifAnyGranted>
