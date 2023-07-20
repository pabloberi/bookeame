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
    <div id="show-reserva" class="content scaffold-show" role="main">
            <div id="panel-7" class="panel">
                <div class="panel-hdr">
                    <h2>
                        Crear <span class="fw-300"><i>Reserva</i></span>
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                        <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                        <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
                    </div>
                </div>
                <sec:ifAnyGranted roles="ROLE_USER">
                    <g:render template="formCreateCliente"/>
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <g:render template="formCreateManual"/>
                </sec:ifAnyGranted>
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

            function buscarCliente(valor) {
                $('#inputBuscador').attr('disabled', true);
                $('#inputBuscador').blur();
                $('#correo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>')
                // var moduloId = document.getElementById('moduloId').value;
                // var fechaReserva = document.getElementById('fechaReservaHidden').value;
                var moduloId = ${ modulo?.id ?: 0 };
                var fechaReserva =  "";
                if( valor.length >= 4 ) {
                    $.ajax({
                        type: 'POST',
                        url: '${g.createLink(controller: 'user', action: 'busquedaInteligenteAdmin')}',
                        data: {
                            valor: valor,
                            roleString: "ROLE_USER",
                            moduloId: moduloId,
                            fechaReserva: fechaReserva
                        },
                        success: function (data, textStatus) {
                            $('#correo').html(data);
                            $('#inputBuscador').attr('disabled', false);
                            $('#inputBuscador').focus();
                        }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $('#inputBuscador').attr('disabled', false);
                            $('#inputBuscador').focus();
                        }
                    });
                }else{
                    $('#correo').html('');
                    $('#inputBuscador').attr('disabled', false);
                    $('#inputBuscador').focus();
                }
            }

        </script>
    </body>
</html>
