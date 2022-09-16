<sec:ifAnyGranted roles="ROLE_SUPERUSER">
    <g:render template="/layouts/menuSuperUser" />
</sec:ifAnyGranted>

<sec:ifAnyGranted roles="ROLE_ADMIN">
    <g:render template="/layouts/menuAdmin" model="[user: user]"/>
</sec:ifAnyGranted>

%{--<sec:ifAnyGranted roles="ROLE_STAFF">--}%
%{--    <g:render template="/layouts/menuStaff" model="[userObject: userObject]"/>--}%
%{--</sec:ifAnyGranted>--}%

<sec:ifAnyGranted roles="ROLE_USER">
    <g:render template="/layouts/menuUser" />
</sec:ifAnyGranted>