<g:if test="${reservaList?.size() > 0}">
    <div class="subheader">
        <div class="subheader-block d-lg-flex align-items-center">
            <div class="d-inline-flex flex-column justify-content-center mr-3">
                <span class="fw-500 fs-xs d-block opacity-50">
                    Recaudación
                </span>
                <span class="fw-500 fs-xl d-block color-primary-500">
                    $ ${g.formatNumber(format: "###,##0", number: recaudacion) }
                </span>
            </div>
        </div>
        <div class="subheader-block d-lg-flex align-items-center border-faded border-right-0 border-top-0 border-bottom-0 ml-3 pl-3">
            <div class="d-inline-flex flex-column justify-content-center mr-3">
                <span class="fw-500 fs-xs d-block opacity-50">
                    Reservas
                </span>
                <span class="fw-500 fs-xl d-block color-danger-500">
                    ${reservaList?.size()}
                </span>
            </div>
        </div>
    </div>

%{--    <div class="tab-pane" id="tab-events" role="tabpanel">--}%
        <div class="d-flex flex-column h-100">
            <div class="h-auto">
                <table id="tabla-resumen" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                    <thead class="bg-primary-500">
                    <tr>
                        <th>Fecha Reserva</th>
                        <th>Valor</th>
                        <th>Espacio</th>
                        <th>Estado</th>
                        <th>Tipo Reserva</th>
                        <th>Usuario</th>
                        <th>Email</th>
                        <th>Evaluación</th>
                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${reservaList}" status="i" var="reserva">
                        <tr>
                            <td><g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/> ${reserva?.horaInicio} - ${reserva?.horaTermino}</td>
                            <td><g:formatNumber  class="form-control"  number="${reserva?.valor ?: 0}"  format="\$ ###,###,###"  /></td>
                            <td>${reserva?.espacio}</td>
                            <td>${reserva?.estadoReserva}</td>
                            <td>${reserva?.tipoReserva}</td>
                            <td>${reserva?.usuario?.nombre + " " + reserva?.usuario?.apellidoPaterno}</td>
                            <td>${reserva?.usuario?.email}</td>
                            <td>${reserva?.evaluacion?.evaluacionToUser?.nota}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
%{--    </div>--}%

    <asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
    <asset:javascript src="datagrid/datatables/datatables.export.js"/>

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
</g:if>
<g:else>
    <div>No hay coincidencias</div>
</g:else>
