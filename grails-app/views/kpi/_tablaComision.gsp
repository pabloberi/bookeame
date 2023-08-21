<g:if test="${reservaList.size() > 0}">
<div class="subheader">
    <div class="subheader-block d-lg-flex align-items-center">
        <div class="d-inline-flex flex-column justify-content-center mr-3">
            <span class="fw-500 fs-xs d-block opacity-50">
                Recaudación neta
            </span>
            <span class="fw-500 fs-xl d-block color-primary-500">
                $ ${g.formatNumber(format: "###,##0",
                        number: recaudacionNeta) }
            </span>
        </div>
    </div>
    <div class="subheader-block d-lg-flex align-items-center border-faded border-right-0 border-top-0 border-bottom-0 ml-3 pl-3">
        <div class="d-inline-flex flex-column justify-content-center mr-3">
            <span class="fw-500 fs-xs d-block opacity-50">
                Recaudación comisión
            </span>
            <span class="fw-500 fs-xl d-block color-danger-500">
                $ ${g.formatNumber(format: "###,##0", number: recaudacionComision ) }
            </span>
        </div>
    </div>
</div>

<div class="tab-pane" id="tab-events" role="tabpanel">
    <div class="d-flex flex-column h-100">
        <div class="h-auto">
            <table id="tablaComision" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                <thead class="bg-primary-500">
                <tr>
                    <th>Fecha Reserva</th>
                    <th>Monto Reserva</th>
                    <th>Comisión</th>
                    <th>Cobro Total</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${reservaList}" status="i" var="reserva" >
                    <tr>
                        <td><g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/></td>
                        <td>$ ${g.formatNumber(format: "###,##0", number: reserva?.valor - reserva?.valorComisionFlow)}</td>
                        <td>$ ${g.formatNumber(format: "###,##0", number: reserva?.valorComisionFlow)}</td>
                        <td>$ ${g.formatNumber(format: "###,##0", number: reserva?.valor)}</td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    $(document).ready( function () {
        $('#tablaComision').dataTable({
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
</g:if>
<g:else>
    <div>No hay coincidencias</div>
</g:else>
