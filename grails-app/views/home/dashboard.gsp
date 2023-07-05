<%@ page import="gestion.General" %>
<!DOCTYPE html>
<g:applyLayout name="dashboard">
    <sec:ifAnyGranted roles="ROLE_ADMIN">
        <g:render template="homeAdmin" model="[espacioList: espacioList]"/>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER">
            <g:render template="homeUser" />
    </sec:ifAnyGranted>
</g:applyLayout>
