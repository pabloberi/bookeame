<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>

    <div id="panel-7" class="panel">
        <div class="panel-hdr">
            <h2>
                Lista<span class="fw-300"><i>Solicitud de Reservas</i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">

                <div class="tab-pane" id="tab-events" role="tabpanel">
                    <div class="d-flex flex-column h-100">
                        <div class="h-auto">
                            <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                                <thead class="bg-primary-500">
                                <tr>
                                    <th>Acción</th>
                                    <th>Fecha Reserva</th>
                                    %{--<th>Valor</th>--}%
                                    <th>Espacio</th>
                                    <th>Estado</th>
                                    <th>Tipo Reserva</th>
                                    <th>Usuario</th>
                                    <th>Indice Confianza</th>
                                    <th>Valor</th>

                                </tr>
                                </thead>
                                <tbody>
                                <g:each in="${solicitudList}" status="i" var="reserva">
                                    <tr>
                                        <td>
%{--                                            <a href="${createLink(controller: 'reserva', action: 'aprobarSolicitud', id: reserva?.id)}" class="btn btn-info btn-xs btn-icon" title="Aprobar">--}%
%{--                                                <i class="fal fa-check"></i>--}%
%{--                                            </a>--}%
%{--                                            <a href="${createLink(controller: 'reserva', action: 'cancelarSolicitud', id: reserva?.id)}" class="btn btn-danger btn-xs btn-icon" title="Rechazar" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">--}%
%{--                                                <i class="fal fa-times"></i>--}%
%{--                                            </a>--}%
                                            <a href="${createLink(controller: 'reserva', action: 'show', id: reserva?.id)}" class="btn btn-primary btn-xs btn-icon" title="Ficha">
                                                <i class="fal fa-eye"></i>
                                            </a>
                                        </td>
                                        <td><g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/> ${reserva?.horaInicio} - ${reserva.horaTermino}</td>
                                        %{--<td>${reserva?.valor}</td>--}%
                                        <td>${reserva?.espacio}</td>
                                        <td>${reserva?.estadoReserva}</td>
                                        <td>${reserva?.tipoReserva}</td>
                                        <td>${reserva?.usuario} </td>
                                        <td>${reserva?.usuario?.indiceConfianza} de 5</td>
                                        <td>$ ${reserva?.valor} .-</td>

                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    %{--<asset:javascript src="vendors.bundle.js"/>--}%
%{--    <asset:javascript src="app.bundle.js"/>--}%
    <asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
    <script type="text/javascript">
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
        $(document).ready( function () {
            $('#dt-basic-example').dataTable({
                language: {
                    "sProcessing":     "Procesando...",
                    "sLengthMenu":     "Mostrar _MENU_ registros",
                    "sZeroRecords":    "No se encontraron resultados",
                    "sEmptyTable":     "Ningún dato disponible en esta tabla =(",
                    "sInfo":           "Mostrando del _START_ al _END_ de _TOTAL_ registros",
                    "sInfoEmpty":      "Sin Registros",
                    "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
                    "sInfoPostFix":    "",
                    // "sSearch":         "Buscar:",
                    "sUrl":            "",
                    "sInfoThousands":  ",",
                    "sLoadingRecords": "Cargando...",
                    "oPaginate": {
                        "sFirst":    "Primero",
                        "sLast":     "Último",
                        "sNext":     "Siguiente",
                        "sPrevious": "Anterior"
                    },
                    "oAria": {
                        "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                        "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                    },
                    "buttons": {
                        "copy": "Copiar",
                        "colvis": "Visibilidad"
                    }
                },
                responsive: true,
                autoFill: {
                    focus: 'hover'
                }
            });
        });

    </script>
    </body>
</html>
