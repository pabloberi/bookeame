<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Reserva')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
%{--    <g:render template="/layouts/botonera" params="[controlador: 'Reserva', metodo:'Vigentes' ]" />--}%
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Crear Reservas periodicas<span class="fw-300"><i></i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content">
            <div class="panel-tag">
                Puedes crear reservas masivas para un usuario específico
            </div>
            <g:form method="POST" controller="reservaPeriodica" action="crearPlanificada"  >
                <div class="form-group row">
                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label">Buscar Usuario</label>
                        <div class="input-group date" >
                            <g:field name="buscador" id="buscador" type="text" class="form-control" onkeydown="buscarClientePlanificada(this.value);" placeholder="Ingrese correo del usuario" />
                            <div class="input-group-append">
                                <span class="input-group-text"><i class="fal fa-search"></i></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label">Usuario</label>
                        <div class="input-group date" >
                            <div id="campoUser" style="width: 80%">
                                <g:select name="usuario" id="usuario" type="text" class="form-control select2" required="" from="" noSelection="['': '- Sin Coincidencias -']" style="width: 100%;"  />
                            </div>
                            <div class="input-group-append" id="cargador">
                                <span class="input-group-text"><i class="fal fa-user"></i></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label">Espacio</label>
                        <div class="input-group date" >
                            <g:select name="espacio" id="espacio" type="text" class="form-control select2" required="" from="${espacioList}" noSelection="['': '- Selecciona Espacio -']" style="width: 100%;" optionKey="id" />
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label">Valor Por Reserva</label>
                        <div class="input-group" >
                            <g:field name="valorPorReserva" id="valorPorReserva" type="number" class="form-control" required="" placeholder="Ingrese Valor Por Reserva" />
                            <div class="input-group-append">
                                <span class="input-group-text"><i class="fal fa-dollar-sign"></i></span>
                            </div>
                        </div>
                    </div>


                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label" for="fechaInicio">Fecha de Inicio</label>
                        <div class="input-group">
                            <g:field type="text" id="fechaInicio" name="fechaInicio" data-date-format="dd-mm-yyyy" class="form-control datepicker-1" readonly="" placeholder="dd-mm-aaaa" required="" />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>


                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label" for="fechaTermino">Fecha de Término</label>
                        <div class="input-group">
                            <g:field type="text" id="fechaTermino" name="fechaTermino" data-date-format="dd-mm-yyyy" class="form-control datepicker-2" readonly="" placeholder="dd-mm-aaaa" required="" />
                            <div class="input-group-append">
                                <span class="input-group-text fs-xl">
                                    <i class="fal fa-calendar-check"></i>
                                </span>
                            </div>
                        </div>
                    </div>


                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label">Hora Inicio</label>
                        <div class="input-group date" >
                            <select id="horaInicio" name="horaInicio" class="form-control" required="" >
                                <% for (int i = 0; i < 24 ; i++) {%>
                                <g:if test="${i < 10 }">
                                    <option value="0${i}">0${i}</option>
                                </g:if>
                                <g:else>
                                    <option value="${i}">${i}</option>
                                </g:else>
                                <%}%>
                            </select>
                            <div class="input-group-append">
                                <span class="input-group-text">:</span>
                            </div>
                            <select id="minInicio" name="minInicio" class="form-control" required="" >
                                <% for (int i = 0; i < 60 ; i++) {%>
                                <g:if test="${i < 10 }">
                                    <option value="0${i}">0${i}</option>
                                </g:if>
                                <g:else>
                                    <option value="${i}">${i}</option>
                                </g:else>
                                <%}%>
                            </select>
                            <div class="input-group-append">
                                <span class="input-group-text"><i class="fal fa-clock"></i></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-6 col-lg-6 col-xl-6">
                        <label class="form-label">Hora Término</label>
                        <div class="input-group date" >
                            <select id="horaTermino" name="horaTermino" class="form-control" >
                                <% for (int i = 0; i < 24 ; i++) {%>
                                <g:if test="${i < 10 }">
                                    <option value="0${i}">0${i}</option>
                                </g:if>
                                <g:else>
                                    <option value="${i}">${i}</option>
                                </g:else>
                                <%}%>
                            </select>
                            <div class="input-group-append">
                                <span class="input-group-text">:</span>
                            </div>
                            <select id="minTermino" name="minTermino" class="form-control"  >
                                <% for (int i = 0; i < 60 ; i++) {%>
                                <g:if test="${i < 10 }">
                                    <option value="0${i}">0${i}</option>
                                </g:if>
                                <g:else>
                                    <option value="${i}">${i}</option>
                                </g:else>
                                <%}%>
                            </select>
                            <div class="input-group-append">
                                <span class="input-group-text"><i class="fal fa-clock"></i></span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-8 col-xl-8">
                        <label class="form-label" >Días Habilitados</label>

                        <div class="frame-wrap">

                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="lunes" id="lunes" <%if(reservaPlanificada?.dias?.lunes) {%>checked=""<%}%> >
                                <label class="custom-control-label" for="lunes">L</label>
                            </div>
                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="martes" id="martes" <%if(reservaPlanificada?.dias?.martes) {%>checked=""<%}%> >
                                <label class="custom-control-label" for="martes">M</label>
                            </div>
                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles" <%if(reservaPlanificada?.dias?.miercoles) {%>checked=""<%}%> >
                                <label class="custom-control-label" for="miercoles">M</label>
                            </div>
                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="jueves" id="jueves" <%if(reservaPlanificada?.dias?.jueves) {%>checked=""<%}%> >
                                <label class="custom-control-label" for="jueves">J</label>
                            </div>
                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="viernes" id="viernes" <%if(reservaPlanificada?.dias?.viernes) {%>checked=""<%}%>>
                                <label class="custom-control-label" for="viernes">V</label>
                            </div>
                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="sabado" id="sabado" <%if(reservaPlanificada?.dias?.sabado) {%>checked=""<%}%> >
                                <label class="custom-control-label" for="sabado">S</label>
                            </div>
                            <div class="custom-control custom-checkbox custom-control-inline">
                                <input type="checkbox" class="custom-control-input" name="domingo" id="domingo" <%if(reservaPlanificada?.dias?.domingo) {%>checked=""<%}%> >
                                <label class="custom-control-label" for="domingo">D</label>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
                    <button href="#" type="submit" class="btn btn-info btn-sm" title="Guardar">Crear Reservas</button>
                </div>
            </g:form>
        </div>
    </div>
