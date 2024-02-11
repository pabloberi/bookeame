<%@ page import="configuracionEmpresa.ConfiguracionEmpresa; gestion.General" %>
<!DOCTYPE html>

<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

    <sec:ifAnyGranted roles="ROLE_USER">
        <g:if test="${reserva?.tipoReserva?.id == 1 && reserva?.estadoReserva?.id == 1 }">
            <div class="panel-tag">
                <p>Recuerda que tu reserva será válida cuando la empresa acepte tu solicitud. Verifica el ESTADO de tu reserva.</p>
            </div>
        </g:if>
        <g:render template="modalPoliticas" />

    </sec:ifAnyGranted>

    <div id="panel-11" class="panel">
        <div class="panel-hdr">
            <h2>
                Reserva <span class="fw-300"><i class="fal fa-calendar-alt"></i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">
                <div class="border px-3 pt-3 pb-0 rounded">
                    <ul class="nav nav-pills" role="tablist">
                        <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#ficha"><i class="fal fa-list mr-1"></i>Ficha</a></li>
                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#registro_pago"><i class="fal fa-dollar-sign mr-1"></i>Registro de Pagos</a></li>
                            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#evaluacion"><i class="fal fa-star mr-1"></i>Evaluación Cliente</a></li>
                        </sec:ifAnyGranted>
                    </ul>
                    <div class="tab-content py-3 mt-4">
                        <div class="tab-pane fade show active" id="ficha" role="tabpanel">
                            <g:render template="fichaReserva"/>
                        </div>
                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            <div class="tab-pane fade" id="registro_pago" role="tabpanel">
                                <g:render template="registroPagos"/>
                            </div>
                            <div class="tab-pane fade" id="evaluacion" role="tabpanel">
                                <g:render template="evaluacionAlCliente"/>
                            </div>
                        </sec:ifAnyGranted>
                    </div>
                </div>
            </div>
        </div>
    </div>

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
        <g:if test="${politicaReservaList?.size() > 0 }">
            $(document).ready( function () {
                $('#modalPoliticas').modal('show');
            });
        </g:if>
    </script>
    </body>
</html>
