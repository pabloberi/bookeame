<%@ page import="gestion.General" %>
<div class="col-xl-8 ml-auto mr-auto" id="formAdmin" style="display: none">
		<div class="card p-4 rounded-plus bg-faded">
			<h2 style="text-align: center"><strong>DATOS EMPRESA</strong></h2>
			<hr>
			<g:form method="POST" controller="empresa" action="crearEmpresa" id="formCrearEmpresa">
				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="giro">Giro</label>
						<g:field type="text" name="giro" id="giro" class="form-control" placeholder="Giro" required="" />
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="razonSocial">Razón Social</label>
						<g:field type="text" name="razonSocial" id="razonSocial" class="form-control" placeholder="Razón Social" required="" />
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
						<label class="form-label" for="emailEmpresa">Correo</label>
						<g:field type="email" id="emailEmpresa" name="emailEmpresa" class="form-control" placeholder="Correo" required="" />
						<div class="help-block">Este será tu nombre de usuario</div>
					</div>
					<div class="col-sm-12 col-md-4 col-lg-4 pr-1">
						<label class="form-label" for="rutEmpresa">RUT</label>
						<g:field type="text" maxlength="8" name="rutEmpresa" id="rutEmpresa" class="form-control" placeholder="Rut sin puntos" onkeyup="this.value=Numeros(this.value)" required="" />
						<div class="help-block">Digitos antes del guión</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2 pr-1">
						<label class="form-label" for="dvEmpresa">DV</label>
						<g:field type="text" name="dvEmpresa" id="dvEmpresa" class="form-control" placeholder="dv" maxlength="1" required="" onchange="validarRutEmpresa()"/>
						<div class="help-block">Digito después del guión</div>
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="direccionEmpresa">Dirección</label>
						<g:field type="text" name="direccionEmpresa" id="direccionEmpresa" class="form-control" placeholder="Ciudad, comuna, calle, nro..." required="" />
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
						<label class="form-label" for="passwordEmpresa">Contraseña</label>
						<div class="input-group-append">
							<g:passwordField type="text" id="passwordEmpresa" name="passwordEmpresa" class="form-control" placeholder="Contraseña" required=""/>
							<button id="show_passwordemp" class="btn btn-primary" type="button" onclick="mostrarPassword()"> <span class="fal fa-eye-slash icon icon1"></span> </button>
						</div>
					</div>
					<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
						<label class="form-label" for="passwordEmpresa2">Confirmar Contraseña</label>
						<div class="input-group-append">
							<g:passwordField type="text" id="passwordEmpresa2" name="passwordEmpresa2" class="form-control" placeholder="Repita Contraseña" required=""/>
							<button id="show_passwordemp1" class="btn btn-primary" type="button" onclick="mostrarPassword2()"> <span class="fal fa-eye-slash icon icon1"></span> </button>
						</div>
						<div class="invalid-feedback">Contraseñas distintas</div>
					</div>
				</div>
				<h2 style="text-align: center"><strong>REPRESENTANTE LEGAL</strong></h2>
				<hr>
				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="nombreRepresentante">Nombre</label>
						<g:field type="text" name="nombreRepresentante" id="nombreRepresentante" class="form-control" placeholder="NombreRepresentante" required="" />
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="apellidoPaternoRepresentante">Apellido Paterno</label>
						<g:field type="text" name="apellidoPaternoRepresentante" id="apellidoPaternoRepresentante" class="form-control" placeholder="Apellido Paterno" required="" />
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="nombreRepresentante">Apellido Materno</label>
						<g:field type="text" name="apellidoMaternoRepresentante" id="apellidoMaternoRepresentante" class="form-control" placeholder="Apellido Materno" required="" />
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
						<label class="form-label" for="celularRepresentante">Celular</label>
						<g:field type="text" name="celularRepresentante" id="celularRepresentante" class="form-control" placeholder="Celular" maxlength="12" required="" />
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
						<label class="form-label" for="fechaNacRepresentante">Fecha de Nacimiento</label>
						<div class="input-group">
							<g:field type="text" id="fechaNacRepresentante" name="fechaNacRepresentante" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
							<div class="input-group-append">
								<span class="input-group-text fs-xl">
									<i class="fal fa-calendar-check"></i>
								</span>
							</div>
						</div>
					</div>
					<div class="col-sm-12 col-md-4 col-lg-4 pr-1">
						<label class="form-label" for="rutRepresentante">Rut</label>
						<g:field type="text" maxlength="8" name="rutRepresentante" id="rutRepresentante" class="form-control" placeholder="Rut sin puntos" onkeyup="this.value=Numeros(this.value)" required="" />
						<div class="help-block">Digitos antes del guión</div>
					</div>
					<div class="col-sm-12 col-md-2 col-lg-2 pr-1">
						<label class="form-label" for="rutRepresentante">dv</label>
						<g:field type="text" name="dvRepresentante" id="dvRepresentante" maxlength="1" class="form-control" placeholder="dv" required="" onchange="validarRutRepresentante()"/>
						<div class="help-block">Digito después del guión</div>
					</div>
				</div>

				<div class="form-group demo">
					<div class="custom-control custom-checkbox">
						<g:field type="checkbox" name="terminos" class="custom-control-input" id="terminos" required="" />
						<label class="custom-control-label" for="terminos">Acepto término y condiciones</label>
					</div>
					<div class="custom-control custom-checkbox">
						<g:field type="checkbox" name="declaracion" class="custom-control-input" id="declaracion" required="" />
						<label class="custom-control-label" for="declaracion"> Declaro ser Dueño, Representante legal y/o poseer algún cargo con la facultad de realizar esta acción</label>
					</div>
				</div>
				<div class="row no-gutters">
