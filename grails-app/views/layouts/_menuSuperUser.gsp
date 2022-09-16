<ul id="js-nav-menu" class="nav-menu">
    <li>
        <a href="${createLink(uri: '/')}" title="Principal" data-filter-tags="principal">
            <i class="fal fa-home"></i>
            <span class="nav-link-text" data-i18n="nav.ui_components">Principal</span>
        </a>
    </li>

    <li>
        <a href="#" title="Reservas" data-filter-tags="font icons">
            <i class="fal fa-bookmark"></i>
            <span class="nav-link-text" data-i18n="nav.font_icons">Empresas</span>
            %{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
        </a>
        <ul>
            <li>
                <a href="${createLink(controller: 'empresa', action: 'solicitudEmpresa')}" title="Reservas Vigentes" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Solicitudes</span>
                </a>
            </li>
            <li>
                <a href="${createLink(controller: 'empresa', action: 'modificacionEmpresa')}" title="Reservas Vigentes" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Modificaciones</span>
                </a>
            </li>
        </ul>

    </li>
    <li>
        <a href="#" title="Reservas" data-filter-tags="font icons">
            <i class="fal fa-ban"></i>
            <span class="nav-link-text" data-i18n="nav.font_icons">Banneador</span>
            %{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
        </a>
        <ul>
            <li>
                <a href="${createLink(controller: 'empresa', action: 'index')}" title="Reservas Vigentes" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Empresas</span>
                </a>
            </li>
            <li>
                <a href="${createLink(controller: 'user', action: 'index')}" title="Reservas Vigentes" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Usuarios</span>
                </a>
            </li>
        </ul>

    </li>

    <li>
        <a href="#" title="Reservas" data-filter-tags="font icons">
            <i class="fal fa-usd-circle"></i>
            <span class="nav-link-text" data-i18n="nav.font_icons">Módulo Comercial</span>
            %{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
        </a>
        <ul>
            <li>
                <a href="${createLink(controller: 'cuentaMensual', action: 'create')}" title="Generar Cuentas" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Generar Cuentas</span>
                </a>
            </li>
            <li>
                <a href="${createLink(controller: 'cuentaMensual', action: 'index')}" title="Lista Cuentas" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Buscar</span>
                </a>
            </li>
            <li>
                <a href="${createLink(controller: 'cuentaMensual', action: 'atrasados')}" title="Cuentas atrasadas" data-filter-tags="font icons fontawesome">
                    <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Atrasos</span>
                </a>
            </li>
        </ul>

    </li>
%{--    <li>--}%
%{--        <a href="${createLink(uri: '/')}" title="Ayuda y Soporte Técnico" data-filter-tags="principal">--}%
%{--            <i class="fal fa-life-ring"></i>--}%
%{--            <span class="nav-link-text" data-i18n="nav.ui_components">Ayuda</span>--}%
%{--        </a>--}%
%{--    </li>--}%
</ul>

