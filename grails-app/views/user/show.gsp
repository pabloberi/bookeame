<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body>
%{--    <g:render template="/layouts/botonera" params="[controlador: 'Usuarios', metodo: 'Ver más' ]" />--}%
<asset:stylesheet src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.css"/>

<div id="show-user" class="content scaffold-show" role="main">
    <sec:ifAnyGranted roles="ROLE_ADMIN">
        <g:if test="${cambioDatosList?.size() > 0}">
            <div class="panel">
                <div class="panel-hdr">
                    <h2>
                        Solicitudes de Cambio de Datos <span class="fw-300"><i></i></span>
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
                                            <th>Fecha Envio Solicitud</th>
                                            <th>Estado</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <g:each in="${cambioDatosList}" status="i" var="cambio">
                                            <tr>
                                                <td>
                                                    <g:link controller="cambioDatos" action="show" id="${cambio?.id}">
                                                        <button id="boton${cambio?.id}" class="btn btn-info btn-xs btn-icon" title="Ver">
                                                            <i class="fal fa-eye"></i>
                                                        </button>
                                                    </g:link>
                                                </td>
                                                <td><g:formatDate format="dd-MM-yyyy HH:mm" date="${cambio?.dateCreated}"/></td>
                                                <td>Pendiente Aprobación</td>
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
        </g:if>
    </sec:ifAnyGranted>

    <div id="panel-7" class="panel">
        <div class="panel-hdr">
            <h2>
                Usuario <span class="fw-300"><i>ver</i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <div class="panel-container show">

            <div class="panel-content">
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    <div class="panel-tag">
                            <p>Cualquier cambio está sujeto a una aprobación.</p>
                    </div>
                </sec:ifAnyGranted>

                <sec:ifAnyGranted roles="ROLE_USER, ROLE_SUPERUSER">
                    <div class="form-group">
                        <label class="form-label" for="enabled">Cuenta</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"></span>
                            </div>
                            <g:field type="text" id="enabled" name="enabled" class="form-control" disabled="" value="${formatBoolean(boolean: user?.enabled, true: "Habilitada", false: "Deshabilitada")}"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="username">Nombre de Usuario</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"></span>
                            </div>
                            <g:field type="text" id="username" name="username" class="form-control" disabled="" value="${user?.username}"/>
                        </div>
                    </div>


                        <div class="form-group">
                            <label class="form-label" for="nombre">Nombre</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"></span>
                                </div>
                                <g:field type="text" id="nombre" name="nombre" class="form-control" disabled="" value="${user?.getNombreCompleto()}"/>
                            </div>
                        </div>
                    <g:if test="${user?.provider != 'google'}">
                        <div class="form-group">
                            <label class="form-label" for="fechaNac">Fecha de Nacimiento</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"></span>
                                </div>
                                <g:field type="text" id="fechaNac" name="fechaNac" class="form-control" disabled="" value="${g.formatDate(format:"dd-MM-yyyy", date: user?.fechaNac)}"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label" for="rutUser">RUT</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"></span>
                                </div>
                                <g:field type="text" id="rutUser" name="rutUser" class="form-control" disabled="" value="${user?.rut + "-" + user?.dv}"/>
                            </div>
                        </div>
                    </g:if>
                    <div class="form-group">
                        <label class="form-label" for="email">Email</label>
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text"></span>
                            </div>
                            <g:field type="text" id="email" name="email" class="form-control" disabled="" value="${user?.email}"/>
                        </div>
                    </div>

                    <g:if test="${user?.provider != 'google'}">
                        <g:form method="POST" controller="user" action="subirImagenPerfil" params="[controlador: 'user', metodo: 'show', id: user?.id]" enctype="multipart/form-data" >
                             <div class="form-group row">
                                <div class="col-sm-12 col-md-8 col-lg-8">
                                    <label class="form-label" for="fotoPerfil">Foto de Perfil</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <span class="input-group-text"></span>
                                        </div>
                                        <g:field type="file" class="form-control filename" name="fotoPerfil" id="fotoPerfil" accept=".jpg, .jpeg, .png" onblur="checkSize()"/>

                                    </div>
                                </div>


                                <div class="col-sm-12 col-md-2 col-lg-2" style="margin-top: 2em;" >
                                    <div class="btn-group btn-group-sm">
                                        <button type="submit" class="btn btn-info btn-sm" title="Guardar">Subir</button>
                                    </div>
                                </div>
                            </div>
                        </g:form>
                    </g:if>

                    <g:form method="POST" controller="user" action="editarCampo">
                    <div class="form-group row">
                        <div class="col-sm-12 col-md-8 col-lg-8">
                            <label class="form-label" for="celular">Celular</label>
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <span class="input-group-text"></span>
                                </div>
                                <g:field type="text" id="celular" name="celular" class="form-control" required="" value="${user?.celular}"/>
                            </div>
                        </div>

                        <div class="col-sm-12 col-md-4 col-lg-4" style="margin-top: 1.5em">
                            <div class="btn-group btn-group-sm">
                                <button type="submit" class="btn btn-info btn-sm" ><i class="fal fa-check" aria-hidden="true"></i></button>
                                <a class="btn btn-secondary btn-sm" href="${createLink(controller: 'user', action: 'show', id: user?.id)}"><i class="fal fa-times" aria-hidden="true"></i></a>
                            </div>
                        </div>
                    </div>
                    </g:form>

                </sec:ifAnyGranted>
            </div>

            <sec:ifAnyGranted roles="ROLE_ADMIN, ROLE_SUPERUSER">
                <div class="panel-container show">
                    <div class="panel-content">
                        <h2 style="text-align: center"><strong>DATOS EMPRESA</strong></h2>
                        <hr>
                        <g:form method="POST" controller="cambioDatos" action="cambioDatosEmpresa" id="${empresa?.id}">
                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="giro">Giro</label>
                                    <g:field type="text" name="giro" id="giro" class="form-control" placeholder="Giro" required="" value="${empresa?.giro}" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="razonSocial">Razón Social</label>
                                    <g:field type="text" name="razonSocial" id="razonSocial" class="form-control" placeholder="Razón Social" required="" value="${empresa?.razonSocial}" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                    <label class="form-label" for="emailEmpresa">Correo</label>
                                    <g:field type="email" id="emailEmpresa" name="emailEmpresa" class="form-control" placeholder="Correo" required="" disabled="" value="${empresa?.email}"/>
                                    <div class="help-block">Este es tu nombre de usuario</div>
                                </div>
                                <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                    <label class="form-label" for="rutEmpresa">Rut</label>
                                    <g:field type="text" name="rutEmpresa" id="rutEmpresa" class="form-control" placeholder="Rut sin puntos" onkeyup="this.value=Numeros(this.value)" required="" value="${empresa?.rut}"/>
                                </div>
                                <div class="col-sm-12 col-md-2 col-lg-2 pr-1">
                                    <label class="form-label" for="dvEmpresa">dv</label>
                                    <g:field type="text" name="dvEmpresa" id="dvEmpresa" class="form-control" placeholder="dv" required="" onchange="validarRutEmpresa()" value="${empresa?.dv}"/>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="direccionEmpresa">Dirección</label>
                                    <g:field type="text" name="direccionEmpresa" id="direccionEmpresa" class="form-control" placeholder="Ciudad, comuna, calle, nro..." required="" value="${empresa?.direccion}"/>
                                </div>
                            </div>

                            <h2 style="text-align: center"><strong>REPRESENTANTE LEGAL</strong></h2>
                            <hr>
                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="nombreRepresentante">Nombre</label>
                                    <g:field type="text" name="nombreRepresentante" id="nombreRepresentante" class="form-control" placeholder="NombreRepresentante" required="" value="${user?.nombre}" />
                                </div>
                            </div>
                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="apellidoPaternoRepresentante">Apellido Paterno</label>
                                    <g:field type="text" name="apellidoPaternoRepresentante" id="apellidoPaternoRepresentante" class="form-control" placeholder="Apellido Paterno" required="" value="${user?.apellidoPaterno}"/>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="nombreRepresentante">Apellido Materno</label>
                                    <g:field type="text" name="apellidoMaternoRepresentante" id="apellidoMaternoRepresentante" class="form-control" placeholder="Apellido Materno" required="" value="${user?.apellidoMaterno}" />
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                    <label class="form-label" for="celularRepresentante">Celular</label>
                                    <g:field type="text" name="celularRepresentante" id="celularRepresentante" class="form-control" placeholder="Celular" required="" value="${user?.celular}"/>
                                </div>
                            </div>

                            <div class="form-group row">
                                <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                    <label class="form-label" for="fechaNacRepresentante">Fecha de Nacimiento</label>
                                    <div class="input-group">
                                        <g:field type="text" id="fechaNacRepresentante" name="fechaNacRepresentante" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" value="${g.formatDate(format:"dd-MM-yyyy", date: user?.fechaNac)}" />
                                        <div class="input-group-append">
                                            <span class="input-group-text fs-xl">
                                                <i class="fal fa-calendar-check"></i>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                    <label class="form-label" for="rutRepresentante">Rut</label>
                                    <g:field type="text" name="rutRepresentante" id="rutRepresentante" class="form-control" placeholder="Rut sin puntos" onkeyup="this.value=Numeros(this.value)" required="" value="${user?.rutRepresentante}"/>
                                </div>
                                <div class="col-sm-12 col-md-2 col-lg-2 pr-1">
                                    <label class="form-label" for="rutRepresentante">dv</label>
                                    <g:field type="text" name="dvRepresentante" id="dvRepresentante" class="form-control" placeholder="dv" required="" onchange="validarRutRepresentante()" value="${user?.dvRepresentante}"/>
                                </div>
                            </div>

                            <div class="row no-gutters">
                                <div class="col-md-4 ml-auto text-right">
                                    <button id="botonRepresentante" type="submit" class="btn btn-block btn-danger btn-lg mt-3">Solicitar Cambio</button>
                                </div>
                            </div>

                        </g:form>
                    </div>
                </div>
            </sec:ifAnyGranted>

        </div>
    </div>
