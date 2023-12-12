<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'reserva.label', default: 'Servicio')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body>
<div id="show-reserva" class="content scaffold-show" role="main">
    <div id="panel-7" class="panel">
        <div class="panel-hdr">
            <h2>
                Crear <span class="fw-300"><i>Feriado</i></span>
            </h2>
            <div class="panel-toolbar">
                <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
                <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
                <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
            </div>
        </div>
        <g:form method="POST" controller="feriado" action="save">
            <g:render template="form" />
        </g:form>
    </div>
</div>
</body>
</html>
