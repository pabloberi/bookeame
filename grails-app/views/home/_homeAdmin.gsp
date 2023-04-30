<%@ page import="gestion.General" %>
<!DOCTYPE html>


    <!-- Card decks -->
    <div id="panel-11" class="panel">
        <div class="panel-hdr">
            <h2>
                Dashboard <span class="fw-300"><i></i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <!-- Card decks -->

            <div class="panel-container show">
                <div class="panel-content">
                    <g:if test="${espacioList?.size() > 0 }">
                    <div class="panel-tag">
                        Promociona tus espacios con un acceso directo para tus clientes
                        <a href="#" id="copiarPortapapeles" title="Copiar Link"><i class="fal fa-clone" aria-hidden="true"></i></a><span id="copyAnswer"></span>
                    </div>
                    </g:if>
                    <div class="card-deck">
                        <g:each in="${espacioList}" status="i" var="espacio">
                            <div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 col-xl-3" style="margin-bottom: 2em;">
                                <div class="card">
                                    <g:if test="${espacio?.foto}">
                                        <asset:image src="/imagenes/espacios/${espacio?.id}/${espacio?.foto}" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                                    </g:if>
                                    <g:else>
                                        <asset:image src="/imagenes/imagenNula.png" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                                    </g:else>
                                    <div class="w-100 bg-fusion-50 rounded-top" style="width: 25em;" >
%{--                                        bg-fusion-50--}%
                                    </div>
                                    <div class="card-body">
                                        <h5 class="card-title">${espacio?.nombre} <b style="float: right;">${g.formatNumber(format: "###,##0", number: espacio?.notaUsuarios , maxFractionDigits: 1) } <span><i class="fal fa-star"></i></span></b></h5>
                                        <p class="card-text">${espacio.descripcion}</p>
                                    </div>
                                    <div class="card-footer">
                                        <div style="float: left;">
                                            <span style=" height: 15px; width: 15px; background-color: ${ espacio?.enabled ? '#319529' : '#CE2F08' }; border-radius: 50%; display: inline-block;"></span>
                                        </div>
                                        <div class="btn-group btn-group-sm" style="float: right;">
                                            <a href="${createLink(controller: 'reserva', action: 'calendario', id: espacio?.id)}" class="btn btn-info btn-sm" title="Crear Reserva"><i class="fal fa-calendar-alt"></i></a>
                                            <a href="${createLink(controller: 'espacio', action: 'modulos', id: espacio?.id)}" class="btn btn-secondary btn-sm" title="Módulos"><i class="fal fa-cog"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </g:each>
                    </div>
                </div>
            </div>
    </div>


<script>
    // Establecemos las variables
    var answer = document.getElementById("copyAnswer");
    var copy   = document.getElementById("copiarPortapapeles");
    copy.addEventListener('click', function(e) {
        var aux = document.createElement("input");
        aux.setAttribute("value","${General.findByNombre('baseUrl')?.valor}/home/showPreview/${empresaId}");
        document.body.appendChild(aux);
        aux.select();
        try {
            // Copiando el texto seleccionado
            var successful = document.execCommand('copy');

            if(successful) answer.innerHTML = 'Copiado!';
            else answer.innerHTML = 'Incapaz de copiar!';
        } catch (err) {
            answer.innerHTML = 'Browser no soportado!';
        }
        // document.execCommand("copy");
        document.body.removeChild(aux);
    });
</script>