</div>
<asset:javascript src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.js"/>
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>

<script>
    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right"
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

    function editCelular() {
        $('#celular').html(''+
            '<g:form method="POST" controller="user" action="editarCampo">' +
            '<div class="form-group row">'+
            '<div class="col-sm-12 col-md-4 col-lg-4">'+
            '<g:field type="text" id="celular" name="celular" class="form-control" placeholder="Ingrese Celular" required="" value="${user?.celular}"/>' +
            '</div>' +
            '<br><br>' +
            '<div class="col-sm-12 col-md-2 col-lg-2">'+
            '<div class="btn-group btn-group-sm">'+
            '<button type="submit" class="btn btn-info btn-sm" ><i class="fal fa-check" aria-hidden="true"></i></button>'+
            '<a class="btn btn-secondary btn-sm" href="${createLink(controller: 'user', action: 'show', id: user?.id)}"><i class="fal fa-times" aria-hidden="true"></i></a>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</g:form>');
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

    function Numeros(string){//Solo numeros
        var out = '';
        var filtro = '1234567890';//Caracteres validos

        for (var i=0; i<string.length; i++)
            if (filtro.indexOf(string.charAt(i)) != -1)
                out += string.charAt(i);
        return out;
    }


    function validarRutRepresentante() {
        var rut = document.getElementById('rutRepresentante').value;
        var dv = document.getElementById('dvRepresentante').value;

        if( rut.length > 0 && dv.length > 0){
            $.ajax({
                type: 'POST',
                async: false,
                url: '${g.createLink(controller: 'user', action: 'validarDvAjax')}',
                data: {rut: rut, dv: dv},
                success: function (data,textStatus) {

                    if (data == "true") {
                        // $('#boton').attr(disabled, false) ;
                    }else{
                        // e.preventDefault();
                        // $('#boton').attr(disabled, true) ;
                        $('#rutRepresentante').val("");
                        $('#dvRepresentante').val("");
                        alert("Rut no válido");
                    }
                }
            });
        }
    }

    function validarRutEmpresa() {
        var rut = document.getElementById('rutEmpresa').value;
        var dv = document.getElementById('dvEmpresa').value;

        if( rut.length > 0 && dv.length > 0){
            $.ajax({
                type: 'POST',
                async: false,
                url: '${g.createLink(controller: 'user', action: 'validarDvAjax')}',
                data: {rut: rut, dv: dv},
                success: function (data,textStatus) {

                    if (data == "true") {
                        // $('#boton').attr(disabled, false) ;
                    }else{
                        // e.preventDefault();
                        // $('#boton').attr(disabled, true) ;
                        $('#rutEmpresa').val("");
                        $('#dvEmpresa').val("");
                        alert("Rut no válido");
                    }
                }
            });
        }
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
