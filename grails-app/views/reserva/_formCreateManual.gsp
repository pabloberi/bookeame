<g:form method="POST" controller="reserva" action="saveManual" enctype="multipart/form-data" role="form"
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

            <sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_ADMIN">
                <div class="form-group">
                    <label class="form-label" for="inputBuscador">Buscar Usuario</label>
                    <div class="input-group has-length">
                        <div class="input-group-prepend">
                            <span class="input-group-text"><i class="fal fa-search"></i></span>
                        </div>
                        <input type="text" id="inputBuscador" class="form-control" placeholder="usuario" aria-label="usuario" aria-describedby="usuario"
                               value="" onkeyup="buscarCliente(this.value);">
                    </div>
                    <div id="correo"></div>
                </div>
            </sec:ifAnyGranted>
        </div>
    </div>
</g:form>
