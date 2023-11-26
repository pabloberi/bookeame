<%@ page import="gestion.General" %>
<!DOCTYPE html>
<!--
Template Name:  SmartAdmin Responsive WebApp - Template build with Twitter Bootstrap 4
Version: 4.0.2
Author: Sunnyat Ahmmed
Website: http://gootbootstrap.com
Purchase: https://wrapbootstrap.com/theme/smartadmin-responsive-webapp-WB0573SK0
License: You must have a valid license purchased only from wrapbootstrap.com (link above) in order to legally use this theme for your project.
-->
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>
        Login
    </title>
    <meta name="description" content="Login">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no, user-scalable=no, minimal-ui">
    <!-- Call App Mode on ios devices -->
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <!-- Remove Tap Highlight on Windows Phone IE -->
    <meta name="msapplication-tap-highlight" content="no">
%{--    <script src="https://apis.google.com/js/platform.js" async defer></script>--}%

    <!-- base css -->
    <asset:stylesheet src="vendors.bundle.css"/>
    <asset:stylesheet src="app.bundle.css"/>
    <!-- Place favicon.ico in the root directory -->
    <asset:link rel="apple-touch-icon" href="apple-touch-icon.png"/>
    <asset:link rel="icon" href="/bookeame/logo.png"/>
    <asset:link rel="mask-icon" href="favicon/safari-pinned-tab.svg" color="#5bbad5"/>
    <!-- Optional: page related CSS-->
    %{--<link rel="stylesheet" media="screen, print" href="css/page-login.css">--}%
    <asset:link rel="stylesheet" media="screen, print" href="page-login.css"/>
%{--    <meta name="google-signin-client_id" content="${General.findByNombre('clientLoginGoogle')?.valor}">--}%

</head>
<body>
%{--style="background-image: url('${General.findByNombre('baseUrl').valor + '/assets/backgrounds/hero-7.png' }');  background-repeat: no-repeat; background-size: cover;"--}%
<div class="blankpage-form-field">
    <div class="page-logo m-0 w-100 align-items-center justify-content-center rounded border-bottom-left-radius-0 border-bottom-right-radius-0 px-4">
        <a href="javascript:void(0)" class="page-logo-link press-scale-down d-flex align-items-center">
            <asset:image src="/bookeame/full-blanco.png" aria-roledescription="logo" style="margin-right: 8em; width: 150px; height: 49px;"/>

%{--            <span class="page-logo-text mr-1">Agenda En Línea</span>--}%
            <i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>
        </a>
    </div>
    <div class="card p-4 border-top-left-radius-0 border-top-right-radius-0">
        <form accept-charset="UTF-8" role="form" id='loginForm' action="${postUrl ?: '/login/authenticate'}" autocomplete="off" method="POST">
            <g:if test="${flash.message}">
                <div class="alert alert-danger" role="alert">
                    <strong>Ups!</strong> ${flash.message}
                </div>
            </g:if>
            <div class="form-group">
                <label class="form-label" for="username">Correo</label>
                <g:if test="${params?.usr}">
                    <input type="text" id="username" class="form-control" placeholder="Correo" name='${usernameParameter ?: 'username'}' required value="${params?.usr}" readonly>
                </g:if>
                <g:else>
                    <input type="text" id="username" class="form-control" placeholder="Correo" name='${usernameParameter ?: 'username'}' required>
                </g:else>
            </div>
            <div class="form-group">
                <label class="form-label" for="password">Contraseña</label>
                <input type="password" id="password" class="form-control" name='${passwordParameter ?: 'password'}' placeholder="Contraseña" required>
            </div>

                <button type="submit" class="btn btn-default float-right">Entrar</button>

        </form>
    </div>
    <div class="blankpage-footer text-center">
        <a href="${createLink(controller: 'user', action: 'recuperarPass')}"><strong>Recuperar Contraseña</strong></a>
        |
        <g:if test="${ !params?.usr }">
            <a href="${createLink(controller: 'user', action: 'registro')}"><strong>Registrate</strong></a>
        </g:if>

        <g:if test="${ !params?.disabledOauth}">
            <div id="login-google">
            <oauth2:connect provider="google" id="google-connect-link">
                <button type="button" class="btn btn-lg btn-outline-secondary mt-6">
                    <asset:image src="/google.png" style="width: 35px;" class="mr-1" />
                    Iniciar con Google
                </button>
            </oauth2:connect>
            </div>
        </g:if>
    </div>

</div>
<g:render template="modalWebView" />
<asset:javascript src="vendors.bundle.js"/>
<asset:javascript src="app.bundle.js"/>
<!-- Page related scripts -->
<script>
    window.onload = function() {
        isWebView();
    };
    function isWebView() {
        $.ajax({
            type: 'POST',
            url: '${g.createLink(controller: 'general', action: 'esWebView')}',
            data: { d:"" },
            success: function (data, textStatus) {
                if (data === 'true') {
                    esconderBotonGoogle();
                }
            }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                return false;
            }
        });
    }

    function esconderBotonGoogle(){
        var divAEsconder = document.getElementById('login-google');
        divAEsconder.style.display = 'none';
        $('#modalwebview').modal('show');
    }
    // Establecemos las variables
    var answer = document.getElementById("copyAnswer");
    var copy   = document.getElementById("copiarEnlace");
    copy.addEventListener('click', function(e) {
        var aux = document.createElement("input");
        aux.setAttribute("value","https://www.bookeame.cl/login/auth");
        document.body.appendChild(aux);
        aux.select();
        try {
            // Copiando el texto seleccionado
            var successful = document.execCommand('copy');

            if(successful) answer.innerHTML = 'Copiado!';
            else answer.innerHTML = 'Incapaz de copiar!';
        } catch (err) {
            answer.innerHTML = 'Browser no soportado!';
        }
        // document.execCommand("copy");
        document.body.removeChild(aux);
    });

</script>
</body>
</html>
