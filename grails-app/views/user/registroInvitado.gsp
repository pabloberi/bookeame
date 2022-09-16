<%@ page import="gestion.General" %>

<!DOCTYPE html>
<html>
<head>
    <g:applyLayout name="dashboard_header"/>
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body>
<!-- save-settings-script -->
<g:applyLayout name="_script-loading-saving"/>
<asset:javascript src="jquery-3.4.1.min.js"/>
<asset:stylesheet src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.css"/>
    <div class="page-wrapper">
        <div class="page-inner bg-brand-gradient">
            <div class="page-content-wrapper bg-transparent m-0">
                <div class="height-10 w-100 shadow-lg px-4 bg-brand-gradient">
                    <div class="d-flex align-items-center container p-0">

                        <div class="page-logo width-mobile-auto m-0 align-items-center justify-content-center p-0 bg-transparent bg-img-none shadow-0 height-9">
                            <a href="javascript:void(0)" class="page-logo-link press-scale-down d-flex align-items-center">
                                <asset:image src="bookeame/full-blanco.png" alt="" style="width: 160px; height: 53px;" />
%{--                                <span class="page-logo-text mr-1">Agenda En Línea</span>--}%
                            </a>
                        </div>
                        <span class="text-white opacity-50 ml-auto mr-2 hidden-sm-down">
                            ya eres miembro?
                        </span>
                        <a href="${createLink(controller: 'login', action: 'auth')}" class="btn-link text-white ml-auto ml-sm-0">
                            Inicia Sesión
                        </a>
                    </div>
                </div>

                <div class="flex-1" style="background: no-repeat center bottom fixed; background-size: cover;">
                    <div class="container py-4 py-lg-5 my-lg-5 px-4 px-sm-0">
                        <div class="row">

                            <div class="col-xl-12">
                                <h2 class="fs-xxl fw-500 mt-4 text-white text-center">
                                    Registrate ahora, es gratis!
                                    <small class="h3 fw-300 mt-3 mb-5 text-white opacity-60 hidden-sm-down">
                                        Tu registro es gratis con nosotros. Disfruta BOOKEAME en todas nuestras plataformas App, Escritorio o tablet.
                                        <br>Identifica tu perfil
                                    </small>
                                </h2>
                            </div>

                            <div class="col-xl-8 ml-auto mr-auto" id="opcionPerfil">
                                <div class="card p-4 rounded-plus bg-faded">
                                    <g:if test="${flash.message != null }">
                                        <div class="panel-tag" id="msjError" >
                                            ${flash.message}
                                        </div>
                                    </g:if>
                                            <h4  style="text-align: right">Datos Personales</h4>

                                            <g:form method="POST" controller="user" action="editarUserInvitado" id="${user?.id}">

                                                <div class="form-group row">
                                                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                                        <label class="form-label" for="nombre">Nombre</label>
                                                        <g:field type="text" name="nombre" id="nombre" class="form-control" placeholder="Nombre" required="" value="${user?.nombre}"/>
                                                    </div>
                                                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                                        <label class="form-label" for="apellidoPaterno">Apellido Paterno</label>
                                                        <g:field type="text" name="apellidoPaterno" id="apellidoPaterno" class="form-control" placeholder="Apellido Paterno" required="" />
                                                    </div>
                                                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                                        <label class="form-label" for="nombre">Apellido Materno</label>
                                                        <g:field type="text" name="apellidoMaterno" id="apellidoMaterno" class="form-control" placeholder="Apellido Materno" required="" />
                                                    </div>
                                                </div>

                                                <div class="form-group row">
                                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                        <label class="form-label" for="email">Correo</label>
                                                        <g:field type="email" id="email" name="email" class="form-control" placeholder="Correo" required="" value="${user?.email}" readonly="" />
                                                        <div class="help-block">Tu correo será tu username</div>
                                                    </div>
                                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                        <label class="form-label" for="email">Celular</label>
                                                        <g:field type="text" name="celular" id="celular" class="form-control" placeholder="Celular" required="" value="${user?.celular}" readonly=""/>
                                                    </div>
                                                </div>

