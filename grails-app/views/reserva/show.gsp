<%@ page import="configuracionEmpresa.ConfiguracionEmpresa; gestion.General" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <% def telefono = ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa)?.fono %>
%{--    <g:render template="/layouts/botonera" params="[controlador: 'Reserva', metodo:'Ver más' ]" />--}%
    <sec:ifAnyGranted roles="ROLE_USER">
        <g:if test="${reserva?.tipoReserva?.id == 1 && reserva?.estadoReserva?.id == 1 }">
            <div class="panel-tag">
                <p>Recuerda que tu reserva será válida cuando la empresa acepte tu solicitud. Verifica el ESTADO de tu reserva.</p>
            </div>
        </g:if>
        <g:if test="${reserva?.inicioExacto > new Date()}">
            <div class="panel-tag">
                <p>Si necesitas cancelar una reserva contáctate directamente con el lugar que reservaste al ${telefono}.</p>
            </div>
        </g:if>
    </sec:ifAnyGranted>

    <div id="show-reserva" class="content scaffold-show" role="main">
            <div id="panel-7" class="panel">
                <div class="panel-hdr">
                    <h2>
                        Ficha <span class="fw-300"><i>Reserva</i></span>
                    </h2>
                    <div class="panel-toolbar">
                        <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                        <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                        <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
                    </div>
                </div>
                    <div class="panel-container show">
                        <table class="table">
                            <tbody>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.valor.label" default="Código" /></td>
                                <td valign="top" class="value">${fieldValue(bean: reserva, field: "codigo")}</td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.fechaReserva.label" default="Fecha de Reserva" /></td>
                                <td valign="top" class="value"><g:formatDate type="date" style="FULL" date="${reserva?.fechaReserva}"/></td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.fechaReserva.label" default="Horario" /></td>
                                <td valign="top" class="value">${reserva?.horaInicio} - ${reserva?.horaTermino}</td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.valor.label" default="Valor" /></td>
                                <td valign="top" class="value">$ ${fieldValue(bean: reserva, field: "valor")} .-</td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.espacio.label" default="Espacio" /></td>
                                <td valign="top" class="value">${fieldValue(bean: reserva, field: "espacio")}</td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.estadoReserva.label" default="Estado Reserva" /></td>
                                <td valign="top" class="value">${fieldValue(bean: reserva, field: "estadoReserva")}</td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name"><g:message code="reserva.tipoReserva.label" default="Tipo Reserva" /></td>
                                <td valign="top" class="value">${fieldValue(bean: reserva, field: "tipoReserva")}</td>
                            </tr>
                            <sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_ADMIN">
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="reserva.usuario.label" default="Usuario" /></td>
                                    <td valign="top" class="value">${fieldValue(bean: reserva, field: "usuario")}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="reserva.usuario.label" default="Celular Usuario" /></td>
                                    <td valign="top" class="value">${reserva?.usuario?.celular}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="reserva.usuario.label" default="Nombre" /></td>
                                    <td valign="top" class="value">${reserva?.usuario?.nombre} ${reserva?.usuario?.apellidoPaterno}</td>
                                </tr>
                            </sec:ifAnyGranted>
                            <sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_USER">
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="mapa.enabled.label" default="Dirección" /></td>
                                    <td valign="top" class="value" >${reserva?.espacio?.direccion}, ${reserva?.espacio?.comuna}, ${reserva?.espacio?.comuna?.provincia?.region}</td>
                                </tr>
                                <tr class="prop">
                                    <td valign="top" class="name"><g:message code="mapa.enabled.label" default="Contacto Empresa" /></td>
                                    <td valign="top" class="value" >${telefono}</td>
                                </tr>

                            </sec:ifAnyGranted>
                            </tbody>
                        </table>

                        <sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_ADMIN">
                            <g:if test="${ reserva?.terminoExacto >= new Date() }">
                                <g:if test="${reserva?.estadoReserva?.id == 1 && reserva?.tipoReserva?.id == 1}">
                                    <div class="row" style="margin-bottom: 1em; display: flex; justify-content: center;">
                                        <div class="col-md-5 ">
                                            <a href="${createLink(controller: 'reserva', action: 'aprobarSolicitud', id: reserva?.id)}" class="btn btn-info btn-block btn-md mt-3" title="Aprobar">
                                                Aprobar
                                            </a>
                                        </div>
                                        <div class="col-md-5">
                                            <a href="${createLink(controller: 'reserva', action: 'cancelarSolicitud', id: reserva?.id)}" class="btn btn-danger btn-block btn-md mt-3" title="Rechazar" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                                                Rechazar
                                            </a>
                                        </div>

                                    </div>
                                </g:if>
                                <g:else>
                                    <div class="row">
                                        <div class="col-md-6 ml-auto text-right" style="margin-bottom: 1em">
                                            <g:link controller="reserva" action="${ reserva?.tipoReserva?.id != 2 ? 'eliminarReserva' : 'declaracionEliminacionPrepago'}" id="${reserva?.id}">
                                                <button class="delete btn btn-block btn-danger btn-lg mt-3" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Eliminar Reserva</button>
                                            </g:link>
                                        </div>
                                    </div>
                                </g:else>
                            </g:if>
                            <g:if test="${reserva?.terminoExacto < new Date() && reserva?.estadoReserva?.id == 2 }">
                                <div class="row" >
                                    <g:if test="${!reserva?.evaluacion?.evaluacionToUser?.nota}">
                                        <div class="col-md-6" style="margin-bottom: 1em">
                                            <a href="#" data-toggle="modal" data-target="#modalEvaluacionUser${reserva?.id}">
                                                <button class="btn btn-block btn-info btn-lg mt-3">Evaluar</button>
                                            </a>
                                        </div>
                                        <g:render template="/evaluacion/evaluacionToUser" model="[reserva: reserva]"/>

                                    </g:if>
                                    <g:if test="${!reserva?.valorFinal}">
                                        <div class="col-md-6" style="margin-bottom: 1em">
                                            <a href="#" data-toggle="modal" data-target="#modalValorFinal${reserva?.id}">
                                                <button class="btn btn-block btn-secondary btn-lg mt-3">Valor Final</button>
                                            </a>
                                        </div>
                                        <g:render template="/reserva/setValorFinal" model="[reserva: reserva]"/>
                                    </g:if>
                                </div>
                            </g:if>
                        </sec:ifAnyGranted>
                    </div>
            </div>
    </div>

    </body>
</html>
