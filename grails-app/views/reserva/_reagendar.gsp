<%@ page import="configuracionEmpresa.ConfiguracionEmpresa" %>

<div id="modalReagendar"  class="modal fade" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Reagendar Reserva</h4>
                <button type="button" class="close" data-dismiss="modal">x</button>
            </div>
        <g:form method="POST" controller="reserva" action="reagendarReserva" id="${reserva?.id}" >
            <div class="modal-body">
                <div class="form-row">
                    <div class="col-md-12 pr-1">
                        <label class="form-label" for="fechaReagendar">Seleccione Fecha</label>
                        <div class="input-group">
                            <g:field type="text" id="fechaReagendar" name="fechaReagendar" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" onchange="obtenerHorasDisponibles(this.value);" />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-12 pr-1" style="margin-top: 1em;">
                        <label class="form-label">Seleccione Horario</label>
                        <div id="comboHoras"></div>
                    </div>


                </div>
            </div>
            <div class="modal-footer">
                <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
                    <button type="submit" class="btn btn-info btn-sm" title="Guardar"
                            onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                        Reagendar
                    </button>
                </div>
            </div>
        </g:form>
        </div>
    </div>
</div>
<script>
    var diasAdicionales = ${ configuracion?.diasAMostrar ?: 7 };
    var fechaHoy = new Date();
    var fechaMañana = new Date(fechaHoy.setDate(fechaHoy.getDate() + 1));
    var fechaFuturo = new Date( fechaHoy.setDate(fechaHoy.getDate() + (diasAdicionales - 1 )));

    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right",
        startDate: fechaMañana,
        endDate: fechaFuturo
    });

    function obtenerHorasDisponibles(valor) {
        $.ajax({
            type: 'POST',
            url: '${g.createLink(controller: 'reserva', action: 'getHorariosDisponibles')}',
            data: { fecha: valor, reserva: ${reserva?.id} },
            success: function (data, textStatus) {
                $('#comboHoras').html(data);
            }, error: function (XMLHttpRequest, textStatus, errorThrown) {
            }
        });
    }
</script>
