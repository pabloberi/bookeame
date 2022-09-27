<g:form method="POST" controller="configuracionEmpresa" action="guardarConfiguracionFormaPago" id="${configuracionEmpresa?.id}">

    <div class="form-group">
        <label class="form-label">Permitir Formas de Pago</label>
        <div class="frame-wrap">
            <div class="custom-control custom-radio custom-control-inline custom-switch">
                <input onchange="ocultarDatosFlow()" type="checkbox" class="custom-control-input" name="prepago" id="prepago"  <%if(configuracionEmpresa?.tipoPago?.prepago) {%>checked=""<%}%> >
                <label class="custom-control-label" for="prepago">Pre pago</label>
            </div>
            <div class="custom-control custom-radio custom-control-inline custom-switch">
                <input type="checkbox" class="custom-control-input" name="pospago" id="pospago" <%if(configuracionEmpresa?.tipoPago?.pospago) {%>checked=""<%}%> >
                <label class="custom-control-label" for="pospago">Pos pago</label>
            </div>
        </div>
    </div>

    <div id="datosFlow">
        <h6>Datos Flow</h6>
        <hr>

        <div class="form-group">
            <label class="form-label" for="apiKey">ApiKey</label>
            <div class="input-group">
                <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fal fa-calendar-alt"></i></span>
                </div>
                <g:field type="text" id="apiKey" name="apiKey" class="form-control" placeholder="Ingrese ApiKey de Flow" required="" value="${flowEmpresa?.apiKey}"/>
            </div>
            <span class="help-block">Obtén este dato en flow.cl</span>
        </div>

        <div class="form-group">
            <label class="form-label" for="secretKey">SecretKey</label>
            <div class="input-group">
                <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fal fa-calendar-alt"></i></span>
                </div>
                <g:field type="text" id="secretKey" name="secretKey" class="form-control" placeholder="Ingrese SecretKey de Flow" required="" value="${flowEmpresa?.secretKey}"/>
            </div>
            <span class="help-block">Obtén este dato en flow.cl</span>
        </div>

        <div class="form-group">
            <label class="form-label" for="comision">Comisión</label>
            <div class="input-group">
                <g:select name="comision" id="comision" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${comisionList}" noSelection="['':'- Seleccione Comisión -']" value="${flowEmpresa?.comision?.id}"/>
            </div>
            <span class="help-block">Comsión de Flow por transacción ( Cargo al cliente )</span>
        </div>

    </div>

    <div class="col-sm-12 col-md-2 col-lg-2" style="float: right;">
        <div class="btn-group btn-group-sm">
            <button type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>
        </div>
    </div>
    <br><br>
</g:form>
