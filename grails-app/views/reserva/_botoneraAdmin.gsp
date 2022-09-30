<sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_ADMIN">
    <g:if test="${ reserva?.terminoExacto >= hoy }"> <!-- VALIDA SI LA RESERVA ES FUTURA-->
        <g:if test="${reserva?.estadoReserva?.id == 1 && reserva?.tipoReserva?.id == 1}"> <!-- VALIDA SI LA RESERVA ESTA EN ESTADO PENDIENTE Y SI ES TIPO POSPAGO-->
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
            <div class="row">
                <div class="col-md-6 ml-auto text-right" style="margin-bottom: 1em">
                    <g:link controller="reserva" action="${ reserva?.tipoReserva?.id != 2 ? 'eliminarReserva' : 'declaracionEliminacionPrepago'}" id="${reserva?.id}">
                        <button class="delete btn btn-block btn-danger btn-lg mt-3" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Eliminar Reserva</button>
                    </g:link>
                </div>
            </div>
        </g:else>
    </g:if>
    <g:if test="${reserva?.terminoExacto < hoy && reserva?.estadoReserva?.id == 2 }">
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
