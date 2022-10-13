<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.label', default: 'UbicacionUser')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>
</head>
<body>

<g:hasErrors bean="${this.ubicacionUser}">
    <ul class="errors" role="alert">
        <g:eachError bean="${this.ubicacionUser}" var="error">
            <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
        </g:eachError>
    </ul>
</g:hasErrors>
    <g:form method="POST" controller="ubicacionUser" action="guardarUbicacionUser">
        <g:render template="form"/>
    </g:form>

</body>
</html>
