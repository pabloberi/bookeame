
<div class="col-xl-12">
    <div id="panel-2" class="panel">
        <div class="panel-hdr">
            <h2>
                Recaudación Por Espacio <span class="fw-300"><i></i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">
%{--                <div class="panel-tag">--}%
%{--                    Sólo se consideran las reservas en las cuales se evaluó al usuario.--}%
%{--                </div>--}%

                <div class="form-group row">
                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                        <label class="form-label" for="desde">Desde</label>
                        <div class="input-group">
                            <g:field type="text" id="desde" name="desde" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                        <label class="form-label" for="hasta">Hasta</label>
                        <div class="input-group">
                            <g:field type="text" id="hasta" name="hasta" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                        <label class="form-label" for="espacio">Espacio</label>
                        <div class="input-group">
                            <g:select id="espacio" name="espacio" class="form-control select2" from="${espacioList}" required="" noSelection="['':'- Seleccione Espacio -']" style="width: 100%;" optionKey="id" />
                        </div>
                    </div>
            </div>
                <div style="float: right; margin-bottom: 2em;">
                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                        <br>
                        <button type="button" class="btn btn-primary" onclick="buscarRecaudacion()">Buscar</button>
                    </div>
                </div>

            <div id="divTablaRecaudacion"></div>

            </div>

        </div>
    </div>
</div>
<script>
    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "top right",
        // endDate: new Date()
    });

    // $('.select2').select2();

    function  buscarRecaudacion() {
        $('#divTablaRecaudacion').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
        var desde = document.getElementById('desde').value;
        var hasta = document.getElementById('hasta').value;
        var espacioId = document.getElementById('espacio').value;

        if( desde && hasta && espacioId) {
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'home', action: 'recaudacionEspacio')}',
                data: {desde: desde, hasta: hasta, espacioId: espacioId},
                success: function (data, textStatus) {
                    $('#divTablaRecaudacion').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $('#divTablaRecaudacion').html('Complete el formulario.');
        }
    }

    function sleep(milisegundos) {
        var comienzo = new Date().getTime();
        while (true) {
            if ((new Date().getTime() - comienzo) > milisegundos)
                break;
        }
    }

</script>
