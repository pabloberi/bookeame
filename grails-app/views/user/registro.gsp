%{--{{#> --}%
%{--	layouts/auth --}%
%{--	title="Login" --}%
%{--	pagename="page_login"--}%
%{--}}--}%

%{--{{#*inline "head-block"}}--}%
%{--<link rel="stylesheet" media="screen, print" href="css/fa-brands.css">--}%
%{--{{/inline}}--}%

%{--{{#*inline "content-block"}}--}%
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

                            <div class="col-xl-6 ml-auto mr-auto" id="opcionPerfil">
                                <div class="card p-4 rounded-plus bg-faded">
                                    <g:if test="${flash.message != null }">
                                        <div class="panel-tag" id="msjError" >
                                            ${flash.message}
                                        </div>
                                    </g:if>
                                    <g:else>
                                        <small class="h3 fw-300 mt-3 mb-5 text-black-50 opacity-100 hidden-sm-down" style="text-align: center;">
                                            Unirme como!
                                        </small>
                                        <button type="button" class="btn btn-outline-success btn-pills btn-lg btn-block" onclick="mostrarUser()" >
                                            <span>Usuario</span>
                                        </button>
                                        <button type="button" class="btn btn-outline-success btn-pills btn-lg btn-block" onclick="mostrarAdmin()">
                                            <span>Empresa</span>
                                        </button>
                                    </g:else>
                                </div>
                            </div>
                            <g:render template="registroUserForm" model="[mensaje: mensaje]"/>
                            <g:render template="registroAdminForm" model="[mensaje: mensaje]"/>
                        </div>
                    </div>
                    <div class="position-absolute pos-bottom pos-left pos-right p-3 text-center text-white">
                        BOOKEAME <script>document.write(new Date().getFullYear())</script>
                    </div>
                </div>
            </div>
        </div>
    </div>

%{--<asset:javascript src="vendors.bundle.js"/>--}%
%{--<asset:javascript src="app.bundle.js"/>--}%
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>
<asset:javascript src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.js"/>

</body>
</html>
%{--{{/inline}}--}%

%{--{{#*inline "scripts-block"}}--}%
<script>

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

    function mostrarUser() {
        var opcion = document.getElementById('opcionPerfil');
        var formUser = document.getElementById('formUser');
        var formAdmin = document.getElementById('formAdmin');

        opcion.style.display = 'none';
        formUser.style.display = 'inline-block';
        formAdmin.style.display = 'none';
    }
    function mostrarAdmin() {
        var opcion = document.getElementById('opcionPerfil');
        var formUser = document.getElementById('formUser');
        var formAdmin = document.getElementById('formAdmin');

        opcion.style.display = 'none';
        formUser.style.display = 'none';
        formAdmin.style.display = 'inline-block';
    }
</script>
%{--{{/inline}}--}%

%{--{{/layouts/auth}}--}%