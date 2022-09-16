<!doctype html>
<html>
    <head>
        <title>Inicio</title>
        <meta name="layout" content="dashboard" />
        <g:if env="development"><asset:stylesheet src="errors.css"/></g:if>
    </head>
    <body>
        <div class="h-alt-hf d-flex flex-column align-items-center justify-content-center text-center">
            <h1 class="color-fusion-300">
                HOLA! <span class="text-gradient">${user?.nombre?.toUpperCase() ?: user?.username?.toUpperCase() }</span>
                <small class="fw-500">
                    Bienvenid@
                </small>
            </h1>
            <h3 class="fw-500 mb-5">

                <a href="${createLink( controller: 'home', action: 'dashboard')}" class="btn btn-outline-info">Comenzar</a>
            </h3>
        </div>
    </body>
</html>
