
    <div class="col-xl-6 col-md-12">
        <div id="panel-2" class="panel">
            <div class="panel-hdr">
                <h2>
                    Top <span class="fw-300"><i>Usuarios</i></span>
                </h2>
                <div class="panel-toolbar">
                    <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                    <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
                </div>
            </div>
            <div class="panel-container show">
                <div class="panel-content">
                    <div class="panel-tag">
                       Sólo se consideran las reservas en las cuales se evaluó al usuario.
                    </div>

                    <div class="tab-pane" id="tab-events" role="tabpanel">
                        <div class="d-flex flex-column h-100">
                            <div class="h-auto">
                                <table id="dt-basic-example" class="tabla table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                                    <thead class="bg-primary-500">
                                    <tr>
                                        <th>Usuario</th>
                                        <th>Reservas</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <g:each in="${topUser}" status="i" var="user" >
                                        <tr>
                                            <td>${user?.key}</td>
                                            <td>${user?.value.size()}</td>
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
    </div>

    <div class="col-xl-6 col-md-12">
        <div id="panel-3" class="panel">
            <div class="panel-hdr">
                <h2>
                    Top <span class="fw-300"><i>Espacios</i></span>
                </h2>
                <div class="panel-toolbar">
                    <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                    <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                    <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
                </div>
            </div>
            <div class="panel-container show">
                <div class="panel-content">
                    <div class="panel-tag">
                        Sólo se consideran las reservas en las cuales se evaluó al usuario.
                    </div>
                    <div class="tab-pane"  role="tabpanel">
                        <div class="d-flex flex-column h-100">
                            <div class="h-auto">
                                <table id="dt-basic-example2" class="tabla table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                                    <thead class="bg-primary-500">
                                    <tr>
                                        <th>Espacio</th>
                                        <th>Reservas</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <g:each in="${topSpace}" status="i" var="espacio" >
                                        <tr>

                                            <td>${espacio?.key}</td>
                                            <td>${espacio?.value.size()}</td>
                                            %{--                                        <td>${formatBoolean(boolean: espacio?.enabled, true: "Habilitado", false: "Deshabilitado")}</td>--}%
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
    </div>


<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
<script type="text/javascript">
    $(document).ready( function () {
        $('.tabla').dataTable({
            "order": [[ 1, "desc" ]],
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