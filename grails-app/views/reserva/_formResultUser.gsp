<div class="frame-wrap">
	<br>
	<div class="panel-tag">
		No hay coincidencias. Por favor ingresa los datos del Cliente para finalizar el registro.
	</div>

	<div class="form-group">
		<label class="form-label" for="nombreUser">Nombre Usuario</label>
		<div class="input-group has-length">
			<div class="input-group-prepend">
				<span class="input-group-text"><i class="fal fa-user-circle"></i></span>
			</div>
			<g:field type="text" id="nombreUser" name="nombreUser" class="form-control" placeholder="Ingrese Nombre" required=""/>
		</div>
	</div>
	<div class="form-group">
		<label class="form-label" for="correoUser">Correo Usuario</label>
		<div class="input-group has-length">
			<div class="input-group-prepend">
				<span class="input-group-text"><i class="fal fa-at"></i></span>
			</div>
			<g:field type="email" id="correoUser" name="correoUser" class="form-control" placeholder="Ingrese correo (solo .com)" required="" />
		</div>
	</div>
	<div class="form-group">
		<label class="form-label" for="celularUser">Telefono Usuario</label>
		<div class="input-group has-length">
			<div class="input-group-prepend">
				<span class="input-group-text"><i class="fal fa-phone"></i></span>
			</div>
			<g:field type="text" id="celularUser" name="celularUser" class="form-control" placeholder="Ingrese Celular" required="" />
		</div>
	</div>
</div>
<div class="col-md-12 ">
	<button onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" name="tipoReservaId"
			id="reservar" type="submit" class="btn btn-success btn-block btn-md mt-12" value="1" >
		Reservar
	</button>
</div>
