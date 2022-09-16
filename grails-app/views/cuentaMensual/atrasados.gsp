<%@ page import="empresa.Empresa" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Cuentas Atrasadas<span class="fw-300"><i>Empresa</i></span>
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
                                <th>Código</th>
                                <th>Empresa</th>
                                <th>Estado</th>
                                <th>Fecha Vencimiento</th>
                                <th>Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${cuentaMensualList}" status="i" var="cuentaMensual">
                                <tr>
                                    <td>${cuentaMensual?.codigo}</td>
                                    <td>${cuentaMensual?.empresa}</td>
                                    <td>${cuentaMensual?.estadoCuentaMensual}</td>
                                    <td><g:formatDate format="dd-MM-yyyy" date="${cuentaMensual?.fechaVencimiento}"/></td>
                                    <td>${cuentaMensual?.total}</td>
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
<asset:javascript src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.js"/>
<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<asset:javascript src="app.bundle.js"/>
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
<script type="text/javascript">
    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right"
    });

    $('.select2').select2();

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
