<%@ page import="configuracionEmpresa.ConfiguracionEmpresa" %>
<!doctype html>
<html>
<head>
    <title>KPI</title>
    <meta name="layout" content="dashboard" />
</head>
    <body>
    <asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

        <div class="loader"></div>
            <div class="row">
                <g:render template="/kpi/ingresoMensual"/>
            </div>
            <div class="row">
                <g:render template="/kpi/flujoPersonas" />
            </div>
            <div class="row">
                <g:render template="/kpi/recaudacion" model="[espacioList: espacioList]"/>
            </div>
            <g:if test="${configuracion?.tipoPago?.prepago}">
                <div class="row">
                    <g:render template="/kpi/comisionFlow" />
                </div>
            </g:if>
    
        <script type="text/javascript">
            $(window).on('load',function() {
                $('.loader').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>')
                // $(".loader").fadeOut("slow");
            });
        </script>
    <asset:javascript src="/formplugins/select2/select2.bundle.js"/>
%{--    <asset:javascript src="datagrid/datatables/datatables.bundle.js"/>--}%

    </body>
</html>
