
<br>
<g:hiddenField name="userId" value="${userSelect?.id}"/>

<div class="form-group">
    <label class="form-label" for="nombre">Nombre Usuario</label>
    <div class="input-group has-length">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fal fa-user-circle"></i></span>
        </div>
        <input type="text" id="nombre" class="form-control" placeholder="Nombre" aria-label="Nombre" aria-describedby="Nombre"
               value="${userSelect?.nombre} ${userSelect?.apellidoPaterno}" disabled="">
    </div>
</div>

<div class="form-group">
    <label class="form-label" for="correo">Correo Usuario</label>
    <div class="input-group has-length">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fal fa-at"></i></span>
        </div>
        <input type="text" id="correo" class="form-control" placeholder="correo" aria-label="correo" aria-describedby="correo"
               value="${userSelect?.email}" disabled="">
    </div>
</div>

<div class="form-group">
    <label class="form-label" for="celular">Telefono Usuario</label>
    <div class="input-group has-length">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fal fa-phone"></i></span>
        </div>
        <input type="text" id="celular" class="form-control" placeholder="celular" aria-label="celular" aria-describedby="celular"
               value="${userSelect?.celular}" disabled="">
    </div>
</div>

<div class="form-group">
    <label class="form-label" for="indice">Indice Confianza</label>
    <div class="input-group has-length">
        <div class="input-group-prepend">
            <span class="input-group-text"><i class="fal fa-star"></i></span>
        </div>
        <input type="text" id="indice" class="form-control" placeholder="indice" aria-label="indice" aria-describedby="indice"
               value="${userSelect?.indiceConfianza} de 5" disabled="">
    </div>
</div>

<div class="col-md-12 ">
    <g:submitButton onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" name="Reservar"
            id="reservar" type="submit" class="btn btn-success btn-block btn-md mt-12">
        Reservar
    </g:submitButton>
</div>
