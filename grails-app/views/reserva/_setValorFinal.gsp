        <div class="modal fade" id="modalValorFinal${reserva?.id}" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Definir Valor Final</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true"><i class="fal fa-times"></i></span>
                        </button>
                    </div>
                    <g:form method="POST" controller="reserva" action="setValorFinal" id="${reserva?.id}">
                        <div class="modal-body">
                            <div class="panel-container show">
                                <div class="panel-content">
                                    <div class="panel-tag">
                                        ESTA INFORMACIÓN SE PUEDE GUARDAR UNA SOLA VEZ POR RESERVA
                                    </div>
                                    <h6>Define el precio final de la reserva del usuario ${reserva?.usuario} el día <g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/> </h6>
                                    <div class="frame-wrap">
                                        <div class="form-group row">
                                            <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                                <label class="col-xl-12 form-label" for="valorFinal">Valor Final</label>
                                                <g:field required="" type="number" min="0" id="valorFinal" name="valorFinal" class="form-control" placeholder="Ingrese Valor Final" value="${reserva?.valor}" onkeyup="this.value=Numeros(this.value)"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="submit" type="button" class="btn btn-primary" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Guardar</button>
                        </div>
                    </g:form>

                </div>
            </div>
        </div>
        <script>
            function Numeros(string){//Solo numeros
                var out = '';
                var filtro = '1234567890';//Caracteres validos

                for (var i=0; i<string.length; i++)
                    if (filtro.indexOf(string.charAt(i)) != -1)
                        out += string.charAt(i);
                return out;
            }
        </script>



