<sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_USER">

        <div class="row" style="margin-bottom: 1em; display: flex; justify-content: center;">
            <g:if test="${ puedeCancelar }">
                <div class="col-md-5 ">
                    <a href="${createLink(controller: 'reserva', action: 'eliminarReserva', id: reserva?.id)}" class="btn btn-danger btn-block btn-md mt-3" title="Cancelar"
                       onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                        Cancelar Reserva
                    </a>
                </div>
            </g:if>
            <g:if test="${ puedeReagendar }">
                <div class="col-md-5" style="color: white;">
                    <a   data-toggle="modal" data-target="#modalReagendar"
                         class="btn btn-info btn-block btn-md mt-3" title="Reagendar">
                        Reagendar Reserva
                    </a>
                </div>
            </g:if>
        </div>
</sec:ifAnyGranted>
