

<div id="modalPoliticas"  class="modal fade" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Políticas de Reserva</h4>
                <button type="button" class="close" data-dismiss="modal">x</button>
            </div>
                <div class="modal-body">
                    <div class="d-flex flex-column h-100">
                        <div class="h-auto">
                            <table id="tabla-resumen" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                                <thead class="bg-primary-500">
                                <tr>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <g:each in="${politicaReservaList}" status="i" var="politica">
                                    <tr>
                                        <td>${i + 1} .- ${politica?.descripcion}</td>
                                    </tr>
                                </g:each>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
                        <button type="button" class="btn btn-info btn-sm" title="Entendido" data-dismiss="modal">
                            Entendido
                        </button>
                    </div>
                </div>
        </div>
    </div>
</div>

