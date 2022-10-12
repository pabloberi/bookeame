<%@ page import="flow.Comision" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.labe}l', default: 'Espacio')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>
</head>
<body>

    <div id="panel-11" class="panel">
        <div class="panel-hdr">
            <h2>
                Configuraciones <span class="fw-300"><i class="fal fa-cogs"></i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">
            <div class="panel-content">
                <div class="border px-3 pt-3 pb-0 rounded">
                    <ul class="nav nav-pills" role="tablist">
                        <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#reservas_conf"><i class="fal fa-clock mr-1"></i>Reservas</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#formas_pago"><i class="fal fa-dollar-sign mr-1"></i>Formas de Pago</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#perfil"><i class="fal fa-user mr-1"></i>Perfil</a></li>
                    </ul>
                    <div class="tab-content py-3 mt-4">
                        <div class="tab-pane fade show active" id="reservas_conf" role="tabpanel">
                            <g:render template="configuracionReserva"/>
                        </div>
                        <div class="tab-pane fade" id="formas_pago" role="tabpanel">
                            <g:render template="configuracionFormasPago"/>
                        </div>
                        <div class="tab-pane fade" id="perfil" role="tabpanel">
                            <g:render template="configuracionPerfil" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
%{--    <div id="panel-7" class="panel">--}%
%{--        <asset:stylesheet src="formplugins/timepicker/css/bootstrap-timepicker.css"/>--}%
%{--        <asset:javascript src="formplugins/timepicker/js/bootstrap-timepicker.js"/>--}%

%{--        <div class="panel-hdr">--}%
%{--            <h2>--}%
%{--                Configuraciones <span class="fw-300"><i>Empresa</i></span>--}%
%{--            </h2>--}%
%{--            <div class="panel-toolbar">--}%
%{--                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>--}%
%{--                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>--}%
%{--                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--        <div class="panel-container show">--}%
%{--            <div class="panel-content">--}%
%{--                <legend>Configuración de Reservas</legend>--}%
%{--                <hr>--}%
%{--                <g:form method="POST" controller="configuracionEmpresa" action="guardarConfiguracionEmpresa" id="${configuracionEmpresa?.id}">--}%

%{--                    <div class="form-group row">--}%
%{--                        <div class="col-sm-12 col-md-6 col-lg-6">--}%
%{--                            <label class="form-label" for="diasAMostrar">Fecha máxima Reservas</label>--}%
%{--                        </div>--}%

