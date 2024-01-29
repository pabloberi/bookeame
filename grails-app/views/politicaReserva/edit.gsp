<%@ page import="gestion.General; espacio.TipoEspacio" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
    <title><g:message code="default.show.label" args="[entityName]" /></title>
</head>
<body>
<div id="create-politica" class="content scaffold-show" role="main">
    <g:form controller="politicaReserva" action="actualizar" method="POST" id="${politicaReserva?.id}">
        <g:render template="form"/>
    </g:form>

</div>

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

    $('.select2').select2();

</script>
</body>
</html>
