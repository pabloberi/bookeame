<%@ page import="gestion.General; espacio.TipoEspacio" %>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Lista<span class="fw-300"><i>Direcciones</i></span>
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
                                <th>En Uso</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${ubicacionUserList}" status="i" var="ubicacion" >
                                <tr>
                                    <td>
                                        <g:link controller="ubicacionUser" action="asignarEnUso" id="${ubicacion?.id}">
                                            <button id="botonUsar${ubicacion?.id}" class="btn btn-info btn-xs btn-icon" title="Usar">
                                                <i class="fal fa-check"></i>
                                            </button>
                                        </g:link>
                                        <g:link controller="ubicacionUser" action="eliminarUbicacion" id="${ubicacion?.id}">
                                            <button id="botonEliminar${ubicacion?.id}" class="btn btn-danger btn-xs btn-icon" title="Eliminar">
                                                <i class="fal fa-trash"></i>
                                            </button>
                                        </g:link>
                                    </td>
                                    <td>${ubicacion?.direccion}</td>
                                    <td>${formatBoolean(boolean: ubicacion?.enUso, true: "Habilitado", false: "Deshabilitado")}</td>
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
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
<script type="text/javascript">
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