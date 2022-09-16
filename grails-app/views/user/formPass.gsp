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
                                    Recuperar Contraseña
                                    <small class="h3 fw-300 mt-3 mb-5 text-white opacity-60 hidden-sm-down">
                                        Disfruta BOOKEAME en todas nuestras plataformas App, Escritorio o tablet.
                                    </small>
                                </h2>
                            </div>

                            <div class="col-xl-6 ml-auto mr-auto" id="opcionPerfil">
                                <div class="card p-4 rounded-plus bg-faded">
                                    <g:if test="${flash.message != null }">
                                        <div class="panel-tag" id="msjError" >
                                            ${flash.message}
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <g:form method="POST" controller="user" action="cambiarPassRecupera" id="${id}" >
                                            <div class="form-group row">
                                                <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                    <label class="col-xl-12 form-label" for="password">Contraseña Nueva</label>
                                                    <g:passwordField type="text" id="password" name="password" class="form-control" placeholder="Contraseña" required=""/>
                                                </div>

                                                <div class="col-sm-12 col-md-6 col-lg-6 pr-1">
                                                    <label class="col-xl-12 form-label" for="password2">Confirmar Contraseña</label>
                                                    <g:passwordField type="text" id="password2" name="password2" class="form-control" placeholder="Repita Contraseña" required=""/>
                                                </div>
                                                <g:hiddenField name="token" value="${params?.token}"/>
                                            </div>
                                        <div class="row no-gutters">
%{--                                            <div class="col-md-4 ml-auto text-right">--}%
%{--                                                <button class="g-recaptcha" data-sitekey="${General.findByNombre('publicKeyCaptcha')?.valor}" data-callback='onSubmit' data-action='submit'>Submit</button>--}%
%{--                                            </div>--}%
                                            <div class="col-md-4 ml-auto text-right">
                                                <button id="js-login-btn" type="submit" class="btn btn-block btn-success btn-lg mt-3">Enviar</button>
                                            </div>
                                        </div>
                                        </g:form>
                                    </g:else>
                                </div>
                            </div>
                            </div>
                        </div>
                    </div>
                    <div class="position-absolute pos-bottom pos-left pos-right p-3 text-center text-white">
                        Gestión OnLine <script>document.write(new Date().getFullYear())</script>
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
        document.getElementById("${id}").submit();
    }
    $('form').submit(function (e) {
        var string1 = document.getElementById('password').value;
        var string2 = document.getElementById('password2').value;
        var msj = document.getElementById('msjPass');
        var boton = document.getElementById('botonForm');
        $.ajax({
            type: 'POST',
            async: false,
            url: '${g.createLink(controller: 'user', action: 'compararPass')}',
            data: {string1: string1, string2: string2},
            success: function (data,textStatus) {

                if (data == "false") {
                    e.preventDefault();
                    alert("Contraseñas no coinciden");
                }
            }
        });
    });
</script>
%{--{{/inline}}--}%

%{--{{/layouts/auth}}--}%