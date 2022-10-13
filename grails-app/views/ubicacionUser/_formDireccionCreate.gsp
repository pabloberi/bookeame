<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
%{--<div class="panel-tag">--}%
%{--    <p>Está herramienta te permitirá...</p>--}%
%{--</div>--}%
<div id="panel-7" class="panel">

    <div class="panel-hdr">
        <h2>
            Dirección <span class="fw-300">Nueva</span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content">
            <g:form method="POST" controller="ubicacionUser" action="crearDireccion">
                <div class="form-group row">
                    <div class="form-group col-xs-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
                        <label class="form-label">Región</label>
                        <div class="input-group">
                            <g:select name="region" id="region" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${ubicacion.Region.list()}" noSelection="['':'- Seleccione Región-']" onchange="cargarComuna(this.value)" value="${region?.id}"/>
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
                        <label class="form-label">Comuna</label>
                        <div class="input-group">
                            <g:select name="comuna" id="comuna" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${comunaList}" noSelection="['':'- -']"  value="${ params?.comuna }" />
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
                        <label class="form-label">Dirección</label>
                        <input type="text" class="form-control" name="direccion" id="direccion" value="${ubicacionUser?.direccion}" >
                    </div>

                </div>

                <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
                    <button type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>
                    <button type="button" class=" btn btn-dark btn-sm" title="Cancelar" onclick="cancelar()">Cancelar</button>
                    %{--<a href="${createLink(controller: 'ubicacionUser', action: 'index')}" class="btn btn-secondary btn-sm" title="Cancelar">Cancelar</a>--}%
                </div>
            </g:form>

        </div>
    </div>
</div>

<asset:javascript src="/formplugins/select2/select2.bundle.js"/>
<script>

    $('.select2').select2();


    function cancelar(){
        document.getElementById("formularioNuevo").innerHTML="";
        sleep(500);
    }
</script>