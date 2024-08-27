


<div id="modalEditPagoReserva"  class="modal fade" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Editar Pago Reserva</h4>
                <button type="button" class="close" data-dismiss="modal">x</button>
            </div>
            <g:form method="POST" controller="reserva" action="ingresarPago" id="${reserva?.id}">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="form-label" for="valorFinal">Ingrese Pago</label>
                        <div class="input-group">
                            <div class="input-group-append">
                                <span class="input-group-text">$</span>
                            </div>
                            <g:field type="number" id="valorFinal" name="valorFinal" class="form-control"
                                     placeholder="Ingrese Pago" value="${registroPagoReserva?.monto ?: reserva?.valor}"/>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="col-md-12 mt-4">
                        <button name="registroPago"
                                id="registroPago" type="submit" class="btn btn-success btn-block btn-md mt-12 mb-2" value="1" >
                                Registrar
                        </button>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>

