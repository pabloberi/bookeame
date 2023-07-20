<%@ page import="auth.User" %>
<!-- BEGIN Left Aside -->
<aside class="page-sidebar">
    <div class="page-logo">
        <a href="#" class="page-logo-link press-scale-down d-flex align-items-center position-relative" data-toggle="modal" data-target="#modal-shortcut">
            %{--<img src="img/logo.png" alt="SmartAdmin WebApp" aria-roledescription="logo">--}%
            <asset:image src="/bookeame/full-blanco.png" alt="" style="width: 160px; height: 53px; margin-right: 2em;"/>
%{--            <span class="page-logo-text mr-1">Agenda En Línea</span>--}%
            <span class="position-absolute text-white opacity-50 small pos-top pos-right mr-2 mt-n2"></span>
            <i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>
        </a>
    </div>

    <!-- BEGIN PRIMARY NAVIGATION -->
    <nav id="js-primary-nav" class="primary-nav" role="navigation">
        <!-- _nav-filter -->
        <div class="nav-filter">
            <div class="position-relative">
                <input type="text" id="nav_filter_input" placeholder="Filter menu" class="form-control" tabindex="0">
                <a href="#" onclick="return false;" class="btn-primary btn-search-close js-waves-off" data-action="toggle" data-class="list-filter-active" data-target=".page-sidebar">
                    <i class="fal fa-chevron-up"></i>
                </a>
            </div>
        </div>
        <div class="info-card">
%{--            <asset:image src="demo/avatars/avatar-b.png" class="profile-image rounded-circle" alt="user"/>--}%
%{--            <asset:image src="/../../../src/main/webapp/assets/img/fotosPerfilUser/${user?.id}/${user?.foto}" class="profile-image rounded-circle" alt="user"/>--}%
            <g:if test="${user?.foto}">
                <g:if test="${user?.provider == 'google'}">
                    <img src="${raw(user?.foto)}" class="profile-image rounded-circle" style="width: 60px; height: 60px" alt="user"/>
                </g:if>
                <g:else>
                    <asset:image src="/imagenes/users/${user?.id}/${user?.foto}" class="profile-image rounded-circle" style="width: 60px; height: 60px" alt="user"/>
                </g:else>
            </g:if>
            <g:else>
                <asset:image src="/imagenes/imagenNula.png" class="profile-image rounded-circle" style="width: 60px; height: 60px" alt="user"/>
            </g:else>

            <div class="info-card-text">
                <a href="#" class="d-flex align-items-center text-white">
                    <span class="text-truncate text-truncate-sm d-inline-block">
                        ${user?.nombre ?: user?.email }
%{--                        ${sec.loggedInUserInfo(field: 'id')}--}%
                    </span>
                </a>
                %{--<span class="d-inline-block text-truncate text-truncate-sm">Toronto, Canada</span>--}%
            </div>
            %{--<img src="img/card-backgrounds/cover-2-lg.png" class="cover" alt="cover">--}%
            <asset:image src="card-backgrounds/cover-6-lg.png" class="cover" alt="cover"/>

            <a href="#" onclick="return false;" class="pull-trigger-btn" data-action="toggle" data-class="list-filter-active" data-target=".page-sidebar" data-focus="nav_filter_input">
                <i class="fal fa-angle-down"></i>
            </a>
        </div>
        <g:render template="/layouts/left-panel-menu" model="[user: user]"/>
            %{--{{> include/_nav-filter-msg }}--}%
        <div class="filter-message js-filter-message bg-success-600"></div>
    </nav>
    <!-- END PRIMARY NAVIGATION -->

    <!-- NAV FOOTER -->
    %{--{{> include/_nav-footer }}--}%
%{--    <g:render template="/layouts/nav-footer"/>--}%
    <!-- END NAV FOOTER -->
</aside>
<!-- END Left Aside -->
