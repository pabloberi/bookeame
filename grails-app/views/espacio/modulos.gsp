<%@ page import="espacio.TipoEspacio" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>

    </head>
    <body>
    <asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
    <asset:javascript src="/formplugins/select2/select2.bundle.js"/>
    <asset:stylesheet src="formplugins/timepicker/css/bootstrap-timepicker.css"/>
    <asset:javascript src="formplugins/timepicker/js/bootstrap-timepicker.js"/>

        <div class="content scaffold-show" role="main">
            <div class="col-md-4">
                <button onclick="nuevoModulo()" class="btn btn-primary btn-md">Nuevo</button>
                <g:if test="${moduloList.size() == 0}">
                    <button onclick="nuevoMasivo()" class="btn btn-outline-info btn-md">Masivo</button>
                </g:if>
            </div>

            <br>
            <div id="formularioNuevo"></div>
%{--            <div id="formularioMasivo"></div>--}%

%{--            <g:each in="${moduloList}" var="modulo" status="i">--}%
%{--                <g:render template="formModuloEdit" model="[modulo: modulo]"/>--}%
%{--            </g:each>--}%
            <div id="panel-8" class="panel">
                <div class="panel-hdr">
                    <h2>
                        Lista Módulos <span class="fw-300"><i>${ espacio?.nombre} </i></span>
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
                            <g:if test="${moduloList?.size() > 0}">
                                <div class="form-group">
                                    <label class="form-label" for="editMasivo">Edición Masiva de módulos</label>
                                    <br> <br>
                                    <g:form method="POST" controller="espacio" action="edicionMasivaModulos" id="${espacio?.id}">
                                    <div class="input-group" id="editMasivo">
                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="lunes" id="lunes">
                                            <label class="custom-control-label" for="lunes">L</label>
                                        </div>
                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="martes" id="martes" >
                                            <label class="custom-control-label" for="martes">M</label>
                                        </div>
                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles" >
                                            <label class="custom-control-label" for="miercoles">M</label>
                                        </div>

                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="jueves" id="jueves" >
                                            <label class="custom-control-label" for="jueves">J</label>
                                        </div>
                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="viernes" id="viernes" >
                                            <label class="custom-control-label" for="viernes">V</label>
                                        </div>
                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="sabado" id="sabado" >
                                            <label class="custom-control-label" for="sabado">S</label>
                                        </div>
                                        <div class="custom-control custom-checkbox custom-control-inline">
                                            <input type="checkbox" class="custom-control-input" name="domingo" id="domingo" >
                                            <label class="custom-control-label" for="domingo">D</label>
                                        </div>
                                    </div>
                                    <br> <br>
                                    <div class="input-group-prepend">
                                        <button type="submit" class="btn btn-success" title="Editar Todos los Módulos" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Editar Todo</button>
                                    </div>
                                    </g:form>
                                </div>
                            </g:if>
                            <hr>
                            <div class="d-flex flex-column h-100">
                                <div class="h-auto">
                                    %{--<table class="table table-sm m-0" id="simpledatatables">--}%
                                    <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">

                                        <thead class="bg-primary-500">
                                        <tr>
%{--                                            <th>--}%
%{--                                                <div class="form-check">--}%
%{--                                                    <input type="checkbox" class="form-check-input" id="exampleCheck2">--}%
%{--                                                    <label class="form-check-label" for="exampleCheck2">Todo</label>--}%
%{--                                                </div>--}%
%{--                                            </th>--}%
                                            <th>Acción</th>
                                            <th>Hora Inicio</th>
                                            <th>Hora Término</th>
                                            <th>valor</th>
                                            <th>Días</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <g:each in="${moduloList}" status="i" var="modulo" >
                                            <tr>
%{--                                                <td>--}%
%{--                                                    <div class="form-check">--}%
%{--                                                        <input type="checkbox" class="form-check-input" id="exampleCheck${i}">--}%
%{--                                                        <label class="form-check-label" for="exampleCheck${i}"></label>--}%
%{--                                                    </div>--}%
%{--                                                </td>--}%
                                                <td>
