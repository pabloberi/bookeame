<div class="panel-container show">
    <div class="panel-content">

        <g:form method="POST" controller="user" action="subirImagenPerfil" params="[controlador: 'configuracionEmpresa', metodo: 'configuracionEmpresa']" enctype="multipart/form-data" >
            <div class="form-group row">
                <div class="col-sm-12 col-md-10 col-lg-10">
                    <label class="form-label" for="fotoPerfil">Foto Perfil</label>
                    <div class="input-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text"></span>
                        </div>
                        <g:field type="file" class="form-control filename" name="fotoPerfil" id="fotoPerfil" accept=".jpg, .jpeg, .png" onblur="checkSize()"/>
                        %{--                        <label class="custom-file-label" for="fotoPerfil" id="nombreFoto" >Elegir Foto</label>--}%
                    </div>
                </div>
                <div class="col-sm-12 col-md-2 col-lg-2" style="margin-top: 2em;" >
                    <div class="btn-group btn-group-sm">
                        <button type="submit" class="btn btn-info btn-sm" title="Guardar">Subir</button>
                    </div>
                </div>
            </div>
            <br><br>
        </g:form>

        <g:form method="POST" controller="configuracionEmpresa" action="guardarTelefono" >
            <div class="form-group row">
                <div class="col-sm-12 col-md-10 col-lg-10">
                    <label class="form-label" for="fotoPerfil">Teléfono Contacto para Clientes</label>
                    <g:field type="text" class="form-control" name="fono" id="fono" placeholder="Teléfono de contacto para tus clientes" value="${configuracionEmpresa?.fono}"/>
                </div>
                <div class="col-sm-12 col-md-2 col-lg-2" style="margin-top: 2em;" >
                    <div class="btn-group btn-group-sm">
                        <button type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>
                    </div>
                </div>
            </div>
        </g:form>

        <br><br>
    </div>
</div>
