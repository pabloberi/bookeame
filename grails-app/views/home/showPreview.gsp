%{--<asset:javascript src="pagination.js"/>--}%
<g:applyLayout name="template">
    <link rel="stylesheet" media="screen, print" href="css/fa-brands.css">
    <div class="page-wrapper auth">
        <div class="page-inner bg-brand-gradient">
            <div class="page-content-wrapper bg-transparent m-0">
                <div class="height-10 w-100 shadow-lg px-4 bg-brand-gradient">
                    <div class="d-flex align-items-center container p-0">

                        <div class="page-logo width-mobile-auto m-0 align-items-center justify-content-center p-0 bg-transparent bg-img-none shadow-0 height-9">
                            <a href="javascript:void(0)" class="page-logo-link press-scale-down d-flex align-items-center">
                                <asset:image src="bookeame/full-blanco.png" alt="" style="width: 160px; height: 53px;" />
                                %{--                                <span class="page-logo-text mr-1">Agenda En Línea</span>--}%
                            </a>
                        </div>
                        <span class="text-white opacity-50 ml-auto mr-2 hidden-sm-down">
                        </span>
                        <a href="${createLink(controller: 'user', action: 'registro')}" class="btn-link text-white ml-auto ml-sm-0">
                            Crear Cuenta
                        </a>
                    </div>
                </div>
                <div class="flex-1" style="background: no-repeat center bottom fixed; background-size: cover;">
                    <div class="container py-4 py-lg-5 my-lg-5 px-4 px-sm-0">
                        <div class="panel-tag">
                            Si quieres reservar en ${empresa?.razonSocial} ¡Entra ya!
                        </div>
                        <g:form method="POST" controller="home" action="espaciosPorEmpresaOut" id="${empresa?.id}" >
                        <div class="container" style=" display: flex; justify-content: center;">

                            <div class="col-sm-8 col-md-6 col-lg-4 col-xl-4 " style="height: auto; margin-bottom: 2em;">
                                <div style="width: 100%; height:auto;">
                                    <div class="container">
                                        <ul class="nav nav-tabs">
                                            <li class="nav-item">
                                                <a href="#default-tab-1" id="tab1" data-toggle="tab" class="nav-link active">
                                                    <span class="d-sm-none">${empresa?.razonSocial}</span>
                                                    <span class="d-sm-block d-none">${empresa?.razonSocial}</span>
                                                </a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="card">
                                        <div class="tab-pane fade active show" id="default-tab-1">
                                                <div id="carouselExampleControls${empresa?.id}" class="carousel slide" data-ride="carousel">
                                                    <div class="carousel-inner">
                                                        <g:each in="${espacioList}" var="espacio" status="j">
%{--                                                            <g:hiddenField name="espacio" value="${espacio?.id}"/>--}%
                                                            <div class="carousel-item <% if( j == 0 ){ %> active <% } %>">
                                                                <g:if test="${espacio?.foto}">
                                                                    <asset:image class="d-block w-100" src="/imagenes/espacios/${espacio?.id}/${espacio?.foto}" alt="" style="width:auto; height: auto; max-height: 20em; max-width: 100%;"/>
                                                                </g:if>
                                                                <g:else>
                                                                    <asset:image class="d-block w-100" src="/imagenes/imagenNula.png" alt="" style="width:auto; height: auto; max-height: 20em; max-width: 100%;"/>
                                                                </g:else>
                                                            </div>
                                                        </g:each>
                                                    </div>
                                                    <a class="carousel-control-prev" href="#carouselExampleControls${empresa?.id}" role="button" data-slide="prev">
                                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                                        <span class="sr-only">Previous</span>
                                                    </a>
                                                    <a class="carousel-control-next" href="#carouselExampleControls${empresa?.id}" role="button" data-slide="next">
                                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                                        <span class="sr-only">Next</span>
                                                    </a>
                                                </div>
                                                <div class="w-100 bg-fusion-50 rounded-top" style="width: 25em;" >
                                                    <div class="card p-4 border-top-left-radius-0 border-top-right-radius-0">
                                                        <button type="submit" class="btn btn-default float-right">Entrar</button>
                                                    </div>
                                                </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

%{--                            <div class="col-sm-8 col-md-6 col-lg-5 col-xl-4 ml-auto" style="margin: auto;" >--}%
%{--                                <div class="page-logo m-0 w-100 align-items-center justify-content-center rounded border-bottom-left-radius-0 border-bottom-right-radius-0 px-4">--}%
%{--                                    <a href="javascript:void(0)" class="page-logo-link press-scale-down d-flex align-items-center">--}%
%{--                                        <asset:image src="/bookeame/full-blanco.png" aria-roledescription="logo" style="margin-right: 8em; width: 150px; height: 49px;"/>--}%

%{--                                        --}%%{--            <span class="page-logo-text mr-1">Agenda En Línea</span>--}%
%{--                                        <i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>--}%
%{--                                    </a>--}%
%{--                                </div>--}%
%{--                                <div class="card p-4 border-top-left-radius-0 border-top-right-radius-0">--}%
%{--                                    <button type="submit" class="btn btn-default float-right">Entrar</button>--}%
%{--                                </div>--}%
%{--                            </div>--}%

                        </div>
                        </g:form>
                        <div class="position-absolute pos-bottom pos-left pos-right p-3 text-center text-white">
                            BOOKEAME <script>document.write(new Date().getFullYear())</script>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</g:applyLayout>