
<script type="text/javascript" src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

<div id="modalAlarma"  class="modal fade" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Crea tu alarma</h4>
                <button type="button" class="close" data-dismiss="modal">x</button>
            </div>
            <g:form method="POST" controller="alarma" action="save" >
                <div class="modal-body">
                    <div class="form-row">
                        <div class="col-md-12 pr-1">
                            <label class="form-label">Horario</label>
                            <div class="input-group date" >
                                <g:select name="reserva" id="reserva" type="text" class="form-control" required=""
                                          from="${reservas.sort { it?.inicioExacto }}" noSelection="['': '- Selecciona Horario -']" style="width: 100%;" optionKey="id" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
                        <button type="submit" class="btn btn-info btn-sm" title="Crear"
                                onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                            Crear
                        </button>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>
%{--<script>--}%
%{--    $('.select2').select2();--}%
%{--</script>--}%
