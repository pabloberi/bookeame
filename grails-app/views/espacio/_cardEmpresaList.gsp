<asset:javascript src="pagination.js"/>
<g:if test="${empresaPackage?.size() == 0}">
    <center>No hay coincidencias.</center>
</g:if>
<g:if test="${empresaPackage?.size() > 0}">
<div class="frame-wrap">
    <nav aria-label="Page navigation example">
        <ul class="pagination justify-content-center">
            <li id="beforeButton" class=" page-item nav-item disabled">
                <a id="beforeLink" class="descontarPagina  page-link nav-link" href="#" data-toggle="tab" role="tab" tabindex="-1" aria-disabled="true">Anterior</a>
            </li>
            <g:hiddenField id="valorPage" name="valorPage" value="${pages}" />
            <% for (int p = 0; p < pages ; p++) { %>
            <g:if test="${p == 0}">
                <li class="buttonPage page-item nav-item active" aria-current="page" id="page${p}">
                    <a id="linkPage${p}"  class="linkPage page-link nav-link active" data-toggle="tab" role="tab" href="#tab-card${p}" onclick="pageSelected(${p});">
                        1
                        <span class="sr-only">(current)</span>
                    </a>
                </li>
            </g:if>
            <g:else>
                <li class="buttonPage page-item nav-item" id="page${p}">
                    <a id="linkPage${p}" class="linkPage page-link nav-link" data-toggle="tab" role="tab" href="#tab-card${p}" onclick="pageSelected(${p});">${p + 1}</a>
                </li>
            </g:else>
            <% }%>
            <li id="nextButton" class="page-item nav-item">
                <a id="nextLink" class="contarPagina page-link nav-link" data-toggle="tab" role="tab" href="#tab-card1">Siguiente</a>
            </li>
        </ul>
    </nav>
</div>
</g:if>
<div class="tab-content">
    <g:each in="${empresaPackage}" status="k" var="empresaList">
        <div class="card-deck tab-pane fade <%if(k == 0){%>show active<%}%>" id="tab-card${k}" role="tab"  aria-labelledby="tab-card${k}">
            <div class="row">
            <g:each in="${empresaList}" status="i" var="empresa">
                <div class= "carta col-xs-12 col-sm-6 col-md-4 col-lg-4 col-xl-3" style="margin-bottom: 2em;" >
                    <div class="container">
                        <ul class="nav nav-tabs">
                            <li class="nav-item">
                                <a href="#default-tab-1" id="tab1" data-toggle="tab" class="nav-link active">
                                    <span class="d-sm-none">${empresa?.key}</span>
                                    <span class="d-sm-block d-none">${empresa?.key}</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="card">
                        <div class="tab-pane fade active show" id="default-tab-1">
                            <g:form method="POST" controller="home" action="espaciosPorEmpresa" id="${empresa?.key?.id}">
                                <div id="carouselExampleControls${empresa?.key?.id}" class="carousel slide" data-ride="carousel">
                                    <div class="carousel-inner">
                                        <g:each in="${empresa?.value}" var="espacio" status="j">
                                            <g:hiddenField name="espacio" value="${espacio?.id}"/>
                                            <div class="carousel-item <% if( j == 0 ){ %> active <% } %>">
                                                <g:if test="${espacio?.foto}">
                                                    <asset:image class="d-block w-100" src="/imagenes/espacios/${espacio?.id}/${espacio?.foto}" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                                                </g:if>
                                                <g:else>
                                                    <asset:image class="d-block w-100" src="/imagenes/imagenNula.png" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                                                </g:else>
                                            </div>
                                        </g:each>
                                    </div>
                                    <a class="carousel-control-prev" href="#carouselExampleControls${empresa?.key?.id}" role="button" data-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="sr-only">Previous</span>
                                    </a>
                                    <a class="carousel-control-next" href="#carouselExampleControls${empresa?.key?.id}" role="button" data-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="sr-only">Next</span>
                                    </a>
                                </div>

                                <div class="w-100 bg-fusion-50 rounded-top" style="width: 25em;" ></div>

                                <div class="card-footer">
                                    <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 1em;">
                                        <button type="submit" class="btn btn-info btn-sm" title="Ir a Lista">${empresa?.value?.size()} Espacios</button>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
                </div>
            </g:each>
            </div>
        </div>
    </g:each>
</div>
<script>
    $('.carousel').carousel({
        interval: 2500
    })
</script>