</div>

<div id="panel-8" class="panel">
    <div class="panel-hdr">
        <h2>
            Lista Reservas periodicas<span class="fw-300"><i></i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content">

            <div class="tab-pane" id="tab-events" role="tabpanel">
                <div class="d-flex flex-column h-100">
                    <div class="h-auto">
                        <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                            <thead class="bg-primary-500">
                                <tr>
                                    <th>Acción</th>
                                    <th>Vigencia</th>
                                    <th>Usuario</th>
                                    <th>Hora Inicio</th>
                                    <th>Hora Término</th>
                                    <th>Días</th>
                                </tr>
                            </thead>
                            <tbody>
                            <g:each in="${ reservaPlanificadaList }" status="i" var="reservaPlanificada">
                                <tr>
                                    <td>
                                        <g:link controller="reserva" action="eliminarReservaPlanificada" id="${reservaPlanificada?.id}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                                            <button id="boton${reservaPlanificada?.id}" class="btn btn-danger btn-xs btn-icon" title="eliminar"><i class="fal fa-trash"></i></button>
                                        </g:link>
                                        <button id="boton${reservaPlanificada?.id}" class="btn btn-info btn-xs btn-icon" title="ver"><i class="fal fa-eye"></i></button>

                                    </td>
                                    <td><g:formatDate format="dd-MM-yyyy" date="${reservaPlanificada?.fechaTermino}"/></td>
                                    <td>${reservaPlanificada?.usuario}</td>
                                    <td>${reservaPlanificada?.horaInicio}</td>
                                    <td>${reservaPlanificada?.horaTermino}</td>
                                    <td>
                                        <div class="custom-control-inline pequena hidden-lg-up hidden-md-up">
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="lunes" id="lunes${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.lunes) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="lunes${reservaPlanificada?.id}">L</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="martes" id="martes${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.martes) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="martes${reservaPlanificada?.id}">M</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.miercoles) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="miercoles${reservaPlanificada?.id}">M</label>
                                            </div>
                                        </div>
                                        <div class="custom-control-inline pequena hidden-lg-up hidden-md-up">
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="jueves" id="jueves${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.jueves) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="jueves${reservaPlanificada?.id}">J</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="viernes" id="viernes${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.viernes) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="viernes${reservaPlanificada?.id}">V</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="sabado" id="sabado${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.sabado) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="sabado${reservaPlanificada?.id}">S</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="domingo" id="domingo${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.domingo) {%>checked=""<%}%> disabled="" >
                                                <label class="custom-control-label" for="domingo${reservaPlanificada?.id}">D</label>
                                            </div>
                                        </div>

                                        <div class="custom-control-inline hidden-sm-down">
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="lunes" id="lunes${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.lunes) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="lunes${reservaPlanificada?.id}">L</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="martes" id="martes${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.martes) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="martes${reservaPlanificada?.id}">M</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.miercoles) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="miercoles${reservaPlanificada?.id}">M</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="jueves" id="jueves${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.jueves) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="jueves${reservaPlanificada?.id}">J</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="viernes" id="viernes${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.viernes) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="viernes${reservaPlanificada?.id}">V</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="sabado" id="sabado${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.sabado) {%>checked=""<%}%> disabled="">
                                                <label class="custom-control-label" for="sabado${reservaPlanificada?.id}">S</label>
                                            </div>
                                            <div class="custom-control custom-checkbox custom-control-inline">
                                                <input type="checkbox" class="custom-control-input" name="domingo" id="domingo${reservaPlanificada?.id}" <%if(reservaPlanificada?.dias?.domingo) {%>checked=""<%}%> disabled="" >
                                                <label class="custom-control-label" for="domingo${reservaPlanificada?.id}">D</label>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </g:each>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


