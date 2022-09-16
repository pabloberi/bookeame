<%@ page import="gestion.General" %>
<div class="col-xl-8 ml-auto mr-auto" id="formUser" style="display: none">
	<div class="card p-4 rounded-plus bg-faded">
		<h2 style="text-align: center"><strong>DATOS PERSONALES</strong></h2>
		<hr>

		<g:form method="POST" controller="user" action="registroUser" id="formCrearUser">

			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
					<label class="form-label" for="nombre">Nombre</label>
					<g:field type="text" name="nombre" id="nombre" class="form-control" placeholder="Nombre" required="" />
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
					<label class="form-label" for="apellidoPaterno">Apellido Paterno</label>
					<g:field type="text" name="apellidoPaterno" id="apellidoPaterno" class="form-control" placeholder="Apellido Paterno" required="" />
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
					<label class="form-label" for="nombre">Apellido Materno</label>
					<g:field type="text" name="apellidoMaterno" id="apellidoMaterno" class="form-control" placeholder="Apellido Materno" required="" />
				</div>
			</div>

			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
					<label class="form-label" for="email">Correo</label>
					<g:field type="email" id="emailUser" name="email" class="form-control" placeholder="Correo ( Solo .com )" required=""  />
					<div class="help-block">Este será tu nombre de usuario</div>
				</div>
			</div>
			<div class="form-group row">
				<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
					<label class="form-label" for="celular">Celular</label>
					<g:field type="text" name="celular" id="celular" class="form-control" placeholder="Celular" maxlength="12" required="" />
				</div>
			</div>


			<div class="form-group row">
				<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
					<label class="form-label" for="fechaNac">Fecha de Nacimiento</label>
					<div class="input-group">
						<g:field type="text" id="fechaNac" name="fechaNac" data-date-format="dd-mm-yyyy" class="form-control datepicker" readonly="" placeholder="dd-mm-aaaa" required="" />
						<div class="input-group-append">
							<span class="input-group-text fs-xl">
								<i class="fal fa-calendar-check"></i>
							</span>
						</div>
					</div>
				</div>
				<div class="col-sm-12 col-md-4 col-lg-4 pr-1">
					<label class="form-label" for="rut">RUT</label>
					<g:field type="text" maxlength="8" name="rut" id="rut" class="form-control" placeholder="12345678" required=""  onkeyup="this.value=Numeros(this.value)" />
					<div class="help-block">Digitos antes del guión</div>
				</div>
				<div class="col-sm-12 col-md-2 col-lg-2 pr-1">
					<label class="form-label" for="rut">DV</label>
					<g:field type="text" name="dv" id="dv" class="form-control" placeholder="9" required="" maxlength="1" onchange="validarRut()"/>
					<div class="help-block">Digito después del guión</div>
				</div>
			</div>

			<div class="form-group row">
				<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
					<label class="form-label" for="password">Contraseña</label>
					<div class="input-group-append">
						<g:passwordField type="text" id="password3" name="password" class="form-control" placeholder="Contraseña" required=""/>
						<button id="show_password1" class="btn btn-primary" type="button" onclick="mostrarPassword3()"> <span class="fal fa-eye-slash icon icon1"></span> </button>
					</div>
					<div class="invalid-feedback">Contraseñas distintas</div>
				</div>
				<div class="col-sm-12 col-md-6 col-lg-6 pr-1">
					<label class="form-label" for="password2">Confirmar Contraseña</label>
					<div class="input-group-append">
						<g:passwordField type="text" id="password4" name="password2" class="form-control" placeholder="Repita Contraseña" required=""/>
						<button id="show_password2" class="btn btn-primary" type="button" onclick="mostrarPassword4()"> <span class="fal fa-eye-slash icon icon2"></span> </button>
					</div>
					<div class="invalid-feedback">Contraseñas distintas</div>
				</div>

			</div>

			<div class="form-group demo">
				<div class="custom-control custom-checkbox">
					<g:field type="checkbox" name="terms" class="custom-control-input" id="terms" required="" />
					<label class="custom-control-label" for="terms"> Acepto término y condiciones</label>
%{--					<div class="invalid-feedback">You must agree before proceeding</div>--}%
				</div>
			</div>

			<div class="row no-gutters">
%{--				<div class="col-md-4 ml-auto text-right">--}%
%{--					<button class="g-recaptcha" data-sitekey="${General.findByNombre('publicKeyCaptcha')?.valor}" data-callback='onSubmit' data-action='submit'>Submit</button>--}%
%{--				</div>--}%
				<div class="col-md-4 ml-auto text-right">
					<button id="boton" type="submit" class="btn btn-block btn-danger btn-lg mt-3"
							data-sitekey="${General.findByNombre('publicKeyCaptcha')?.valor}" data-callback='onSubmit' data-action='submit'>Registrarme</button>
				</div>
			</div>
		</g:form>
	</div>
</div>
<script src="https://www.google.com/recaptcha/api.js"></script>

<script>
	function onSubmit(token) {
		document.getElementById("formCrearUser").submit();
	}
	$('form').submit(function (e) {
		var string1 = document.getElementById('password').value;
		var string2 = document.getElementById('password2').value;

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

	function validarRut() {
		var rut = document.getElementById('rut').value;
		var dv = document.getElementById('dv').value;

		if( rut.length > 0 && dv.length > 0 ){
			$.ajax({
				type: 'POST',
				async: false,
				url: '${g.createLink(controller: 'user', action: 'validarDvAjax')}',
				data: {rut: rut, dv: dv},
				success: function (data,textStatus) {

					if (data == "true") {

					}else{
						$('#rut').val("");
						$('#dv').val("");
						alert("Rut no válido");
					}
				}
			});
		}
	}

	$("#emailUser").blur(function () {
		var aux = document.getElementById('emailUser');
		let e_stringCorreos = $(this).val()
				.replace(/\s+/g, '');
		const m_correos = e_stringCorreos.split(",");

		correos_validos = m_correos.filter(function(value){
			return /(.+)@(.+){3,}\.(.+){3,}/.test(value);
		})
		aux.value = correos_validos.join(", ");
		console.log(correos_validos.join(", "))
	});

	function mostrarPassword3(){
		var cambio = document.getElementById("password3");
		if(cambio.type == "password"){
			cambio.type = "text";
			$('.icon1').removeClass('fa fa-eye-slash').addClass('fal fa-eye');
		}else{
			cambio.type = "password";
			$('.icon1').removeClass('fa fa-eye').addClass('fal fa-eye-slash');
		}
	}

	// $(document).ready(function () {
	// 	//CheckBox mostrar contraseña
	// 	$('#ShowPassword').click(function () {
	// 		$('#Password').attr('type', $(this).is(':checked') ? 'text' : 'password');
	// 	});
	// });

	function mostrarPassword4(){
		var cambio = document.getElementById("password4");
		if(cambio.type == "password"){
			cambio.type = "text";
			$('.icon2').removeClass('fa fa-eye-slash').addClass('fal fa-eye');
		}else{
			cambio.type = "password";
			$('.icon2').removeClass('fa fa-eye').addClass('fal fa-eye-slash');
		}
	}

	// $(document).ready(function () {
	// 	//CheckBox mostrar contraseña
	// 	$('#ShowPassword').click(function () {
	// 		$('#Password').attr('type', $(this).is(':checked') ? 'text' : 'password');
	// 	});
	// });
</script>