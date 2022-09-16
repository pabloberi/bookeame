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
                        Declaración Devolución Dinero <span class="fw-300"></span>
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
                                Antes de eliminar una reserva PREPAGO debe realizar el reembolso del dinero al cliente a través de <a href="https://www.flow.cl/app/web/reembolsos.php"><u>FLOW</u></a>
                            </div>

                            <table class="table">
                                <tbody>
                                    <tr class="prop">
                                        <td valign="top" class="bg-success-500 name">Datos Reserva</td>
                                        <td valign="top" class="bg-success-500 name"></td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="espacio.tiempo.label" default="Codigo" /></td>
                                        <td id="codigo" valign="top" class="value">${reserva?.codigo}</td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Fecha Reserva" /></td>
                                        <td id="horaInicio" valign="top" class="value"><g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}" /> ${reserva?.horaInicio} - ${reserva?.horaTermino}</td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Cliente" /></td>
                                        <td id="horaTermino" valign="top" class="value">${reserva?.usuario?.nombre + " " + reserva?.usuario?.apellidoPaterno}</td>
                                    </tr>
                                    <tr class="prop">
                                        <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Espacio" /></td>
                                        <td id="espacio" valign="top" class="value">${reserva?.espacio}</td>
                                    </tr>

                                </tbody>
                            </table>
                            <hr>
                            <g:form controller="reserva" action="eliminarReservaPrepago" id="${reserva?.id}">
                                <div class="form-group">
                                    <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                        <label class="col-xl-12 form-label" for="numeroReembolso">Número Reembolso</label>
                                        <g:field type="text" id="numeroReembolso" name="numeroReembolso" class="form-control" placeholder="Ingrese Número de Reembolso" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                        <label class="col-xl-12 form-label" for="numeroOrden">Número de Orden</label>
                                        <g:field type="text" id="numeroOrden" name="numeroOrden" class="form-control" placeholder="Ingrese Número de Orden" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">

                                    <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                        <label class="col-xl-12 form-label" for="monto">Monto Reembolso</label>
                                        <g:field type="text" id="monto" name="monto" class="form-control" placeholder="Ingrese Monto" required=""/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="custom-control custom-switch">
                                        <input type="checkbox" class="custom-control-input" name="acepta" id="acepta" required="">
                                        <label class="custom-control-label" for="acepta">Declaro que la información proporcionada es correcta.</label>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6 ml-auto text-right" style="margin-bottom: 1em">
                                        <button type="submit" class="delete btn btn-block btn-danger btn-lg mt-3" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Eliminar Reserva</button>
                                    </div>
                                </div>
                            </g:form>
                        </div>
                    </div>
            </div>
    </div>

    </body>
</html>
