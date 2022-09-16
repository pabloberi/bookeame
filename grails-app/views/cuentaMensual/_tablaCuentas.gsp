
<g:if test="${ cuentaMensualList?.size() > 0 }">
    <div class="tab-pane" id="tab-events" role="tabpanel">
        <div class="d-flex flex-column h-100">
            <div class="h-auto">
                <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                    <thead class="bg-primary-500">
                    <tr>
                        <th>Código</th>
                        <th>Empresa</th>
                        <th>Vencimiento</th>
                        <th>Pagado</th>
                        <th>Fecha Pago</th>
                        <th>Estado</th>
                        <th>Total</th>

                    </tr>
                    </thead>
                    <tbody>
                    <g:each in="${cuentaMensualList}" status="i" var="cuentaMensual">
                        <tr>
                            <td>${cuentaMensual?.codigo}</td>
                            <td>${cuentaMensual?.empresa}</td>

                            <td><g:formatDate format="dd-MM-yyyy" date="${cuentaMensual?.fechaVencimiento}"/></td>
                            <td>${formatBoolean(boolean: cuentaMensual?.pagado, true: "si", false: "no")}</td>
                            <td><g:formatDate format="dd-MM-yyyy" date="${cuentaMensual?.fechaPago}"/></td>
                            <td>${cuentaMensual?.estadoCuentaMensual}</td>
                            <td><g:formatNumber number="${cuentaMensual?.total}"  format="\$ ###,###,###"  /></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
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
</g:if>
<g:else>
    <p>Sin coincidencias.</p>
</g:else>