%{--<asset:javascript src="vendors.bundle.js"/>--}%
<asset:javascript src="app.bundle.js"/>
<asset:javascript src="datatables.bundle.js"/>
<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<script type="text/javascript">
    $('.select2').select2();

    <g:if test="${flash.message}">
    $(document).ready( function () {
        toastr.success("${flash.message}");
    });
    </g:if>
    <g:if test="${flash.error}">
    $(document).ready( function () {
        toastr.warning("${flash.error}");
    });
    </g:if>

    function buscarClientePlanificada(valor) {
        $('#cargador').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>');

        if( valor.length >= 4 ) {
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'reserva', action: 'busquedaInteligenteAdmin')}',
                data: {
                    valor: valor,
                    roleString: "ROLE_USER"
                },
                success: function (data, textStatus) {
                    $('#campoUser').html(data);
                    $('#cargador').html('<span class="input-group-text"><i class="fal fa-user"></i></span>');
                    // sleep(100);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $('#cargador').html('<span class="input-group-text"><i class="fal fa-user"></i></span>');
            // sleep(100);
        }
    }
    function sleep(milisegundos) {
        var comienzo = new Date().getTime();
        while (true) {
            if ((new Date().getTime() - comienzo) > milisegundos)
                break;
        }
    }

    $(".datetime").timepicker({
        timeFormat: 'HH:mm',
        showMeridian: false
    });
    var fechaHoy = new Date();
    var fechaMañana = new Date(fechaHoy.setDate(fechaHoy.getDate() + 1));
    var fechaFuturo = new Date(fechaHoy.setDate(fechaHoy.getDate() + 60));
    // var fechaFuturo2 = new Date(fechaHoy.setDate(fechaHoy.getDate() + 60));
    $('.datepicker-1').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right",
        startDate: fechaMañana,
        endDate: fechaFuturo
    });

    $('.datepicker-2').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right",
        startDate: fechaMañana,
        endDate: fechaFuturo
    });

    function Numeros(string){//Solo numeros
        var out = '';
        var filtro = '1234567890';//Caracteres validos

        for (var i=0; i<string.length; i++)
            if (filtro.indexOf(string.charAt(i)) != -1)
                out += string.charAt(i);
        return out;
    }

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
</body>
</html>
