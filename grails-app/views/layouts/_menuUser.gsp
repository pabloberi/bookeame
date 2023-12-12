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
                <span class="nav-link-text" data-i18n="nav.font_icons">Reservas</span>
                %{--<span class="dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top">2,500+</span>--}%
            </a>
            <ul>
                <li>
                    <a href="${createLink(controller: 'reserva', action: 'reservasVigentesUser')}" title="Reservas Vigentes" data-filter-tags="font icons fontawesome">
                        <span class="nav-link-text" data-i18n="nav.font_icons_fontawesome">Vigentes</span>
                    </a>
                </li>
                <li>
                    <a href="${createLink(controller: 'reserva', action: 'reservasHistoricasUser')}" title="Reservas Históricas" data-filter-tags="font icons nextgen icons">
                        <span class="nav-link-text" data-i18n="nav.font_icons_nextgen_icons">Históricas</span>
                    </a>
                </li>
            </ul>

        </li>
%{--        <li>--}%
%{--            <a href="${createLink(controller: 'alarma', action: 'index')}" title="Font Icons" data-filter-tags="font icons">--}%
%{--                <i class="fal fa-alarm-clock"></i>--}%
%{--                <span class="nav-link-text" data-i18n="nav.font_icons">Alarmas</span>--}%
%{--            </a>--}%
%{--        </li>--}%
%{--        <li>--}%
%{--            <a href="#" title="Font Icons" data-filter-tags="font icons">--}%
%{--                <i class="fal fa-handshake"></i>--}%
%{--                <span class="nav-link-text" data-i18n="nav.font_icons">Asociados</span>--}%
%{--            </a>--}%
%{--        </li>--}%
        <li>
            <a href="${createLink(controller: 'home', action: 'contactoSoporte')}" title="Ayuda y Soporte Técnico" data-filter-tags="principal">
                <i class="fal fa-life-ring"></i>
                <span class="nav-link-text" data-i18n="nav.ui_components">Ayuda</span>
            </a>
        </li>
    </ul>

