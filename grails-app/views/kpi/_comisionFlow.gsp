<div class="col-xl-12">
    <div id="panel-2" class="panel">
        <div class="panel-hdr">
            <h2>
                Recaudación Prepago <span class="fw-300"><i></i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">

                <div class="form-group row">
                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                        <label class="form-label" for="desde">Desde</label>
                        <div class="input-group">
                            <g:field type="text" id="desdeFlow" name="desde" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
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
                            <g:field type="text" id="hastaFlow" name="hasta" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>


                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                        <br>
                        <button type="button" class="btn btn-primary" onclick="buscarReservaPrepago()">Buscar</button>
                    </div>
            </div>

            <div id="divTablaComision"></div>

            </div>

        </div>
    </div>
</div>
<script>
    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "top right",
        // endDate:  new Date()
    });

    function  buscarReservaPrepago() {
        $('#divTablaComision').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
        var desde = document.getElementById('desdeFlow').value;
        var hasta = document.getElementById('hastaFlow').value;

        if( desde && hasta ) {
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'home', action: 'comisionFlow')}',
                data: {desde: desde, hasta: hasta},
                success: function (data, textStatus) {
                    $('#divTablaComision').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $('#divTablaComision').html('Ingrese un período de tiempo.');
        }
    }

</script>