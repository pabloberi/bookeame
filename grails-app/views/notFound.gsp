<!doctype html>
<html>
<head>
    <title><g:if env="development">Grails Runtime Exception</g:if><g:else>Error</g:else></title>
    <meta name="layout" content="dashboard" />
    <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
</head>
<body>
<div class="h-alt-hf d-flex flex-column align-items-center justify-content-center text-center">
    <h1 class="page-error color-fusion-500">
        Not <span class="text-gradient">Found</span>
        <small class="fw-500">
            Ups! algo salió <u>mal</u>
        </small>
    </h1>
    <h3 class="fw-500 mb-5">

        La dirección URL no existe o la consulta realizada no está asociada a su usuario.
    </h3>
%{--    <h4>--}%
%{--        Nuestro equipo está trabajando duro para poder resolverlo y ofrecerte una mejor experiencia. Espera unos momentos e intenta nuevamente.--}%
%{--        <br>Si el error persiste, contactanos! <a href="#"><u>Reportar un bug.</u></a>--}%
%{--    </h4>--}%
</div>
</body>
</html>
