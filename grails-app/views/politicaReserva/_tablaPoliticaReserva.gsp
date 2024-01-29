<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Lista <span class="fw-300"><i>Politicas Reserva</i></span>
        </h2>
%{--        <div class="panel-toolbar">--}%
%{--            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>--}%
%{--            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>--}%
%{--            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>--}%
%{--        </div>--}%
    </div>

    <div class="panel-container show">
        <div class="panel-content">
            <div class="d-flex flex-column h-100">
                <div class="h-auto">
                    <table id="tabla-resumen" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                        <thead class="bg-primary-500">
                        <tr>
                            <th class="width-7"></th>
                            <th>Política</th>
                        </tr>
                        </thead>
                        <tbody>
                        <g:each in="${politicaReservaList}" status="i" var="politica">
                            <tr>
                                <td>
                                    <g:link controller="politicaReserva" action="edit" id="${politica?.id}">
                                        <button id="boton${politica?.id}" class="btn btn-info btn-xs btn-icon">
                                            <i class="fal fa-eye"></i>
                                        </button>
                                    </g:link>
                                    <g:link controller="politicaReserva" action="eliminar" id="${politica?.id}">
                                        <button id="boton${politica?.id}" class="btn btn-danger btn-xs btn-icon"
                                                onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                                            <i class="fal fa-trash"></i>
                                        </button>
                                    </g:link>

                                </td>
                                <td>${i + 1} .- ${politica?.descripcion}</td>
                            </tr>
                        </g:each>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

</div>

    <asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
%{--    <asset:javascript src="datagrid/datatables/datatables.export.js"/>--}%

    <script>
        $(document).ready( function () {
            $('#tabla-resumen').dataTable({
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
                // dom: "Bp",
                buttons: ['excel'],
                responsive: true,
                autoFill: {
                    focus: 'hover'
                }
            });
        });
    </script>
