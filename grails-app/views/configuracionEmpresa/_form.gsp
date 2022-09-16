<%@ page import="espacio.TipoEspacio" %>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>

			<div class="form-group">
				<div class="custom-control custom-switch">
					<input type="checkbox" class="custom-control-input" id="enabled" checked="">
					<label class="custom-control-label" for="enabled">Habilitado</label>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label" for="nombre">Nombre</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="text" id="nombre" name="nombre" class="form-control" placeholder="Ingrese nombre" required="" value="${espacio?.nombre}"/>
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="descripcion">Descripción</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="text" id="descripcion" name="descripcion" class="form-control" placeholder="Ingrese descripción" required="" value="${espacio?.descripcion}"/>

				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="valor">Precio</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text">$</span>
					</div>
					<g:field type="number" id="valor" min="0" name="valor" class="form-control" placeholder="Ingrese valor de la reserva" required="" value="${espacio?.valor}" onkeyup="this.value=Numeros(this.value)"/>
					<div class="input-group-append">
						<span class="input-group-text">.-</span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="capacidad">Capacidad</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="number" id="capacidad" min="1" name="capacidad" class="form-control" placeholder="Capacidad Máxima de Personas" required="" value="${espacio?.capacidad}" onkeyup="this.value=Numeros(this.value)"/>
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="tipoEspacio">Tipo de Espacio</label>
				<div class="input-group">
%{--					<div class="input-group-prepend">--}%
%{--						<span class="input-group-text"></span>--}%
%{--					</div>--}%
					<g:select name="tipoEspacio" id="tipoEspacio" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${TipoEspacio.findAllByEnabled(true)}" noSelection="['':'- Seleccione Tipo Espacio -']" value="${espacio?.tipoEspacio?.id}" />
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="tiempoArriendo">Tiempo de Arriendo</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"><i class="fal fa-clock" ></i></span>
					</div>
					<g:field type="number" id="tiempoArriendo" min="1" name="tiempoArriendo" class="form-control" placeholder="Minutos" required="" value="${espacio?.tiempoArriendo}" onkeyup="this.value=Numeros(this.value)"/>
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="espacioFoto">Foto</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="file" name="espacioFoto" id="espacioFoto" accept=".jpg, .jpeg, .png" onblur="checkSize()"/>
					<label class="custom-file-label" for="espacioFoto">Elegir Foto</label>
				</div>
			</div>

			<div class="row no-gutters">
				<div class="col-md-4 ml-auto text-right">
					<button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-3">Crear</button>
				</div>
			</div>


	<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<script>
	function Numeros(string){//Solo numeros
	    var out = '';
	    var filtro = '1234567890';//Caracteres validos

	    for (var i=0; i<string.length; i++)
	        if (filtro.indexOf(string.charAt(i)) != -1)
	            out += string.charAt(i);
	    return out;
	}

	function checkSize() {
		var fileSize = $('#espacioFoto')[0].files[0].size;
		var sizekiloByte = parseInt(fileSize / 1024);
		// console.log(fileSize);
		// console.log(sizekiloByte);

		if (sizekiloByte >  22000 ) {
			// console.log('entre al if');
			alert("Máximo 20 MB, su archivo pesa " +  sizekiloByte/1024 + " MB");
			document.getElementById("espacioFoto").value = '';
			return false;
		}
	}

	$('.select2').select2();


</script>