%{--                                                    <g:link controller="espacio" action="show" id="${modulo?.id}">--}%
                                                    <button id="boton${modulo?.id}" class="btn btn-info btn-xs btn-icon" title="Editar" data-toggle="modal" data-target="#modulo${modulo?.id}">
                                                        <i class="fal fa-pencil"></i>
                                                    </button>
%{--                                                    </g:link>--}%
                                                </td>
                                                <td>${modulo?.horaInicio}</td>
                                                <td>${modulo?.horaTermino}</td>
                                                <td>$ ${modulo?.valor}</td>
                                                <td>
                                                    <div class="custom-control-inline pequena hidden-lg-up hidden-md-up">
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="lunes" id="lunes${modulo?.id}" <%if(modulo?.dias?.lunes) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="lunes${modulo?.id}">L</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="martes" id="martes${modulo?.id}" <%if(modulo?.dias?.martes) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="martes${modulo?.id}">M</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles${modulo?.id}" <%if(modulo?.dias?.miercoles) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="miercoles${modulo?.id}">M</label>
                                                        </div>
                                                    </div>
                                                    <div class="custom-control-inline pequena hidden-lg-up hidden-md-up">
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="jueves" id="jueves${modulo?.id}" <%if(modulo?.dias?.jueves) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="jueves${modulo?.id}">J</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="viernes" id="viernes${modulo?.id}" <%if(modulo?.dias?.viernes) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="viernes${modulo?.id}">V</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="sabado" id="sabado${modulo?.id}" <%if(modulo?.dias?.sabado) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="sabado${modulo?.id}">S</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="domingo" id="domingo${modulo?.id}" <%if(modulo?.dias?.domingo) {%>checked=""<%}%> disabled="" >
                                                            <label class="custom-control-label" for="domingo${modulo?.id}">D</label>
                                                        </div>
                                                    </div>

                                                    <div class="custom-control-inline hidden-sm-down">
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="lunes" id="lunes${modulo?.id}" <%if(modulo?.dias?.lunes) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="lunes${modulo?.id}">L</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="martes" id="martes${modulo?.id}" <%if(modulo?.dias?.martes) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="martes${modulo?.id}">M</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles${modulo?.id}" <%if(modulo?.dias?.miercoles) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="miercoles${modulo?.id}">M</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="jueves" id="jueves${modulo?.id}" <%if(modulo?.dias?.jueves) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="jueves${modulo?.id}">J</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="viernes" id="viernes${modulo?.id}" <%if(modulo?.dias?.viernes) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="viernes${modulo?.id}">V</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="sabado" id="sabado${modulo?.id}" <%if(modulo?.dias?.sabado) {%>checked=""<%}%> disabled="">
                                                            <label class="custom-control-label" for="sabado${modulo?.id}">S</label>
                                                        </div>
                                                        <div class="custom-control custom-checkbox custom-control-inline">
                                                            <input type="checkbox" class="custom-control-input" name="domingo" id="domingo${modulo?.id}" <%if(modulo?.dias?.domingo) {%>checked=""<%}%> disabled="" >
                                                            <label class="custom-control-label" for="domingo${modulo?.id}">D</label>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <g:render template="formModuloEdit" model="[modulo: modulo]"/>
                                        </g:each>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>

    <asset:javascript src="datagrid/datatables/datatables.bundle.js"/>

    <script>
        $('.select2').select2();
        // $(".datetime").timepicker({
        //     timeFormat: 'HH:mm',
        //     showMeridian: false
        // });

        function validarHorario(){

        }

        function nuevoModulo() {
            $('#formularioNuevo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
            var espacioId = ${espacio?.id}
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'modulo', action: 'insertarForm')}',
                data: { id: espacioId },
                success: function (data, textStatus) {
                    $('#formularioNuevo').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }

        function nuevoMasivo() {
            $('#formularioNuevo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
            var espacioId = ${espacio?.id}
                $.ajax({
                    type: 'POST',
                    url: '${g.createLink(controller: 'modulo', action: 'insertarFormMasivo')}',
                    data: { id: espacioId },
                    success: function (data, textStatus) {
                        $('#formularioNuevo').html(data)
                        sleep(1000);
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
