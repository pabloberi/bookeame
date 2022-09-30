<g:form method="POST" controller="configuracionEmpresa" action="guardarConfiguracionReserva" id="${configuracionEmpresa?.id}">
    <div class="form-group">
        <label class="form-label" for="diasAMostrar">Fecha máxima reservas</label>
        <div class="input-group">
            <div class="input-group-prepend">
                <span class="input-group-text"><i class="fal fa-calendar-alt"></i></span>
            </div>
            <g:field type="number" id="diasAMostrar" min="2" max="30" name="diasAMostrar" class="form-control" placeholder="Ingrese un número entre 2 y 30" required="" value="${configuracionEmpresa?.diasAMostrar}"/>
        </div>
        <span class="help-block">Permitir reservas dentro de un plazo máximo.</span>
    </div>

    <div class="form-group">
        <label class="form-label" for="periodoCambioReserva">Permisos Clientes</label>
        <div class="input-group">
            <g:field type="number" id="periodoCambioReserva" min="0" max="100" step="1" name="periodoCambioReserva" class="form-control"
                     aria-label="Text input with checkbox" placeholder="Tiempo de anticipación en Horas" value="${configuracionEmpresa?.periodoCambioReserva}"
                        disabled=" ${!configuracionEmpresa?.permitirCancelar && !configuracionEmpresa?.permitirReagendar} " />
            <div class="input-group-append">
                <div class="input-group-text">
                    <div class="custom-control d-flex custom-switch">
                        <input id="permitirCancelar" type="checkbox" class="custom-control-input" name="permitirCancelar"
                               <%if(configuracionEmpresa?.permitirCancelar) {%>checked=""<%}%> >
                        <label class="custom-control-label fw-500" for="permitirCancelar">Cancelar reservas</label>
                    </div>
                </div>
                <div class="input-group-text">
                    <div class="custom-control d-flex custom-switch">
                        <input id="permitirReagendar" type="checkbox" class="custom-control-input" name="permitirReagendar"
                               <%if(configuracionEmpresa?.permitirReagendar) {%>checked=""<%}%> >
                        <label class="custom-control-label fw-500" for="permitirReagendar">Reagendar reservas</label>
                    </div>
                </div>
            </div>
        </div>
        <span class="help-block">Horas de anticipación. Si no necesita tiempo de anticipacion ingrese 0.</span>

    </div>



    <div class="col-sm-12 col-md-2 col-lg-2" style="float: right;">
        <div class="btn-group btn-group-sm">
            <button type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>
        </div>
    </div>
    <br><br>
</g:form>
