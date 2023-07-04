<g:form method="POST" controller="reserva" action="save" enctype="multipart/form-data" role="form"
        params="[fechaReserva: fechaReserva, code: token, moduloId: modulo?.id, espacioId: espacio?.id]">
    <div class="panel-container show">

        <div class="panel-content">
            <div class="form-group">
                <label class="form-label" for="fechaReserva">Fecha de Reserva</label>
                <div class="input-group has-length">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fal fa-calendar-alt"></i></span>
                    </div>
                    <input type="text" id="fechaReserva" class="form-control" placeholder="Fecha de Reserva" aria-label="Fecha de Reserva"
                           value="<g:formatDate type="date" style="FULL" date="${fecha}"/>" readonly />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="horaInicio">Hora Inicio</label>
                <div class="input-group has-length">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fal fa-clock"></i></span>
                    </div>
                    <input type="text" name="horaInicio" id="horaInicio" class="form-control" placeholder="Hora Inicio" aria-label="Hora Inicio"
                           value="${modulo?.horaInicio}" readonly />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="horaTermino">Hora Término</label>
                <div class="input-group has-length">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fal fa-clock"></i></span>
                    </div>
                    <input type="text" name="horaTermino" id="horaTermino" class="form-control" placeholder="Hora Término" aria-label="Hora Término"
                           value="${modulo?.horaTermino}" readonly />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="valor">Valor</label>
                <div class="input-group has-length">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fal fa-dollar-sign"></i></span>
                    </div>
                    <input type="text" name="valor" id="valor" class="form-control" placeholder="Valor" aria-label="Valor"
                           value="${modulo?.valor}" readonly />
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="espacio">Espacio</label>
                <div class="input-group has-length">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fal fa-building"></i></span>
                    </div>
                    <input type="text" name="espacio" id="espacio" class="form-control" placeholder="Espacio" aria-label="Espacio"
                           value="${espacio}" readonly />
                </div>
            </div>

                <div class="form-group">
                    <label class="form-label" for="direccion">Dirección</label>
                    <div class="input-group has-length">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fal fa-map-marker-alt"></i></span>
                        </div>
                        <input type="text" id="direccion" class="form-control" placeholder="Dirección" aria-label="Dirección" aria-describedby="Dirección"
                               value="${espacio?.direccion}, ${espacio?.comuna}, ${espacio?.comuna?.provincia?.region}" disabled="">
                    </div>
                </div>
        </div>


        <div class="row" style="margin-bottom: 1em; display: flex; justify-content: center; margin-left: 1em; margin-right: 1em;">
            <g:if test="${pospago  && session['link'] == null}">
                <div class="col-md-5 ">
                    <button onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" name="tipoReservaId" value="1"
                            id="reservaPospago" type="submit" class="btn btn-secondary btn-block btn-md mt-3">
                        Pago Presencial
                    </button>
                </div>
            </g:if>
            <g:if test="${prepago && session['link'] == null}">
                <div class="col-md-5">
                    <button id="reservaPrepago" type="submit" class="btn btn-outline-success btn-block btn-md mt-3" name="tipoReservaId" value="2"
                            onclick="return confirm('${message(code: 'aviso.cargo.adicional.prepago', default: 'Are you sure?')}');">
                            Pago en Linea + $ ${comision - modulo?.valor} .-
                    </button>
                </div>
            </g:if>
        </div>

    </div>
</g:form>
