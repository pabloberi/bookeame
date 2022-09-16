%{--<g:form method="POST" controller="user" action="crearUserReservaManual" >--}%
	<div class="panel-container show">
		<div class="panel-content">
			<div class="container">
				<div class="panel-content">
					 <div class="panel-tag">
						 No hay coincidencias. Por favor ingresa los datos del Cliente para finalizar el registro.
					 </div>
					<div class="frame-wrap">
						<div class="form-group row">
							<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
								<label class="col-xl-12 form-label" for="nombreUser">Nombre</label>
								<g:field type="text" id="nombreUser" name="nombreUser" class="form-control" placeholder="Ingrese Nombre" required=""/>
								%{--<div class="invalid-feedback">No, you missed this one.</div>--}%
							</div>
						</div>
						<div class="form-group row">
							<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
								<label class="col-xl-12 form-label" for="correoUser">Correo</label>
								<g:field type="email" id="correoUser" name="correoUser" class="form-control" placeholder="Ingrese correo (solo .com)" required="" />
								%{--<div class="invalid-feedback">No, you missed this one.</div>--}%
							</div>
						</div>
						<div class="form-group row">
							<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
								<label class="col-xl-12 form-label" for="celularUser">Celular</label>
								<g:field type="text" id="celularUser" name="celularUser" class="form-control" placeholder="Ingrese Celular" required="" />
								%{--<div class="invalid-feedback">No, you missed this one.</div>--}%
							</div>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>
<div class="modal-footer">
%{--	<a href="${createLink(controller: 'reserva', action:'cancelarReservaManual', id: reservaId)}"><button type="button" class="btn btn-secondary" >Cancelar</button></a>--}%
	<g:submitButton class="btn btn-primary" name="crear" value="Crear" onclick="guardarCliente()"  />
	%{--<button type="submit" class="btn btn-primary">Crear</button>--}%
</div>
%{--</g:form>--}%
	<script>
		function guardarCliente(){
			var nombre = document.getElementById("nombreUser").value;
			console.log(nombre);
			var correo = document.getElementById("correoUser").value;
			console.log(correo);
			var celular = document.getElementById("celularUser").value;
			console.log(celular);
			$('#correo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>')

			if( nombre.length > 2 && celular.length > 1 && correo.length > 5){
				$.ajax({
					type: 'POST',
					url: '${g.createLink(controller: 'user', action: 'crearUser')}',
					data: {
						nombre: nombre,
						correo: correo,
						celular: celular,
						roleString: "ROLE_USER",
						moduloId: ${moduloId},
						fechaReserva: "${fechaReserva}"
					},
					success: function (data, textStatus) {
						$('#correo').html(data);
						sleep(1000);
					}, error: function (XMLHttpRequest, textStatus, errorThrown) {
					}
				});
			}else{
				$('#correo').html('Error al ingresar datos. intenta nuevamente.');
			}
		}
		function sleep(milisegundos) {
			var comienzo = new Date().getTime();
			while (true) {
				if ((new Date().getTime() - comienzo) > milisegundos)
					break;
			}
		}

		$("#correoUser").blur(function () {
			var aux = document.getElementById('correoUser');
			let e_stringCorreos = $(this).val()
					.replace(/\s+/g, '');
			const m_correos = e_stringCorreos.split(",");

			correos_validos = m_correos.filter(function(value){
				return /(.+)@(.+){2,}\.(.+){3,}/.test(value);
			})
			aux.value = correos_validos.join(", ");
			console.log(correos_validos.join(", "))
		});



	</script>


