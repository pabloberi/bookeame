<!-- BEGIN Page Header -->
<header class="page-header" role="banner">

    <!-- we need this logo when user switches to nav-function-top -->
    <asset:image src="logo.png"/>

    %{--{{#if appLayoutShortcut}}--}%
    %{--<!-- DOC: nav menu layout change shortcut -->--}%
    %{--<div class="hidden-md-down dropdown-icon-menu position-relative">--}%
        %{--<a href="#" class="header-btn btn js-waves-off" data-action="toggle" data-class="nav-function-hidden" title="Hide Navigation">--}%
            %{--<i class="ni ni-menu"></i>--}%
        %{--</a>--}%
        %{--<ul>--}%
            %{--<li>--}%
                %{--<a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-minify" title="Minify Navigation">--}%
                    %{--<i class="ni ni-minify-nav"></i>--}%
                %{--</a>--}%
            %{--</li>--}%
            %{--<li>--}%
                %{--<a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-fixed" title="Lock Navigation">--}%
                    %{--<i class="ni ni-lock-nav"></i>--}%
                %{--</a>--}%
            %{--</li>--}%
        %{--</ul>--}%
    %{--</div>--}%
    %{--{{/if}}--}%

    <!-- DOC: mobile button appears during mobile width -->
    <div class="hidden-lg-up">
        <a href="#" class="header-btn btn press-scale-down" data-action="toggle" data-class="mobile-nav-on">
            <i class="ni ni-menu"></i>
        </a>
    </div>

    <div class="search">
        <form class="app-forms hidden-xs-down" role="search" action="page_search.html" autocomplete="off">
            %{--{{!-- <i class="fal fa-search position-absolute fs-xl m-2 p-1 text-muted pos-left"></i> --}}--}%
            <input type="text" id="search-field" placeholder="Search for anything" class="form-control" tabindex="1">
            <a href="#" onclick="return false;" class="btn-danger btn-search-close js-waves-off d-none" data-action="toggle" data-class="mobile-search-on">
                <i class="fal fa-times"></i>
            </a>
        </form>
    </div>

    <div class="ml-auto d-flex">

        <!-- activate app search icon (mobile) -->
        <div class="hidden-sm-up">
            <a href="#" class="header-icon" data-action="toggle" data-class="mobile-search-on" data-focus="search-field" title="Buscar">
                <i class="fal fa-search"></i>
            </a>
        </div>

        %{--{{#if layoutSettings}}--}%
        %{--<!-- app settings -->--}%
        %{--<div class="hidden-md-down">--}%
            %{--<a href="#" class="header-icon" data-toggle="modal" data-target=".js-modal-settings">--}%
                %{--<i class="fal fa-cog"></i>--}%
            %{--</a>--}%
        %{--</div>--}%
        %{--{{/if}}--}%

        <!-- app shortcuts -->
        <div>
            <a href="#" class="header-icon" data-toggle="dropdown" title="My Apps">
                <i class="fal fa-cube"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-animated w-auto h-auto">
                %{--{{> include/_dropdown-app}}--}%
            </div>
        </div>

        %{--{{#if chatInterface}}--}%
        %{--<!-- app message -->--}%
        %{--<a href="#" class="header-icon" data-toggle="modal" data-target=".js-modal-messenger">--}%
            %{--<i class="fal fa-globe"></i>--}%
            %{--<span class="badge badge-icon">!</span>--}%
        %{--</a>--}%
        %{--{{/if}}--}%

        <!-- app notification -->
        <div>
            <a href="#" class="header-icon" data-toggle="dropdown" title="You got 11 notifications">
                <i class="fal fa-bell"></i>
                <span class="badge badge-icon">11</span>
            </a>
            <div class="dropdown-menu dropdown-menu-animated dropdown-xl">
                {{> include/_dropdown-notification}}
            </div>
        </div>
        <!-- app user menu -->
        <div>
            <a href="#" data-toggle="dropdown" title="email" class="header-icon d-flex align-items-center justify-content-center ml-2">
                <asset:image src="/imagenes/users/${user?.id}/${user?.foto}" class="profile-image rounded-circle"/>
            </a>
            <div class="dropdown-menu dropdown-menu-animated dropdown-lg">
                <g:render template="/layouts/dropdown-menu"/>
            </div>
        </div>

    </div>

</header>
<!-- END Page Header -->