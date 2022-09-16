<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>
</head>
<body>

    <g:if test="${flash.message}">
        <div class="message" role="status">${flash.message}</div>
    </g:if>
    <g:hasErrors bean="${this.espacio}">
        <ul class="errors" role="alert">
            <g:eachError bean="${this.espacio}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>
            </g:eachError>
        </ul>
    </g:hasErrors>
    <g:form resource="${this.espacio}" method="POST" enctype="multipart/form-data">
        <g:render template="form"/>
    </g:form>

</body>
</html>
