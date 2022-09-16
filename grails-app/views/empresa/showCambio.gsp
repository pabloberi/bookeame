<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
%{--    <g:render template="/layouts/botonera" params="[controlador: 'Espacio', metodo: 'Lista']" />--}%
<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Lista <span class="fw-300"><i>Usuarios</i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content">
            <div class="d-flex flex-column h-100">
                <div class="h-auto">
                    %{--<table class="table table-sm m-0" id="simpledatatables">--}%
                    <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">

                        <thead class="bg-primary-500">
                        <tr>
                            <th>Atributo</th>
                            <th>Actual</th>
                            <th>Cambio</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Giro</td>
                                <td>${empresa?.giro}</td>
                                <td>${cambioDatos?.giro}</td>
                            </tr>
                            <tr>
                                <td>Razón Social</td>
                                <td>${empresa?.razonSocial}</td>
                                <td>${cambioDatos?.razonSocial}</td>
                            </tr>
                            <tr>
                                <td>RUT</td>
                                <td>${empresa?.rut}-${empresa?.dv}</td>
                                <td>${cambioDatos?.rut}-${cambioDatos?.dv}</td>
                            </tr>
                            <tr>
                                <td>Dirección</td>
                                <td>${empresa?.direccion}</td>
                                <td>${cambioDatos?.direccion}</td>
                            </tr>
                            <tr>
                                <td>Nombre Representante</td>
                                <td>${empresa?.usuario?.nombre} ${empresa?.usuario?.apellidoPaterno} ${empresa?.usuario?.apellidoMaterno}</td>
                                <td>${cambioDatos?.nombre} ${cambioDatos?.apellidoPaterno} ${cambioDatos?.apellidoMaterno}</td>
                            </tr>
                            <tr>
                                <td>Celular</td>
                                <td>${empresa?.usuario?.celular}</td>
                                <td>${cambioDatos?.celular}</td>
                            </tr>
                            <tr>
                                <td>Fecha Nacimiento</td>
                                <td><g:formatDate format="dd-MM-yyyy" date="${empresa?.usuario?.fechaNac}"/></td>
                                <td><g:formatDate format="dd-MM-yyyy" date="${cambioDatos?.fechaNac}"/></td>
                            </tr>
                            <tr>
                                <td>RUT</td>
                                <td>${empresa?.usuario?.rutRepresentante}-${empresa?.usuario?.dvRepresentante}</td>
                                <td>${cambioDatos?.rutUser}-${cambioDatos?.dvUser}</td>
                            </tr>

                        </tbody>
                    </table>
                </div>
            </div>

            <div>
                <g:link controller="empresa" action="aprobarCambioDatos" id="${cambioDatos?.id}">
                    <button id="boton${empresa?.id}" class="btn btn-success btn-md btn-icon">
                        <i class="fal fa-check"></i>
                    </button>
                </g:link>
                <g:link controller="empresa" action="rachazarCambioDatos" id="${cambioDatos?.id}">
                    <button id="boton${empresa?.id}" class="btn btn-danger btn-md btn-icon">
                        <i class="fal fa-trash"></i>
                    </button>
                </g:link>
            </div>

        </div>
    </div>
</div>
%{--<asset:javascript src="vendors.bundle.js"/>--}%
%{--<asset:javascript src="app.bundle.js"/>--}%
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
