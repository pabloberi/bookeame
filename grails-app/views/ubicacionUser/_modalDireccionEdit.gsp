<div id="ubicacionUser${ubicacionUser?.id}" class="modal fade" role="dialog" >
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <g:form method="POST" controller="ubicacionUser" action="editarDireccion" id="${ubicacionUser?.id}">
                <div class="modal-body">
                    <h4>Editar  <span class="fw-300"><i>Dirección</i></span></h4><br>
                    <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                        <label class="form-label">Región</label>
                        <div class="input-group">
                            <g:select name="region" id="region${ubicacionUser?.id}" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${ubicacion.Region.list()}" onchange="cargarComuna(this.value,${ubicacionUser?.id})" value="${ubicacionUser.region?.id}"/>
                        </div>
                    </div>
                    <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                        <label class="form-label">Comuna</label>
                        <div class="input-group">
                            <select name="comuna" id="comuna${ubicacionUser?.id}" class="custom-select select-2" required></select>
                        </div>
                    </div>
                    <div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
                        <label class="form-label">Dirección</label>
                        <input type="text" class="form-control" required name="direccion" id="direccion${ubicacionUser?.id}" value="${ubicacionUser?.direccion}" >
                    </div>

                    <div class="modal-footer">
                        <div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
                            <button href="#" type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>
                        </div>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        cargarComuna(${ubicacionUser.region?.id},${ubicacionUser?.id})
    });



</script>
