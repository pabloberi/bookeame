<%@ page import="espacio.Categoria; ubicacion.Comuna; ubicacion.Region; gestion.General; espacio.TipoEspacio" %>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
<div id="panel-7" class="panel">
	<div class="panel-hdr">
		<h2>
			Formulario <span class="fw-300"><i>Espacio</i></span>
		</h2>
		<div class="panel-toolbar">
			<button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
			<button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
			<button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
		</div>
	</div>

	<div class="panel-container show">
		<div class="panel-content">
			<div class="form-group">
				<div class="custom-control custom-switch">
					<input type="checkbox" class="custom-control-input" name="enabled" id="enabled" <% if( espacio?.enabled ){%>checked=""<%}%>>
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
				<label class="form-label" for="capacidad">Capacidad (MÁX DE PERSONAS)</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="number" id="capacidad" min="1" name="capacidad" class="form-control" placeholder="Capacidad Máxima de Personas" required="" value="${espacio?.capacidad}" onkeyup="this.value=Numeros(this.value)"/>
				</div>
			</div>
			<div class="form-group">
%{--				<label class="form-label" for="tipoEspacio">Categoría</label>--}%
%{--				<div class="input-group">--}%
%{--					<g:select name="tipoEspacio" id="tipoEspacio" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${TipoEspacio.findAllByEnabled(true)}" noSelection="['':'- Seleccione Categoría -']" value="${espacio?.tipoEspacio?.id}" />--}%
%{--				</div>--}%
				<label class="form-label" for="region">Categorías</label>
				<div class="input-group">
					<select name="tipoEspacio" id="tipoEspacio" class="form-control select2" style="width: 100%;" optionKey="id" required=""  >
						<option value="">- Seleccione Categoría -</option>
						<g:each in="${Categoria.findAllByEnabled(true)}" status="i" var="categoria">
							<optgroup label="${categoria}">
								<g:each in="${TipoEspacio.findAllByCategoriaAndEnabled(categoria, true)}" status="j" var="subCategoria">
									<option <% if( espacio?.tipoEspacio?.id == subCategoria?.id ){ %>selected="" <% } %> value="${subCategoria?.id}">${subCategoria}</option>
								</g:each>
							</optgroup>
						</g:each>
					</select>
				</div>
				<div class="help-block">No encuentras una categoría para tu espacio? escríbenos en el menú de ayuda.</div>
			</div>

			<div class="form-group">
				<label class="form-label" for="espacioFoto">Foto</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="file" class="form-control filename" name="espacioFoto" id="espacioFoto" accept=".jpg, .jpeg, .png" onblur="checkSize()"/>
					<div class="input-group-prepend">
						<a class="btn btn-sm btn-success" title="Ver imagen vigente" onclick="$('#imagenActualEspacio').modal('toggle');">
							<i class="fal fa-eye" ></i>
						</a>
					</div>
				</div>
			</div>
			<g:render template="modalVisorImagen" />

			<div class="form-group">
				<label class="form-label" for="region">Región</label>
				<div class="input-group">
					<g:select name="region" id="region" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${Region.list()}" noSelection="['':'- Seleccione Región-']" value="${espacio?.comuna?.provincia?.region?.id}" onchange="cargarComuna(this.value);" />
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="region">Comuna</label>
				<div class="input-group">
					<g:select name="comuna" id="comuna" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${Comuna.findById(espacio?.comuna?.id)}" noSelection="['':'- -']" value="${espacio?.comuna?.id}" />
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="direccion">Dirección</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="text" id="direccion" name="direccion" class="form-control" placeholder="Ingrese dirección" required="" value="${espacio?.direccion}"/>

				</div>
			</div>

%{--			<div class="form-group" >--}%
%{--				<div class="col-sm-12 col-md-12 col-lg-12 pr-1" >--}%
%{--					<label class="col-xl-12 form-label" for="map">Ubicación</label>--}%
%{--					<div id="map" class="card-img-top" style="width: 100%;height: 350px"></div>--}%
%{--				</div>--}%
%{--			</div>--}%
%{--			<div class="col-sm-12 col-md-3 col-lg-3 pr-1" style="display: none">--}%
%{--				<label class="col-xl-12 form-label" for="latitud">lat</label>--}%
%{--				--}%%{--<input type="text" id="lat"/>--}%
%{--				<g:field type="text" id="latitud" name="latitud" class="form-control" required="" />--}%
%{--			</div>--}%
%{--			<div class="col-sm-12 col-md-3 col-lg-3 pr-1"  style="display: none">--}%
%{--				<label class="col-xl-12 form-label" for="longitud">long</label>--}%
%{--				--}%%{--<input type="text" id="long"/>--}%
%{--				<g:field type="text" id="longitud" name="longitud" class="form-control" required="" />--}%
%{--			</div>--}%

			<div class="row no-gutters">
				<div class="col-md-4 ml-auto text-right">
					<g:if test="${actionName == 'create'}">
						<button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-3">Crear</button>
					</g:if>
					<g:if test="${actionName == 'show'}">
						<button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-3">Editar</button>
					</g:if>
				</div>
			</div>

		</div>
	</div>

	<asset:javascript src="/formplugins/select2/select2.bundle.js"/>
</div>

%{--<script async defer src="https://maps.googleapis.com/maps/api/js?key=${General.findByNombre("keyGoogleMaps").valor}&callback=initMap"></script>--}%

<script>
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

		if (sizekiloByte >  3072 ) {
			// console.log('entre al if');
			alert("Máximo 3 MB, su archivo pesa " +  sizekiloByte/1024 + " MB");
			document.getElementById("espacioFoto").value = '';
			return false;
		}
	}

	$('.select2').select2();

	function cargarComuna(regionId){
		$.ajax({
			type:'POST',
			url:'${g.createLink(controller: 'espacio', action: 'cargarComuna')}',
			data:{regionId:regionId},
			success:function(data,textStatus){$('#comuna').html(data);},error:function(XMLHttpRequest,textStatus,errorThrown){}});
	}

	//
	// var marker;          //variable del marcador
	// var coords = {};    //coordenadas obtenidas con la geolocalización
	//
	// //Funcion principal
	// initMap = function ()
	// {
	//
	// 	//usamos la API para geolocalizar el usuario
	// 	navigator.geolocation.getCurrentPosition(
    //         function (position){
    //                 coords =  {
    //                     lng: position.coords.longitude,
    //                     lat: position.coords.latitude
    //                 };
    //                 setMapa(coords);  //pasamos las coordenadas al metodo para crear el mapa
	//
    //                 document.getElementById("latitud").value = position.coords.latitude;
    //                 document.getElementById("longitud").value = position.coords.longitude;
	//
	// 			},function(error){console.log(error);});
	//
	// }
	//
	// function setMapa (coords)
	// {
	// 	//Se crea una nueva instancia del objeto mapa
	// 	var map = new google.maps.Map(document.getElementById('map'),
	// 			{
	// 				zoom: 13,
	// 				center:new google.maps.LatLng(coords.lat,coords.lng),
	//
	// 			});
	//
	// 	//Creamos el marcador en el mapa con sus propiedades
	// 	//para nuestro obetivo tenemos que poner el atributo draggable en true
	// 	//position pondremos las mismas coordenas que obtuvimos en la geolocalización
	// 	marker = new google.maps.Marker({
	// 		map: map,
	// 		draggable: true,
	// 		animation: google.maps.Animation.DROP,
	// 		position: new google.maps.LatLng(coords.lat,coords.lng),
	//
	// 	});
	// 	//agregamos un evento al marcador junto con la funcion callback al igual que el evento dragend que indica
	// 	//cuando el usuario a soltado el marcador
	// 	marker.addListener('click', toggleBounce);
	//
	// 	marker.addListener( 'dragend', function (event)
	// 	{
	// 		//escribimos las coordenadas de la posicion actual del marcador dentro del input #coords
	// 		document.getElementById("latitud").value = this.getPosition().lat();
	// 		document.getElementById("longitud").value = this.getPosition().lng();
	//
	// 	});
	// }
	//
	// //callback al hacer clic en el marcador lo que hace es quitar y poner la animacion BOUNCE
	// function toggleBounce() {
	// 	if (marker.getAnimation() !== null) {
	// 		marker.setAnimation(null);
	// 	} else {
	// 		marker.setAnimation(google.maps.Animation.BOUNCE);
	// 	}
	// }

</script>
