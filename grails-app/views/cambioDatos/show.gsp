<%@ page import="espacio.TipoEspacio" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div id="show-espacio" class="content scaffold-show" role="main">
            <div id="panel-7" class="panel">
                <div class="panel-hdr">
                    <h2>
                        Datos <span class="fw-300"><i>Solicitud</i></span>
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                        <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                        <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
                    </div>
                </div>
                <div class="panel-container show">
                    <br>
                    <div class="form-group row">
                        <div class="col-md-6 col-sm-12">
                            <h2 style="text-align: center"><strong>DATOS EMPRESA</strong></h2>
        %{--                    <hr>--}%
                            <table class="table">
                                <tbody>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.nota.label" default="Giro" /></td>
                                    <td valign="top">${cambioDatos?.giro}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Razón Social" /></td>
                                    <td valign="top">${cambioDatos?.razonSocial}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Rut" /></td>
                                    <td valign="top">${cambioDatos?.rut}-${cambioDatos?.dv}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Dirección" /></td>
                                    <td valign="top">${cambioDatos?.direccion}</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="col-md-6 col-sm-12">
                            <h2 style="text-align: center"><strong>REPRESENTANTE LEGAL</strong></h2>
        %{--                    <hr>--}%
                            <table class="table">
                                <tbody>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.nota.label" default="Nombre" /></td>
                                    <td valign="top">${cambioDatos?.nombre}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Apellido Paterno" /></td>
                                    <td valign="top">${cambioDatos?.apellidoPaterno}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Apellido Materno" /></td>
                                    <td valign="top">${cambioDatos?.apellidoMaterno}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Celular" /></td>
                                    <td valign="top">${cambioDatos?.celular}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Fecha Nacimiento" /></td>
                                    <td valign="top"><g:formatDate format="dd-MM-yyyy" date="${cambioDatos?.fechaNac}"/></td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="espacio.descripcion.label" default="Rut" /></td>
                                    <td valign="top">${cambioDatos?.rutUser}-${cambioDatos?.dvUser}</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
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
