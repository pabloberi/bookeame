<div id="imagenActualEspacio" class="modal fade" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Imagen Vigente</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <g:if test="${espacio?.foto}">
                    <asset:image src="/imagenes/espacios/${espacio?.id}/${espacio?.foto}" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                </g:if>
                <g:else>
                    <asset:image src="/imagenes/imagenNula.png" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                </g:else>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">Ok</button>
            </div>
        </div>

    </div>
</div>