%{--                        <div class="col-sm-12 col-md-6 col-lg-6">--}%
%{--                            <div class="input-group">--}%
%{--                                <div class="input-group-prepend">--}%
%{--                                    <span class="input-group-text"></span>--}%
%{--                                </div>--}%
%{--                                <g:field type="number" id="diasAMostrar" min="2" max="30" name="diasAMostrar" class="form-control" placeholder="Ingrese un número entre 2 y 30" required="" value="${configuracionEmpresa?.diasAMostrar}"/>--}%
%{--                            </div>--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--                    <br><br>--}%
%{--                    <div class="form-group row">--}%
%{--                        <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">--}%
%{--                            <label class="form-label" >Formas de Pago de Reservas</label>--}%
%{--                        </div>--}%
%{--                        <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">--}%
%{--                            <div class="frame-wrap">--}%
%{--                                <div class="custom-control custom-checkbox custom-control-inline">--}%
%{--                                    <input onchange="ocultarDatosFlow()" type="checkbox" class="custom-control-input" name="prepago" id="prepago"  <%if(configuracionEmpresa?.tipoPago?.prepago) {%>checked=""<%}%> >--}%
%{--                                    <label class="custom-control-label" for="prepago">Pre pago</label>--}%
%{--                                </div>--}%
%{--                                <div class="custom-control custom-checkbox custom-control-inline">--}%
%{--                                    <input type="checkbox" class="custom-control-input" name="pospago" id="pospago" <%if(configuracionEmpresa?.tipoPago?.pospago) {%>checked=""<%}%> >--}%
%{--                                    <label class="custom-control-label" for="pospago">Pos pago</label>--}%
%{--                                </div>--}%
%{--                            </div>--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--    --}%%{--                <br><br>--}%
%{--                        <div id="datosFlow">--}%
%{--                            <h6>Datos Flow</h6>--}%
%{--                            <hr>--}%
%{--                            <div class="form-group row">--}%
%{--                                <div class="col-sm-12 col-md-6 col-lg-6">--}%
%{--                                    <label class="form-label" for="apiKey">ApiKey</label>--}%
%{--                                </div>--}%

%{--                                <div class="col-sm-12 col-md-6 col-lg-6">--}%
%{--                                    <div class="input-group">--}%
%{--                                        <div class="input-group-prepend">--}%
%{--                                            <span class="input-group-text"></span>--}%
%{--                                        </div>--}%
%{--                                        <g:field type="text" id="apiKey" name="apiKey" class="form-control" placeholder="Ingrese ApiKey de Flow" required="" value="${flowEmpresa?.apiKey}"/>--}%
%{--                                    </div>--}%
%{--                                </div>--}%
%{--                            </div>--}%
%{--                            <div class="form-group row">--}%
%{--                                <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">--}%
%{--                                    <label class="form-label" >SecretKey</label>--}%
%{--                                </div>--}%
%{--                                <div class="col-sm-12 col-md-6 col-lg-6">--}%
%{--                                    <div class="input-group">--}%
%{--                                        <div class="input-group-prepend">--}%
%{--                                            <span class="input-group-text"></span>--}%
%{--                                        </div>--}%
%{--                                        <g:field type="text" id="secretKey" name="secretKey" class="form-control" placeholder="Ingrese SecretKey de Flow" required="" value="${flowEmpresa?.secretKey}"/>--}%
%{--                                    </div>--}%
%{--                                </div>--}%
%{--                            </div>--}%

%{--                            <div class="form-group row">--}%
%{--                                <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">--}%
%{--                                    <label class="form-label" >Comisión</label>--}%
%{--                                </div>--}%
%{--                                <div class="col-sm-12 col-md-6 col-lg-6">--}%
%{--                                    <div class="input-group">--}%
%{--    --}%%{--                                    <div class="input-group-prepend">--}%
%{--    --}%%{--                                        <span class="input-group-text"></span>--}%
%{--    --}%%{--                                    </div>--}%
%{--                                        <g:select name="comision" id="comision" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${Comision.list()}" noSelection="['':'- Seleccione Comisión -']" value="${flowEmpresa?.comision?.id}"/>--}%
%{--                                        <div class="help-block">Comsión de Flow por transacción ( Cargo al cliente )</div>--}%

%{--                                    </div>--}%
%{--                                </div>--}%
%{--                            </div>--}%
%{--                        </div>--}%
%{--                    <br><br>--}%
%{--                    <div class="col-sm-12 col-md-2 col-lg-2" style="float: right;">--}%
%{--                        <div class="btn-group btn-group-sm">--}%
%{--                            <button type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--                    <br><br>--}%

%{--                </g:form>--}%

%{--            </div>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--    <div id="panel-10" class="panel">--}%
%{--        <div class="panel-hdr">--}%
%{--            <h2>--}%
%{--                Perfil <span class="fw-300"><i>Empresa</i></span>--}%
%{--            </h2>--}%
%{--            <div class="panel-toolbar">--}%
%{--                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>--}%
%{--                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>--}%
%{--                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--        <div class="panel-container show">--}%
%{--            <div class="panel-content">--}%

%{--                <g:form method="POST" controller="user" action="subirImagenPerfil" params="[controlador: 'configuracionEmpresa', metodo: 'configuracionEmpresa']" enctype="multipart/form-data" >--}%
%{--                <div class="form-group row">--}%
%{--                    <div class="col-sm-12 col-md-10 col-lg-10">--}%
%{--                        <label class="form-label" for="fotoPerfil">Foto Perfil</label>--}%
%{--                        <div class="input-group">--}%
%{--                            <div class="input-group-prepend">--}%
%{--                                <span class="input-group-text"></span>--}%
%{--                            </div>--}%
%{--                            <g:field type="file" class="form-control filename" name="fotoPerfil" id="fotoPerfil" accept=".jpg, .jpeg, .png" onblur="checkSize()"/>--}%
%{--    --}%%{--                        <label class="custom-file-label" for="fotoPerfil" id="nombreFoto" >Elegir Foto</label>--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--                    <div class="col-sm-12 col-md-2 col-lg-2" style="margin-top: 2em;" >--}%
%{--                        <div class="btn-group btn-group-sm">--}%
%{--                            <button type="submit" class="btn btn-info btn-sm" title="Guardar">Subir</button>--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--                </div>--}%
%{--                <br><br>--}%
%{--                </g:form>--}%

%{--                <g:form method="POST" controller="configuracionEmpresa" action="guardarTelefono" >--}%
%{--                    <div class="form-group row">--}%
%{--                        <div class="col-sm-12 col-md-10 col-lg-10">--}%
%{--                            <label class="form-label" for="fotoPerfil">Teléfono Contacto para Clientes</label>--}%
%{--                            <g:field type="text" class="form-control" name="fono" id="fono" placeholder="Teléfono de contacto para tus clientes" value="${configuracionEmpresa?.fono}"/>--}%
%{--                        </div>--}%
%{--                        <div class="col-sm-12 col-md-2 col-lg-2" style="margin-top: 2em;" >--}%
%{--                            <div class="btn-group btn-group-sm">--}%
%{--                                <button type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>--}%
%{--                            </div>--}%
%{--                        </div>--}%
%{--                    </div>--}%
%{--                </g:form>--}%


%{--                --}%%{--            <img id="foto" src="#" alt="Cargue una imagen" style="width: 100px; height: 150px;" />--}%
%{--                <br><br>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--    </div>--}%

    <script>

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
        function ocultarDatosFlow() {
            var datosFlow = document.getElementById("datosFlow");
            var check = document.getElementById("prepago");
            if( $("#prepago").prop('checked') ){
                datosFlow.style.display = "block";
                $("#apiKey").attr('required', true);
                $("#secretKey").attr('required', true);
                $("#comision").attr('required', true);
            }else{
                datosFlow.style.display = "none";
                $("#apiKey").attr('required', false);
                $("#secretKey").attr('required', false);
                $("#comision").attr('required', false);
            }
        }

        $( document ).ready(function() {
            var datosFlow = document.getElementById("datosFlow");
            var check = document.getElementById("prepago");
            if( $("#prepago").prop('checked') ){
                datosFlow.style.display = "block";
                $("#apiKey").attr('required', true);
                $("#secretKey").attr('required', true);
                $("#comision").attr('required', true);
            }else{
                datosFlow.style.display = "none";
                $("#apiKey").attr('required', false);
                $("#secretKey").attr('required', false);
                $("#comision").attr('required', false);
            }
        });

        function checkSize() {
            var fileSize = $('#fotoPerfil')[0].files[0].size;
            var sizekiloByte = parseInt(fileSize / 1024);
            // console.log(fileSize);
            // console.log(sizekiloByte);

            if (sizekiloByte >  3072 ) {
                // console.log('entre al if');
                alert("Máximo 3 MB, su archivo pesa " +  sizekiloByte/1024 + " MB");
                document.getElementById("fotoPerfil").value = '';
                return false;
            }
        }

    </script>
</body>
</html>

