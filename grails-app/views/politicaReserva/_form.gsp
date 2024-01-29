<div id="panel-7" class="panel">
	<div class="panel-hdr">
		<h2>
			Formulario <span class="fw-300"><i>Politicas Reserva</i></span>
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
				<label class="form-label" for="descripcion">Descripción</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="text" id="descripcion" name="descripcion" class="form-control" placeholder="Ingrese Política" required="" value="${politicaReserva?.descripcion}"/>
				</div>
			</div>

			<div class="row no-gutters">
				<div class="col-md-4 ml-auto text-right">
					<g:if test="${actionName == 'create'}">
						<button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-3">Crear</button>
					</g:if>
					<g:if test="${actionName == 'edit'}">
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
