<%@ page import="reserva.Reserva" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>
</head>
<body>
<asset:stylesheet src="app.bundle.css"/>

<asset:stylesheet src="miscellaneous/jqvmap/jqvmap.bundle.css"/>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>



<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Calendario <span class="fw-300"><i>${espacio?.nombre}</i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>

    <div class="panel-container show">

        <div class="panel-content">
            <div class="alert bg-fusion-400 border-0 fade show">
                <div class="d-flex align-items-center">
                    <div class="alert-icon">
                        <i class="fal fa-th text-warning"></i>
                    </div>
                    <div class="flex-1">
                        <span class="h5">Selecciona el servicio que necesitas</span>
                        <br>
                    </div>
                </div>
            </div>
        </div>

        <div class="panel-content">
            <div class="flex-1" style="background: no-repeat center bottom fixed; background-size: cover;">
                    <div >
                        <div class="panel-container show">
                            <div class="panel-content">
                                <div class="border px-3 pt-3 pb-0 rounded">
                                    <ul class="nav nav-pills" role="tablist">
                                        <li class="nav-item"><a class="nav-link  " data-toggle="tab" href="#v-pills-0"><i class="fal fa-plus-circle mr-1"></i> Servicios</a></li>
                                    </ul>
                                    <script>
                                        $( document ).ready(function() {
                                            $('#v-pills-0').addClass('show');
                                            $('#v-pills-0').addClass('active');
                                        });
                                    </script>
                                    <div class="tab-content py-3">

                                        <div class="tab-pane" id="v-pills-0" role="tabpanel" aria-labelledby="v-pills-home-tab">
                                            <g:each in="${servicioList}" status="i" var="servicio">
                                                <a href="<g:createLink controller="reserva" action="calendarioServicio" id="${espacio?.id}" params="[ servicio: servicio?.id]" />">
                                                    <div class="accordion accordion-hover" id="js_demo_accordion-${servicio?.id}">
                                                        <div class="card">
                                                            <div class="card-header">
                                                                <div href="javascript:void(0);" class="card-title collapsed" data-toggle="collapse" data-target="#js_demo_accordion-sub-${servicio?.id}" aria-expanded="false">
                                                                <i class="fal fa-caret-right width-2 fs-xl"></i>
                                                                ${servicio?.nombre}

                                                                <span class="ml-auto">
                                                                    <span class="collapsed-reveal">
                                                                        $ ${servicio?.valor} .-
%{--                                                                        <i class="fal fa-chevron-right fs-xl"></i>--}%
                                                                    </span>
                                                                    <span class="collapsed-hidden">
                                                                        $ ${servicio?.valor} .-
%{--                                                                        <i class="fal fa-chevron-right fs-xl"></i>--}%
                                                                    </span>
                                                                </span>
                                                            </div>
                                                        </div>
                                                        </div>
                                                    </div>
                                                </a>
                                            </g:each>
                                        </div>

                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
            </div>
        </div>

    </div>
</div>

<asset:javascript src="dependency/moment/moment.js"/>
<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<script>
    $('.select2').select2();

    <g:if test="${flash.message}">
    $(document).ready( function () {
        toastr.success("${flash.message}");
    });
    </g:if>
    <g:if test="${flash.error}">
    $(document).ready( function () {
        toastr.warning("${flash.error}");
    });
    </g:if>

</script>
</body>
</html>
