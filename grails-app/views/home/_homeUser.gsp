<%@ page import="auth.User; espacio.Categoria; ubicación.Comuna; ubicación.Region; espacio.TipoEspacio" %>
<!DOCTYPE html>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

    <div class="panel-tag">
        Descarga la app "Bookeame" para Android en Google Play. ${usuario?.tokenFirebase}
    </div>
<div id="panel-6" class="panel">
    <div class="panel-hdr bg-primary-700 bg-success-gradient">
        <h2>
            ¿Qué estás buscando? <span class="fw-300"></span>
        </h2>
    </div>
    <div class="panel-container show">
        <div class="panel-content">
%{--            <g:form method="POST" controller="home" action="dashboard">--}%
                <div class="row">
                    <div class="col-md-4">
                        <label class="form-label" for="region">Región</label>
                        <div class="input-group">
                            <g:select name="region" id="region" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${Region.list()}" noSelection="['':'- Seleccione Región-']" onchange="cargarComuna(this.value);" value="${region?.id}"/>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="region">Comuna</label>
                        <div class="input-group">
                            <g:select name="comuna" id="comuna" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${comunaList}" noSelection="['':'- -']"  value="${ params?.comuna }" />
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label" for="region">Categorías</label>
                        <div class="input-group">
%{--                            <g:select name="categoria" id="categoria" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${Categoria.findAllByEnabled(true)}" noSelection="['':'- Categoría -']" />--}%
                            <select name="categoria" id="categoria" class="form-control select2" style="width: 100%;" optionKey="id" required=""  >
                                <option value="">-Seleccione Categoría -</option>
                                <g:each in="${Categoria.findAllByEnabled(true)}" status="i" var="categoria">
                                    <optgroup label="${categoria}">
                                        <g:each in="${TipoEspacio.findAllByCategoriaAndEnabled(categoria, true)}" status="j" var="subCategoria">
                                            <option value="${subCategoria?.id}">${subCategoria}</option>
                                        </g:each>
                                    </optgroup>
                                </g:each>
                            </select>
                        </div>
                    </div>
                </div>
                <div style="float:right; margin-bottom: 1em; margin-top: 1em;">
                    <button class="btn btn-info" type="button" onclick="cargarEspacios();">Buscar</button>
                    <a class="btn btn-light" href="${createLink(controller: 'home', action: 'dashboard')}">Limpiar</a>
                </div>
%{--            </g:form>--}%

        </div>
    </div>
</div>
<div id="panel-11" class="panel">
    <div class="panel-hdr">
        <h2>
            Resultados de tu búsqueda <span class="fw-300"><i></i></span>
        </h2>
%{--        <div class="panel-toolbar">--}%
%{--            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>--}%
%{--            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>--}%
%{--            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>--}%
%{--        </div>--}%
    </div>
    <div class="panel-container show">
        <div class="panel-content row"></div>
    </div>

    <div class="panel-container show">
        <div class="panel-content" id="divEspacios">

%{--            <div class="card-deck" >--}%
%{--            <g:render template="/espacio/cardEspacioList" model="[espacioList: espacioList]" />--}%
%{--            </div>--}%
        </div>

    </div>
</div>

<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<script>

    $('.select2').select2();
    function filtrarTipoEspacio() {
        var tipo = document.getElementById("tipoEspacio").value;
        console.log(tipo)
        if(tipo.length > 0 ) {
            $('.carta').each(function (index) {
                // console.log( $(this).value );
                if ($(this).attr('value') === tipo) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }
    }

    function limpiarFiltro() {
        $('.carta').each(function(index) {
            $(this).show();
        });
    }

    function cargarComuna(regionId){
        $.ajax({
            type:'POST',
            url:'${g.createLink(controller: 'home', action: 'cargarComuna')}',
            data:{regionId:regionId},
            success:function(data,textStatus){$('#comuna').html(data);},error:function(XMLHttpRequest,textStatus,errorThrown){}});
    }

    function cargarEspacios(){
        $('#divEspacios').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Buscando</center>')

        var regionId = document.getElementById('region').value;
        var comuna = [...$("#comuna :selected")].map(e => e.value);
        var categoria = document.getElementById('categoria').value;

        $.ajax({
            type:'POST',
            url:'${g.createLink(controller: 'home', action: 'cargarEspacios')}',
            data:{ regionId: regionId, comunaStr: JSON.stringify(comuna), categoria: categoria },
            success:function(data,textStatus){$('#divEspacios').html(data); sleep(1000);},error:function(XMLHttpRequest,textStatus,errorThrown){}});
    }

    function sleep(milisegundos) {
        var comienzo = new Date().getTime();
        while (true) {
            if ((new Date().getTime() - comienzo) > milisegundos)
                break;
        }
    }

    //
    // $("#comuna").on('change', function(e) {
    //     if (Object.keys($(this).val()).length > 2) {
    //         $('#comuna').addClass('')
    //     }
    // });
    // $("#comuna").on("click", "option", function () {
    //     if ( 3 <= $(this).siblings(":selected").length ) {
    //         $(this).removeAttr("selected");
    //     }
    // });​​​​​​​​​​
</script>

