<%@ page import="gestion.General; ubicación.UbicacionUser; auth.User" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <g:applyLayout name="dashboard_header"/>
</head>
<body class="mod-bg-1">
<bs:usuario/>
%{--<g:set var="usuario" value="${session["usuario"] as User}"/>--}%
<g:set var="usuario" value="${session["usuario"] as User}"/>


<!-- save-settings-script -->
<g:applyLayout name="_script-loading-saving"/>
<asset:javascript src="jquery-3.4.1.min.js"/>

<asset:stylesheet src="/notifications/toastr/toastr.css"/>
<asset:javascript src="/notifications/toastr/toastr.js"/>

<asset:stylesheet src="formplugins/bootstrap-datepicker/bootstrap-datepicker.css"/>
<asset:javascript src="formplugins/bootstrap-datepicker/bootstrap-datepicker.js"/>

<asset:stylesheet src="formplugins/datetime/css/bootstrap-datetimepicker.min.css"/>
<asset:javascript src="formplugins/datetime/js/bootstrap-datetimepicker.min.js"/>

<asset:stylesheet src="formplugins/timepicker/css/bootstrap-timepicker.css"/>
<asset:javascript src="formplugins/timepicker/js/bootstrap-timepicker.js"/>

<asset:stylesheet src="formplugins/bootstrap-colorpicker/bootstrap-colorpicker.css"/>
<asset:javascript src="formplugins/bootstrap-colorpicker/bootstrap-colorpicker.js"/>

<!-- BEGIN Page Wrapper -->
<div class="page-wrapper">

    <div class="page-inner">
        <g:set var="user" value="${User.findById(sec.loggedInUserInfo(field:'id'))}"/>

        <g:applyLayout name="_left-panel" model="[user: user]"/>

        <div class="page-content-wrapper">

            %{--{{> include/_page-header }}--}%
            <g:render template="/layouts/page-header" model="[user: user]"/>
            <!-- BEGIN Page Content -->
            <!-- the #js-page-content id is needed for some plugins to initialize -->
            <main id="js-page-content" role="main" class="page-content">
                <g:layoutBody/>
            </main>
            <!-- this overlay is activated only when mobile menu is triggered -->
            <div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>            <!-- END Page Content -->

            <g:render template="/layouts/page-footer" />

            <g:render template="/layouts/color-profile-reference" />

        </div>
    </div>

</div>
<!-- END Page Wrapper -->
<asset:javascript src="vendors.bundle.js"/>
<asset:javascript src="app.bundle.js"/>

<asset:javascript src="statistics/peity/peity.bundle.js"/>
<asset:javascript src="statistics/flot/flot.bundle.js"/>
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>


%{--<script type="text/javascript">--}%
%{--    $(window).load(function() {--}%
%{--        $(".loader").fadeOut("slow");--}%
%{--    });--}%
%{--</script>--}%
</body>

</html>