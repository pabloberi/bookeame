<asset:stylesheet src="vendors.bundle.css"/>

<div class="panel-container show">
    <div class="panel-content">

        <div class="tab-pane" id="tab-events" role="tabpanel">
            <div class="d-flex flex-column h-100">
                <div class="h-auto">
                    <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                        <thead class="bg-primary-500">
                            <tr>
                                <th>Acción</th>
                                <th>Nombre</th>
                                <th>Rut</th>
                                <th>Usuario</th>
                                <th>Celular</th>
                                <th>Indice Confianza</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${userList}" status="i" var="user">
                                <tr>
                                        <td><a onclick="seleccionUser(${user?.id})"><u>Seleccionar</u></a></td>
                                        <td>${user?.nombre} ${user?.apellidoPaterno}</td>
                                        <td>${user?.rut}-${user?.dv}</td>
                                        <td>${user?.username}</td>
                                        <td>${user?.celular}</td>
                                        <td>${user?.indiceConfianza} de 5 <i class="fal fa-star"></i></td>
                                </tr>
                            </g:each>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
    <asset:javascript src="vendors.bundle.js"/>

    <asset:javascript src="app.bundle.js"/>
    <asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
    <script type="text/javascript">
        function seleccionUser(userId){
            $('#correo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>')
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'user', action: 'seleccionUser')}',
                data: {
                    userId: userId,
                    moduloId: ${moduloId},
                    fechaReserva: "${fechaReserva}"
                },
                success: function (data, textStatus) {
                    $('#correo').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }

        function sleep(milisegundos) {
            var comienzo = new Date().getTime();
            while (true) {
                if ((new Date().getTime() - comienzo) > milisegundos)
                    break;
            }
        }

        $(document).ready( function () {
            $('#dt-basic-example').dataTable({
                "searching": false,
                "bLengthChange" : false,
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


