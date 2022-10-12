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
                <div class="col-md-5">
                    <g:link controller="reserva" action="${ reserva?.tipoReserva?.id != 2 ? 'eliminarReserva' : 'declaracionEliminacionPrepago'}" id="${reserva?.id}">
                        <button class="btn btn-danger btn-block btn-md mt-3" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Eliminar Reserva</button>
                    </g:link>
                </div>
                <div class="col-md-5" style="color: white;">
                    <a   data-toggle="modal" data-target="#modalReagendar"
                         class="btn btn-success btn-block btn-md mt-3" title="Reagendar">
                        Reagendar Reserva
                    </a>
                </div>
            </div>
        </g:else>
    </g:if>
    <g:if test="${esReservaHistorica}">
        <div class="row" >
            <g:if test="${!reserva?.evaluacion?.evaluacionToUser?.nota}">
                <div class="col-md-6" style="margin-bottom: 1em">
                    <a href="#" data-toggle="modal" data-target="#modalEvaluacionUser${reserva?.id}">
                        <button class="btn btn-block btn-info btn-lg mt-3">Evaluar</button>
                    </a>
                </div>
                <g:render template="/evaluacion/evaluacionToUser" model="[reserva: reserva]"/>

            </g:if>
            <g:if test="${!reserva?.valorFinal}">
                <div class="col-md-6" style="margin-bottom: 1em">
                    <a href="#" data-toggle="modal" data-target="#modalValorFinal${reserva?.id}">
                        <button class="btn btn-block btn-secondary btn-lg mt-3">Valor Final</button>
                    </a>
                </div>
                <g:render template="/reserva/setValorFinal" model="[reserva: reserva]"/>
            </g:if>
        </div>
    </g:if>
</sec:ifAnyGranted>
