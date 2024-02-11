<!doctype html>
<html>
<head>
    <title>Reportería</title>
    <meta name="layout" content="dashboard" />
</head>
<body>
    <asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

    <div class="row">
        <div class="col-xl-12">
            <div id="panel-1" class="panel">
                <div class="panel-hdr bg-primary-700 bg-success-gradient">
                    <h2>
                        Gráfico Ingresos<span class="fw-300"><i></i></span>
                    </h2>
                </div>
                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="form-group row">
                            <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                <label class="form-label" for="espacio">Espacio</label>
                                <div class="input-group">
                                    <g:select id="espacio" name="espacio" class="form-control select2" from="${espacioList}" required="" noSelection="['':'- Seleccione Espacio -']" style="width: 100%;" optionKey="id" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                <label class="form-label" for="periodo">Periodo</label>
                                <div class="input-group">
                                    <g:select id="periodo" name="periodo" class="form-control select2" from="${periodoList}" required="" noSelection="['':'- Seleccione Periodo -']" style="width: 100%;" optionKey="id" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-4 col-lg-4 pr-1 mt-1">
                                <label class="form-label"></label>
                                <div class="input-group">
                                    <button type="button" class="btn btn-primary" onclick="buscarRecaudacion()">Buscar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-container show" id="grafico">
                    <g:render template="ingresoMensual"/>
                </div>

            </div>
        </div>
    </div>

<!-- TODO: FILTRAR POR TIPO PLAN -->
    <div class="row">
        <div class="col-xl-12">
            <div id="panel-2" class="panel" >
                <div class="panel-hdr bg-primary-700 bg-success-gradient">
                    <h2>
                        Gráfico Comparación Año Anterior<span class="fw-300"><i></i></span>
                    </h2>
                </div>

                <div class="panel-container show">
                    <div class="panel-content">
                        <div class="form-group row">
                            <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                <label class="form-label" for="espacio-comp">Espacio</label>
                                <div class="input-group">
                                    <g:select id="espacio-comp" name="espacio-comp" class="form-control select2" from="${espacioList}" required="" noSelection="['':'- Seleccione Espacio -']" style="width: 100%;" optionKey="id" />
                                </div>
                            </div>
                            <div class="col-sm-12 col-md-4 col-lg-4 pr-1 mt-1">
                                <label class="form-label"></label>
                                <div class="input-group">
                                    <button type="button" class="btn btn-primary" onclick="buscarComparacion()">Buscar</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel-container show" id="comparacionAnioAnterior">
                    <g:render template="comparacionAnioAnterior"/>
                </div>
            </div>
        </div>
    </div>

    <asset:javascript src="/formplugins/select2/select2.bundle.js"/>

    <script type="text/javascript">
        $('.datepicker').datepicker({
            todayHighlight: true,
            language: 'esp',
            orientation: "bottom right",
            // endDate: new Date()
        });
        $(window).on('load',function() {
            $('.loader').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>')
            // $(".loader").fadeOut("slow");
        });

        $('.select2').select2();

        function buscarRecaudacion() {
            $('#grafico').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Esto puede tardar unos segundos</center>')
            var espacioId = $('#espacio').val();
            var periodoId = $('#periodo').val();
                $.ajax({
                    type: 'POST',
                    url: '${g.createLink(controller: 'reporteria', action: 'graficoIngresos')}',
                    data: { espacioId: espacioId,  periodoId: periodoId },
                    success: function (data, textStatus) {
                        $('#grafico').html(data);
                        // sleep(1000);
                    }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                    }
                });
        }

        function sleep(milisegundos) {
            var comienzo = new Date().getTime();
            while (true) {
                if ((new Date().getTime() - comienzo) > milisegundos)
                    break;
            }
        }

    </script>
</body>
</html>
