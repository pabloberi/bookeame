<%@ page import="gestion.General" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>


    <div id="show-reserva" class="content scaffold-show" role="main">
            <div id="panel-7" class="panel">
                <div class="panel-hdr">
                    <h2>
                        Soporte Técnico <span class="fw-300"></span>
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                        <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                        <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
                    </div>
                </div>
                    <div class="panel-container">
                        <div class="panel-content">
                            <div class="panel-tag" id="msjError" >
                                Ante cualquier duda o eventualidad envíanos un mensaje y nuestro equipo de soporte te responderá a la brevedad.
                            </div>

                            <hr>
                            <g:form controller="home" action="enviarCorreoSoporte" method="POST">
                                <div class="form-group row">
                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                        <label class="col-xl-12 form-label" for="Nombre">Nombre</label>
                                        <g:field type="text" id="Nombre" name="Nombre" class="form-control" required="" disabled="" value="${user?.nombre}"/>
                                    </div>
                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                        <label class="col-xl-12 form-label" for="correo">Correo</label>
                                        <g:field type="text" id="correo" name="correo" class="form-control" required="" disabled="" value="${user?.email}"/>
                                    </div>
                                    <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                        <label class="col-xl-12 form-label" for="mensaje">Mensaje</label>
                                        <g:textArea type="text" id="mensaje" name="mensaje" class="form-control" placeholder="Ingrese Mensaje" required=""/>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 ml-auto text-right" style="margin-bottom: 1em">
                                        <button type="submit" class="btn btn-block btn-info btn-lg mt-3" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Enviar Mensaje</button>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
            </div>
    </div>
    <script>
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

