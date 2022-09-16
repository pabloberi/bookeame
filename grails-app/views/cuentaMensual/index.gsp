<%@ page import="empresa.Empresa" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

<div id="panel-6" class="panel">
    <div class="panel-hdr bg-primary-700 bg-success-gradient">
        <h2>
            Filtro de Búsqueda <span class="fw-300"></span>
        </h2>
    </div>
    <div class="panel-container show">
        <div class="panel-content">
            <hr><legend>General</legend><hr>
            <g:form method="POST" controller="home" action="dashboard">
                <div class="row">
                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                        <label class="form-label" for="fechaVencimiento">Fecha de vencimiento</label>
                        <div class="input-group">
                            <g:field type="text" id="fechaVencimiento" name="fechaVencimiento" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required=""  />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>

                    <div style="float:right; margin-bottom: 1em; margin-top: 2em;">
                        <button class="btn btn-info" type="button" onclick="busquedaGeneral();">Buscar</button>
                        <a class="btn btn-light" href="${createLink(controller: 'home', action: 'dashboard')}">Limpiar</a>
                    </div>
                </div>
            </g:form>

            <hr><legend>Por Empresa</legend><hr>
            <g:form method="POST" controller="home" action="dashboard">
                <div class="row">
                    <div class="col-sm-12 col-md-6 col-lg-4 pr-1">
                        <label class="form-label" for="desde">Desde</label>
                        <div class="input-group">
                            <g:field type="text" id="desde" name="desde" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required=""  />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-lg-4 pr-1">
                        <label class="form-label" for="hasta">Hasta</label>
                        <div class="input-group">
                            <g:field type="text" id="hasta" name="hasta" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required=""  />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-lg-4 pr-1">
                        <label class="form-label" for="empresa">Empresa</label>
                        <div class="input-group">
                            <g:select required="" type="text" from="${Empresa.list()}" id="empresa" name="empresa" class="form-control select2" style="width: 100%;" optionKey="id" noSelection="['':'- Seleccione Empresa -']" />
                        </div>
                    </div>
                </div>

                <div style="float:right; margin-bottom: 1em; margin-top: 1em;">
                    <button class="btn btn-info" type="button" onclick="busquedaPorEmpresa();">Buscar</button>
                    <a class="btn btn-light" href="${createLink(controller: 'home', action: 'dashboard')}">Limpiar</a>
                </div>
            </g:form>

        </div>
    </div>
</div>

<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Estado de Cuentas <span class="fw-300"><i>Empresa</i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content">

            <div id="tablaCuentas"></div>

        </div>
    </div>
</div

<asset:javascript src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.js"/>
<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<asset:javascript src="app.bundle.js"/>
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
<script type="text/javascript">
    function busquedaGeneral(){
        $('#tablaCuentas').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
        var fechaVencimiento = document.getElementById('fechaVencimiento').value;

        if( fechaVencimiento ) {
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'cuentaMensual', action: 'busquedaGeneralCuentas')}',
                data: { fechaVencimiento: fechaVencimiento },
                success: function (data, textStatus) {
                    $('#tablaCuentas').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $('#tablaCuentas').html('Complete el formulario.');
        }

    }

    function busquedaPorEmpresa(){
        $('#tablaCuentas').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
        var desde = document.getElementById('desde').value;
        var hasta = document.getElementById('hasta').value;
        var empresaId =  document.getElementById('empresa').value;

        if( desde && hasta ) {
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'cuentaMensual', action: 'busquedaCuentaEmpresa')}',
                data: { desde: desde, hasta: hasta, empresaId: empresaId },
                success: function (data, textStatus) {
                    $('#tablaCuentas').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $('#tablaCuentas').html('Complete el formulario.');
        }

    }

    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right"
    });

    $('.select2').select2();

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
