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
            <div class="tab-pane" id="tab-events" role="tabpanel">
                <div class="d-flex flex-column h-100">
                    <div class="h-auto">
                        %{--<table class="table table-sm m-0" id="simpledatatables">--}%
                        <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">

                            <thead class="bg-primary-500">
                            <tr>
                                <th>Acción</th>
                                <th>Nombre</th>
                                <th>Email</th>
                                <th>Rut</th>
                                <th>Celular</th>
                                <th>Fecha Nacimiento</th>
                                <th>Enabled</th>
                                <th>Expired</th>
                                <th>Locked</th>
                                <th>Password Expired</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${userList}" status="i" var="user" >
                                <tr>
                                    <td>
                                        <g:link controller="user" action="bannearUsuario" id="${user?.id}">
                                            <button id="boton${user?.id}" class="btn btn-danger btn-xs btn-icon"  title="Bannear">
                                                <i class="fal fa-ban"></i>
                                            </button>
                                        </g:link>
                                        <g:link controller="user" action="desbannearUsuario" id="${user?.id}">
                                            <button id="boton${user?.id}" class="btn btn-info btn-xs btn-icon" title="Desbannear">
                                                <i class="fal fa-check"></i>
                                            </button>
                                        </g:link>
                                    </td>
                                    <td>${user?.nombre} ${user?.apellidoPaterno}</td>
                                    <td>${user?.email}</td>
                                    <td>${user?.rut}-${user?.dv}</td>
                                    <td>${user?.celular}</td>
                                    <td><g:formatDate format="dd-MM-yyyy" date="${user?.fechaNac}"/></td>
                                    <td>${formatBoolean(boolean: user?.enabled, true: "si", false: "no")}</td>
                                    <td>${formatBoolean(boolean: user?.accountExpired, true: "si", false: "no")}</td>
                                    <td>${formatBoolean(boolean: user?.accountLocked, true: "si", false: "no")}</td>
                                    <td>${formatBoolean(boolean: user?.passwordExpired, true: "si", false: "no")}</td>

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
