<%@ page import="gestion.General; espacio.TipoEspacio" %>
<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Crear<span class="fw-300"><i>Dirección</i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>

    <div class="panel-container show">
        <div class="panel-content">
            %{--			<div class="panel-tag">--}%
            %{--				<p>Place one add-on or button on either side of an input. You may also place one on both sides of an input. Remember to place <code>&lt;label&gt;</code>s outside the input group.</p>--}%
            %{--			</div>--}%
            <div class="form-group">
                <label class="form-label" for="nombre">Nombre</label>
                <div class="input-group">
                    <div class="input-group-prepend">
                        <span class="input-group-text"></span>
                    </div>
                    <g:field type="text" id="nombre" name="nombre" class="form-control" placeholder="Ingrese nombre" required="" />
                </div>
            </div>
            <div class="form-group" >
                <div class="col-sm-12 col-md-12 col-lg-12 pr-1" >
                    <label class="col-xl-12 form-label" for="mapaForm">Ubicación</label>
                    <div id="mapaForm" class="card-img-top" style="width: 100%;height: 350px"></div>
                </div>
            </div>
            <div class="col-sm-12 col-md-3 col-lg-3 pr-1" style="display: none">
                <label class="col-xl-12 form-label" for="latitud">lat</label>
                %{--<input type="text" id="lat"/>--}%
                <g:field type="text" id="latitud" name="latitud" class="form-control" required="" />
            </div>
            <div class="col-sm-12 col-md-3 col-lg-3 pr-1"  style="display: none">
                <label class="col-xl-12 form-label" for="longitud">long</label>
                %{--<input type="text" id="long"/>--}%
                <g:field type="text" id="longitud" name="longitud" class="form-control" required="" />
            </div>

            <div class="row no-gutters">
                <div class="col-md-4 ml-auto text-right">
                    <button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-3">Crear</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script async defer src="https://maps.googleapis.com/maps/api/js?key=${General.findByNombre("keyGoogleMaps").valor}&callback=initMap"></script>

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

    var marker;          //variable del marcador
    var coords = {};    //coordenadas obtenidas con la geolocalización

    //Funcion principal
    initMap = function ()
    {

        //usamos la API para geolocalizar el usuario
        navigator.geolocation.getCurrentPosition(
            function (position){
                coords =  {
                    lng: position.coords.longitude,
                    lat: position.coords.latitude
                };
                setMapa(coords);  //pasamos las coordenadas al metodo para crear el mapa

                document.getElementById("latitud").value = position.coords.latitude;
                document.getElementById("longitud").value = position.coords.longitude;

            },function(error){console.log(error);});

    }

    function setMapa (coords)
    {
        //Se crea una nueva instancia del objeto mapa
        var map = new google.maps.Map(document.getElementById('mapaForm'),
            {
                zoom: 13,
                center:new google.maps.LatLng(coords.lat,coords.lng),

            });

        //Creamos el marcador en el mapa con sus propiedades
        //para nuestro obetivo tenemos que poner el atributo draggable en true
        //position pondremos las mismas coordenas que obtuvimos en la geolocalización
        marker = new google.maps.Marker({
            map: map,
            draggable: true,
            animation: google.maps.Animation.DROP,
            position: new google.maps.LatLng(coords.lat,coords.lng),

        });
        //agregamos un evento al marcador junto con la funcion callback al igual que el evento dragend que indica
        //cuando el usuario a soltado el marcador
        marker.addListener('click', toggleBounce);

        marker.addListener( 'dragend', function (event)
        {
            //escribimos las coordenadas de la posicion actual del marcador dentro del input #coords
            document.getElementById("latitud").value = this.getPosition().lat();
            document.getElementById("longitud").value = this.getPosition().lng();

        });
    }

    //callback al hacer clic en el marcador lo que hace es quitar y poner la animacion BOUNCE
    function toggleBounce() {
        if (marker.getAnimation() !== null) {
            marker.setAnimation(null);
        } else {
            marker.setAnimation(google.maps.Animation.BOUNCE);
        }
    }

</script>