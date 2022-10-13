<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'ubicacionUser.label', default: 'UbicacionUser')}" />
    <title><g:message code="default.list.label" args="[entityName]" /></title>
</head>
<body>
%{--    <g:render template="/layouts/botonera" params="[controlador: 'Espacio', metodo: 'Lista']" />--}%
<div >
    <div class="col-md-4">
        <div style="margin: 5%;">
            <button onclick="nuevaDireccion()" class="btn btn-primary btn-md" title="Ingresar Nueva dirección">Nuevo</button>
        </div>
    </div>
    <br>
    <div id="formularioNuevo"></div>
</div>
<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Lista <span class="fw-300"><i>Direcciones</i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content">
            <div class="tab-pane" id="tab-events" role="tabpanel">
                <div class="d-flex flex-column h-100">
                    <div class="h-auto">
                        <table id="dt-basic-example" class="table table-sm m-0 w-100 h-100 border-0 table-striped table-bordered table-hover dataTable no-footer">
                            <thead class="bg-primary-500">
                            <tr>
                                <th>Habilitar</th>
                                <th>Acción</th>
                                <th>Región</th>
                                <th>comuna</th>
                                <th>Dirección</th>
                            </tr>
                            </thead>
                            <tbody>
                            <g:each in="${ubicacionUserList}" status="i" var="ubicacionUser" >
                                <tr>
                                    <td >
                                        <div id="ckeck" class="custom-control custom-switch">
                                            <input type="checkbox" class="custom-control-input" id="test${i}"<g:if test ="${ubicacionUser?.enUso==true}">checked</g:if> onclick="habilitar(${ubicacionUser?.id})" >
                                            <label class="custom-control-label" for="test${i}" title="Habilitar o Deshabilitar dirección"></label>
                                        </div>
                                    </td>
                                    <td>
                                        <div>
                                            <button id="botoneditar" class="btn btn-info btn-xs btn-icon" title="Editar" data-toggle="modal" data-target="#ubicacionUser${ubicacionUser?.id}">
                                                <i class="fal fa-pencil"></i>
                                            </button>
                                                <a href="${createLink(controller: 'ubicacionUser', action: 'eliminarUbicacion', id: ubicacionUser?.id)}"  title="Eliminar"> <button id="botoneliminar" class="btn btn-danger btn-xs btn-icon"><i class="fal fa-trash"></i></button></a>
                                        </div>
                                    </td>
                                    <td>${ubicacionUser.region?.region}</td>
                                    <td>${ubicacionUser.comuna?.comuna}</td>
                                    <td>${ubicacionUser?.direccion}</td>
                                </tr>
                                <scripts>

                                </scripts>
                                 <g:render template="modalDireccionEdit" model="[ubicacionUser : ubicacionUser]"/>
                            </g:each>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


%{--<g:each in="${ubicacionUserList}" status="i" var="ubicacionUser" >--}%
    %{--<script>--}%
        %{--$('#region${ubicacionUser?.id}','#comuna${ubicacionUser?.id}').select2({--}%
            %{--dropdownParent:$('#ubicacionUser${ubicacionUser?.id}')--}%
        %{--});--}%

    %{--</script>--}%
%{--</g:each>--}%

%{--<asset:javascript src="vendors.bundle.js"/>--}%
%{--<asset:javascript src="app.bundle.js"/>--}%
<asset:javascript src="datagrid/datatables/datatables.bundle.js"/>

<script>
    function nuevaDireccion() {
        $('#formularioNuevo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></br>Cargando</center>')
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'ubicacionUser', action: 'insertarForm')}',
                success: function (data, textStatus) {
                    $('#formularioNuevo').html(data);
                    sleep(1000);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
    }

    function sleep(milisegundos) {
        var comienzo = new Date().getTime();
        while (true) {
            if ((new Date().getTime() - comienzo) > milisegundos)
                break;
        }
    }

    <g:if test="${flash.message}">
    $(document).ready( function () {
        toastr.success("${flash.message}");
    });
    </g:if>
    <g:if test="${flash.error}">
    $(document).ready( function () {
        toastr.warning("${flash.error}");
    });
    </g:if>

    function cargarComuna(regionId,ubicacionID){
        if(ubicacionID){
            var userID = '#comuna' + ubicacionID
        }else{
            var userID = '#comuna'
        }
        $.ajax({
            type:'POST',
            url:'${g.createLink(controller: 'ubicacionUser', action: 'cargarComuna')}',
            data:{regionId:regionId,ubicacionId:ubicacionID},
            success:function(data,textStatus){$(userID).html(data)},error:function(XMLHttpRequest,textStatus,errorThrown){}});
    }

    function habilitar(idDireccion){
        $.ajax({
            type: 'POST',
            url:'${g.createLink(controller: 'ubicacionUser', action: 'habilitarDireccion' )}',
            data:{id: idDireccion},
            success: function (data, textStatus){location.reload()},
            error:function(XMLHttpRequest,textStatus,errorThrown){}});
    }

    $(document).ready( function () {
        $('#dt-basic-example').dataTable({
            language: {
                "sProcessing":     "Procesando...",
                "sLengthMenu":     "Mostrar _MENU_ registros",
                "sZeroRecords":    "No se encontraron resultados",
                "sEmptyTable":     "Ningún dato disponible en esta tabla =(",
                "sInfo":           "Mostrando del _START_ al _END_ de _TOTAL_ registros",
                "sInfoEmpty":      "Sin Registros",
                "sInfoFiltered":   "(filtrado de un total de _MAX_ registros)",
                "sInfoPostFix":    "",
                // "sSearch":         "Buscar:",
                "sUrl":            "",
                "sInfoThousands":  ",",
                "sLoadingRecords": "Cargando...",
                "oPaginate": {
                    "sFirst":    "Primero",
                    "sLast":     "Último",
                    "sNext":     "Siguiente",
                    "sPrevious": "Anterior"
                },
                "oAria": {
                    "sSortAscending":  ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                },
                "buttons": {
                    "copy": "Copiar",
                    "colvis": "Visibilidad"
                }
            },
            responsive: true,
            autoFill: {
                focus: 'hover'
            }
        });

/*        var checkbox = document.getElementById('test');
        checkbox.addEventListener( 'change', function() {
            if (this.checked) {
                toastr.warning("checked");
            }
        });*/
    });
</script>
</body>
</html>