%{--                                                <div class="form-group">--}%
%{--                                                    <label class="form-label" for="direccion">Dirección</label>--}%
%{--                                                    <g:field type="text" name="direccion" id="direccion" class="form-control" placeholder="Ciudad, comuna, calle, nro..." required="" />--}%
%{--                                                </div>--}%

                                                <div class="form-group row">
                                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                        <label class="form-label" for="fechaNac">Fecha de Nacimiento</label>
                                                        <div class="input-group">
                                                            <g:field type="text" id="fechaNac" name="fechaNac" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
                                                            <div class="input-group-append">
                                                                <span class="input-group-text fs-xl">
                                                                    <i class="fal fa-calendar-check"></i>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-12 col-md-4 col-lg-4 pr-1">
                                                        <label class="form-label" for="rut">Rut</label>
                                                        <g:field type="text" name="rut" id="rut" class="form-control" placeholder="Rut" required="" onkeyup="this.value=Numeros(this.value)" />
                                                    </div>
                                                    <div class="col-sm-12 col-md-2 col-lg-2 pr-1">
                                                        <label class="form-label" for="rut">dv</label>
                                                        <g:field type="text" name="dv" id="dv" class="form-control" placeholder="dv" required="" onchange="validarRut()"/>
                                                    </div>
                                                </div>

                                                <div class="form-group row">
                                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                        <label class="form-label" for="password">Contraseña</label>
                                                        <g:passwordField type="text" id="password" name="password" class="form-control" placeholder="Contraseña" required=""/>
                                                        <div class="invalid-feedback">Contraseñas distintas</div>
                                                    </div>
                                                    <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                        <label class="form-label" for="password2">Confirmar Contraseña</label>
                                                        <g:passwordField type="text" id="password2" name="password2" class="form-control" placeholder="Repita Contraseña" required=""/>
                                                        <div class="invalid-feedback">Contraseñas distintas</div>
                                                    </div>

                                                </div>

                                                <div class="form-group demo">
                                                    <div class="custom-control custom-checkbox">
                                                        <g:field type="checkbox" name="terms" class="custom-control-input" id="terms" required="" />
                                                        <label class="custom-control-label" for="terms"> Acepto término y condiciones</label>
                                                        %{--					<div class="invalid-feedback">You must agree before proceeding</div>--}%
                                                    </div>
                                                </div>

                                                <div class="row no-gutters">
                                                    <div class="col-md-4 ml-auto text-right">
                                                        <button id="boton" type="submit" class="btn btn-block btn-danger btn-lg mt-3">Registrarme</button>
                                                    </div>
                                                </div>
                                            </g:form>


                        </div>
                    </div>
                    <div class="position-absolute pos-bottom pos-left pos-right p-3 text-center text-white">
                        BOOKEAME <script>document.write(new Date().getFullYear())</script>
                    </div>
                </div>
            </div>
        </div>
    </div>
<script src="https://www.google.com/recaptcha/api.js"></script>

<asset:javascript src="vendors.bundle.js"/>
<asset:javascript src="app.bundle.js"/>
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
<asset:javascript src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.js"/>

</body>
</html>
%{--{{/inline}}--}%

%{--{{#*inline "scripts-block"}}--}%
<script>

    function onSubmit(token) {
        document.getElementById("${user?.id}").submit();
    }

    function Numeros(string){//Solo numeros
        var out = '';
        var filtro = '1234567890';//Caracteres validos

        for (var i=0; i<string.length; i++)
            if (filtro.indexOf(string.charAt(i)) != -1)
                out += string.charAt(i);
        return out;
    }

    $('.datepicker').datepicker({
        todayHighlight: true,
        language: 'esp',
        orientation: "bottom right"
    });

    $("#js-login-btn").click(function(event) {

        // Fetch form to apply custom Bootstrap validation
        var form = $("#js-login")

        if (form[0].checkValidity() === false) {
            event.preventDefault()
            event.stopPropagation()
        }

        form.addClass('was-validated');
        // Perform ajax submit here...
    });

    $('form').submit(function (e) {
        var string1 = document.getElementById('password').value;
        var string2 = document.getElementById('password2').value;

        $.ajax({
            type: 'POST',
            async: false,
            url: '${g.createLink(controller: 'user', action: 'compararPass')}',
            data: {string1: string1, string2: string2},
            success: function (data,textStatus) {

                if (data == "true") {
                    $('.errorPass').style.display = 'none';
                    // $('#boton').attr(disabled, false) ;
                    // console.log("son iguales")
                }else{
                    e.preventDefault();
                    alert("Contraseñas no coinciden");
                    // console.log("son distintas");
                    // console.log(data)
                }
            }
        });
    });

    function validarRut() {
        var rut = document.getElementById('rut').value;
        var dv = document.getElementById('dv').value;

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
                        $('#rut').val("");
                        $('#dv').val("");
                        alert("Rut no válido");
                    }
                }
            });
        }
    }

</script>
%{--{{/inline}}--}%

%{--{{/layouts/auth}}--}%