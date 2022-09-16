<!-- BEGIN Left Aside -->

<%@ page import="espacio.UtilService" %>
    <ul id="js-nav-menu" class="nav-menu">
        <li>
            <a href="${createLink(uri: '/')}" title="Principal" data-filter-tags="principal">
                <i class="fal fa-home"></i>
                <span class="nav-link-text" data-i18n="nav.ui_components">Dashboard</span>
            </a>
        </li>
%{--        <g:set var="userObject" value="${User.findByUsername(sec.loggedInUserInfo(field:'username'))}"/>--}%
        <%
            UtilService utilService = new UtilService()
        %>
        <li>
            <a href="${createLink(controller: 'reserva', action: 'solicitudReservaAdmin')}" title="Solicitudes" data-filter-tags="solicitudes">
                <i class="fal fa-bell"></i>
                <span class="nav-link-text" data-i18n="nav.ui_components">Solicitudes</span>
                <span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">${utilService.cantSolicitudes()}</span>
            </a>
        </li>
        <li>
            <a href="#" title="Reservas" data-filter-tags="font icons">
                <i class="fal fa-bookmark"></i>
                <span class="nav-link-text" data-i18n="nav.font_icons">Reservas</span>
                %{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
            </a>
            <ul>
                <li>
                    <a href="${createLink(controller: 'reserva', action: 'reservasVigentesAdmin')}" title="Reservas Vigentes" data-filter-tags="font icons fontawesome">
                        <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Vigentes</span>
                    </a>
                </li>
                <li>
                    <a href="${createLink(controller: 'reserva', action: 'reservasHistoricasAdmin')}" title="Reservas Históricas" data-filter-tags="font icons nextgen icons">
                        <span class="nav-link-text" data-i18n="nav.font_icons_nextgen_icons">Históricas</span>
                    </a>
                </li>
            </ul>
        </li>
        <li>
        <a href="#" title="Espacios" data-filter-tags="font icons">
            <i class="fal fa-building"></i>
            <span class="nav-link-text" data-i18n="nav.font_icons">Espacios</span>
            %{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
        </a>
        <ul>
            <li>
                <a href="${createLink(controller: 'espacio', action: 'create')}" title="Crear Espacio" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Crear</span>
                </a>
            </li>
            <li>
                <a href="${createLink(controller: 'espacio', action: 'index')}" title="Listar Espacios" data-filter-tags="font icons nextgen icons">
                    <span class="nav-link-text" data-i18n="nav.font_icons_nextgen_icons">Listar</span>
                </a>
            </li>
        </ul>
        </li>

%{--        <li>--}%
%{--            <a href="#" title="Destácate" data-filter-tags="font icons">--}%
%{--                <i class="fal fa-tags"></i>--}%
%{--                <span class="nav-link-text" data-i18n="nav.font_icons">Destácate</span>--}%
%{--                --}%%{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
%{--            </a>--}%
%{--            <ul>--}%
%{--                <li>--}%
%{--                    <a href="${createLink(controller: 'promoEntidad', action: 'create')}" title="Crear Anuncio" data-filter-tags="font icons fontawesome">--}%
%{--                        <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Crear</span>--}%
%{--                    </a>--}%
%{--                </li>--}%
%{--                <li>--}%
%{--                    <a href="${createLink(controller: 'promoEntidad', action: 'index')}" title="Listar Anuncios" data-filter-tags="font icons nextgen icons">--}%
%{--                        <span class="nav-link-text" data-i18n="nav.font_icons_nextgen_icons">Listar</span>--}%
%{--                    </a>--}%
%{--                </li>--}%
%{--            </ul>--}%
%{--        </li>--}%

        <li>
            <a href="${createLink(controller: 'home', action: 'dashboardKpi')}" title="KPI" data-filter-tags="principal">
                <i class="fal fa-chart-area"></i>
                <span class="nav-link-text" data-i18n="nav.ui_components">KPI</span>
%{--                <span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">Premium</span>--}%
            </a>
        </li>
        <li>
            <a href="${createLink(controller: 'home', action: 'contactoSoporte')}" title="Ayuda y Soporte Técnico" data-filter-tags="principal">
                <i class="fal fa-life-ring"></i>
                <span class="nav-link-text" data-i18n="nav.ui_components">Ayuda</span>
            </a>
        </li>
    </ul>
%{--</aside>--}%
<!-- END Left Aside -->