%{--					<div class="col-md-4 ml-auto text-right">--}%
%{--						<button class="g-recaptcha" data-sitekey="${General.findByNombre('publicKeyCaptcha')?.valor}" data-callback='onSubmit' data-action='submit'>Submit</button>--}%
%{--					</div>--}%
					<div class="col-md-4 ml-auto text-right">
						<button id="botonRepresentante" type="submit" class="btn btn-block btn-danger btn-lg mt-3"
								data-sitekey="${General.findByNombre('publicKeyCaptcha')?.valor}"
								data-callback='onSubmit' data-action='submit'>Registrarme</button>
					</div>
				</div>

			</g:form>
		</div>
	</div>
	<script src="https://www.google.com/recaptcha/api.js"></script>

<script>
	$("#emailEmpresa").blur(function () {
		var aux = document.getElementById('emailEmpresa');
		let e_stringCorreos = $(this).val()
				.replace(/\s+/g, '');
		const m_correos = e_stringCorreos.split(",");

		correos_validos = m_correos.filter(function(value){
			return /(.+)@(.+){2,}\.(.+){2,}/.test(value);
		})
		aux.value = correos_validos.join(", ");
		console.log(correos_validos.join(", "))
	});

		function onSubmit(token) {
			document.getElementById("formCrearEmpresa").submit();
		}
	$('form').submit(function (e) {
		var string1 = document.getElementById('passwordEmpresa').value;
		var string2 = document.getElementById('passwordEmpresa2').value;

		$.ajax({
			type: 'POST',
			async: false,
			url: '${g.createLink(controller: 'user', action: 'compararPass')}',
			data: {string1: string1, string2: string2},
			success: function (data,textStatus) {

				if (data == "true") {
					$('.errorPass').style.display = 'none';
					// $('#boton').attr(disabled, false) ;
					// console.log("son iguales")
				}else{
					e.preventDefault();
					alert("Contraseñas no coinciden");
					// console.log("son distintas");
					// console.log(data)
				}
			}
		});
	});

	function validarRutRepresentante() {
		var rut = document.getElementById('rutRepresentante').value;
		var dv = document.getElementById('dvRepresentante').value;

		if( rut.length > 0 && dv.length > 0){
			$.ajax({
				type: 'POST',
				async: false,
				url: '${g.createLink(controller: 'user', action: 'validarDvAjax')}',
				data: {rut: rut, dv: dv},
				success: function (data,textStatus) {

					if (data == "true") {
						// $('#boton').attr(disabled, false) ;
					}else{
						// e.preventDefault();
						// $('#boton').attr(disabled, true) ;
						$('#rutRepresentante').val("");
						$('#dvRepresentante').val("");
						alert("Rut no válido");
					}
				}
			});
		}
	}

	function validarRutEmpresa() {
		var rut = document.getElementById('rutEmpresa').value;
		var dv = document.getElementById('dvEmpresa').value;

		if( rut.length > 0 && dv.length > 0){
			$.ajax({
				type: 'POST',
				async: false,
				url: '${g.createLink(controller: 'user', action: 'validarDvAjax')}',
				data: {rut: rut, dv: dv},
				success: function (data,textStatus) {

					if (data == "true") {
						// $('#boton').attr(disabled, false) ;
					}else{
						// e.preventDefault();
						// $('#boton').attr(disabled, true) ;
						$('#rutEmpresa').val("");
						$('#dvEmpresa').val("");
						alert("Rut no válido");
					}
				}
			});
		}
	}

	function mostrarPassword(){
		var cambio = document.getElementById("passwordEmpresa");
		if(cambio.type == "password"){
			cambio.type = "text";
			$('.icon1').removeClass('fa fa-eye-slash').addClass('fal fa-eye');
		}else{
			cambio.type = "password";
			$('.icon1').removeClass('fa fa-eye').addClass('fal fa-eye-slash');
		}
	}

	function mostrarPassword2(){
		var cambio = document.getElementById("passwordEmpresa2");
		if(cambio.type == "password"){
			cambio.type = "text";
			$('.icon2').removeClass('fa fa-eye-slash').addClass('fal fa-eye');
		}else{
			cambio.type = "password";
			$('.icon2').removeClass('fa fa-eye').addClass('fal fa-eye-slash');
		}
	}


</script>