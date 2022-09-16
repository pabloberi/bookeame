%{--<%@ page import="canchitas.Configuraciones" %>--}%
<div class="dropdown-header bg-trans-gradient d-flex flex-row py-4 rounded-top">
    <div class="d-flex flex-row align-items-center mt-1 mb-1 color-white">
        <span class="mr-2">
            <asset:image src="demo/avatars/avatar-b.png" class="profile-image rounded-circle"/>
%{--            <g:set var="userObject" value="${autenticacion.User.findByUsername(sec.loggedInUserInfo(field:'username'))}"/>--}%
%{--            <img id="userEspacio${userObject?.id}" src="${createLink(controller: 'user', action: 'visorImagen', id: userObject?.id)}" class="profile-image rounded-circle" style="    width: 2rem; height: 2rem;"/>--}%
%{--            <g:if test="${userObject?.foto}">--}%
%{--                <g:img uri="${Configuraciones.findByNombre("serverBaseUrl")?.valor + userObject?.foto}" class="profile-image rounded-circle img-responsive" style="width: 2rem; height: 2rem;"/>--}%
%{--            </g:if>--}%
%{--            <g:else>--}%
%{--                <g:img uri="${Configuraciones.findByNombre("serverBaseUrl")?.valor + Configuraciones.findByNombre("imagenNula")?.valor}" class="profile-image rounded-circle img-responsive" style="width: 2rem; height: 2rem;"/>--}%
%{--            </g:else>--}%
         </span>
        <div class="info-card-text">
            <div class="fs-lg text-truncate text-truncate-lg">${userObject?.nombre}</div>
            <span class="text-truncate text-truncate-md opacity-80">${userObject?.username}</span>
        </div>
    </div>
</div>
<div class="dropdown-divider m-0"></div>

%{--<a href="#" class="dropdown-item" data-action="app-reset">--}%
    %{--<span data-i18n="drpdwn.reset_layout">Reset Layout</span>--}%
%{--</a>--}%
<a href="#" class="dropdown-item" data-toggle="modal" data-target=".js-modal-settings">
    <span data-i18n="drpdwn.settings">Settings</span>
</a>
<div class="dropdown-divider m-0"></div>

<a href="#" class="dropdown-item" data-action="app-fullscreen">
    <span data-i18n="drpdwn.fullscreen">Fullscreen</span>
    <i class="float-right text-muted fw-n">F11</i>
</a>
%{--<a href="#" class="dropdown-item" data-action="app-print">--}%
    %{--<span data-i18n="drpdwn.print">Print</span>--}%
    %{--<i class="float-right text-muted fw-n">Ctrl + P</i>--}%
%{--</a>--}%
%{--<div class="dropdown-multilevel dropdown-multilevel-left">--}%
    %{--<div class="dropdown-item">--}%
        %{--Language--}%
    %{--</div>--}%
    %{--<div class="dropdown-menu">--}%
        %{--<a href="#?lang=fr" class="dropdown-item" data-action="lang" data-lang="fr">Français</a>--}%
        %{--<a href="#?lang=en" class="dropdown-item active" data-action="lang" data-lang="en">English (US)</a>--}%
        %{--<a href="#?lang=es" class="dropdown-item" data-action="lang" data-lang="es">Español</a>--}%
        %{--<a href="#?lang=ru" class="dropdown-item" data-action="lang" data-lang="ru">Русский язык</a>--}%
        %{--<a href="#?lang=jp" class="dropdown-item" data-action="lang" data-lang="jp">日本語</a>--}%
        %{--<a href="#?lang=ch" class="dropdown-item" data-action="lang" data-lang="ch">中文</a>--}%
    %{--</div>--}%
%{--</div>--}%
<div class="dropdown-divider m-0"></div>
<a class="dropdown-item fw-500 pt-3 pb-3" href="${createLink(controller: 'logout', action: 'index')}">
    <span data-i18n="drpdwn.page-logout">Logout</span>
    <span class="float-right fw-n">&commat;{{twitter}}</span>
</a>
