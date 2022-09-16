<%@ page import="gestion.General; espacio.TipoEspacio" %>
<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="dashboard" />
        <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
    <asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
        <div id="show-espacio" class="content scaffold-show" role="main">
            <g:form resource="${this.espacio}" method="PUT" enctype="multipart/form-data">
                <g:render template="form"/>
            </g:form>
        </div>
    <asset:javascript src="/formplugins/select2/select2.bundle.js"/>

%{--        <script async defer--}%
%{--                src="https://maps.googleapis.com/maps/api/js?key=${General.findByNombre("keyGoogleMaps").valor}&callback=initMap">--}%
%{--        </script>--}%
        <script>
            %{--// Initialize and add the map--}%
            %{--var marker;          //variable del marcador--}%
            %{--var coords = {};    //coordenadas obtenidas con la geolocalización--}%

            %{--//Funcion principal--}%
            %{--initMap = function ()--}%
            %{--{--}%

            %{--    //usamos la API para geolocalizar el usuario--}%
            %{--    navigator.geolocation.getCurrentPosition(--}%
            %{--        function (position){--}%
            %{--            coords =  {--}%
            %{--                lng: ${espacio?.longitud},--}%
            %{--                lat: ${espacio?.latitud}--}%
            %{--            };--}%
            %{--            setMapa(coords);  //pasamos las coordenadas al metodo para crear el mapa--}%

            %{--            document.getElementById("latitud").value = position.coords.latitude;--}%
            %{--            document.getElementById("longitud").value = position.coords.longitude;--}%

            %{--        },function(error){console.log(error);});--}%

            %{--}--}%

            %{--function setMapa (coords)--}%
            %{--{--}%
            %{--    //Se crea una nueva instancia del objeto mapa--}%
            %{--    var map = new google.maps.Map(document.getElementById('map'),--}%
            %{--        {--}%
            %{--            zoom: 13,--}%
            %{--            center:new google.maps.LatLng(coords.lat,coords.lng),--}%

            %{--        });--}%

            %{--    //Creamos el marcador en el mapa con sus propiedades--}%
            %{--    //para nuestro obetivo tenemos que poner el atributo draggable en true--}%
            %{--    //position pondremos las mismas coordenas que obtuvimos en la geolocalización--}%
            %{--    marker = new google.maps.Marker({--}%
            %{--        map: map,--}%
            %{--        draggable: true,--}%
            %{--        animation: google.maps.Animation.DROP,--}%
            %{--        position: new google.maps.LatLng(coords.lat,coords.lng),--}%

            %{--    });--}%
            %{--    //agregamos un evento al marcador junto con la funcion callback al igual que el evento dragend que indica--}%
            %{--    //cuando el usuario a soltado el marcador--}%
            %{--    marker.addListener('click', toggleBounce);--}%

            %{--    marker.addListener( 'dragend', function (event)--}%
            %{--    {--}%
            %{--        //escribimos las coordenadas de la posicion actual del marcador dentro del input #coords--}%
            %{--        document.getElementById("latitud").value = this.getPosition().lat();--}%
            %{--        document.getElementById("longitud").value = this.getPosition().lng();--}%

            %{--    });--}%
            %{--}--}%

            %{--//callback al hacer clic en el marcador lo que hace es quitar y poner la animacion BOUNCE--}%
            %{--function toggleBounce() {--}%
            %{--    if (marker.getAnimation() !== null) {--}%
            %{--        marker.setAnimation(null);--}%
            %{--    } else {--}%
            %{--        marker.setAnimation(google.maps.Animation.BOUNCE);--}%
            %{--    }--}%
            %{--}--}%
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

            function editNombreEspacio() {
                $('#nombre').html(''+
                    '<g:form method="POST" controller="espacio" action="editarCampo" id="${espacio?.id}">' +
                        '<div class="form-group row">'+
                            '<div class="col-sm-12 col-md-4 col-lg-4">'+
                                '<g:field type="text" id="nombre" name="nombre" class="form-control" placeholder="Ingrese nombre" required="" value="${espacio?.nombre}"/>' +
                            '</div>' +
                            '<br><br>' +
                            '<div class="col-sm-12 col-md-2 col-lg-2">'+
                                '<div class="btn-group btn-group-sm">'+
                                    '<button type="submit" class="btn btn-info btn-sm" ><i class="fal fa-check" aria-hidden="true"></i></button>'+
                                    '<a class="btn btn-secondary btn-sm" href="${createLink(controller: 'espacio', action: 'show', id: espacio?.id)}"><i class="fal fa-times" aria-hidden="true"></i></a>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</g:form>');
            }

            function editDescripcionEspacio(){
                $('#descripcion').html(''+
                    '<g:form method="POST" controller="espacio" action="editarCampo" id="${espacio?.id}">' +
                        '<div class="form-group row">'+
                            '<div class="col-sm-12 col-md-4 col-lg-4">'+
                                '<g:field type="text" id="descripcion" name="descripcion" class="form-control" placeholder="Ingrese descripción" required="" value="${espacio?.descripcion}"/>' +
                            '</div>' +
                            '<br><br>' +
                            '<div class="col-sm-12 col-md-2 col-lg-2">'+
                                '<div class="btn-group btn-group-sm">'+
                                    '<button type="submit" class="btn btn-info btn-sm" ><i class="fal fa-check" aria-hidden="true"></i></button>'+
                                    '<a class="btn btn-secondary btn-sm" href="${createLink(controller: 'espacio', action: 'show', id: espacio?.id)}"><i class="fal fa-times" aria-hidden="true"></i></a>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</g:form>');
            }

            function editTiempo(){
                $('#tiempo').html(''+
                    '<g:form method="POST" controller="espacio" action="editarCampo" id="${espacio?.id}">' +
                    '<div class="form-group row">'+
                    '<div class="col-sm-12 col-md-4 col-lg-4">'+
                    '<g:field type="number" id="tiempoArriendo" name="tiempoArriendo" class="form-control" placeholder="Ingrese Tiempo de Arriendo" required="" value="${espacio?.tiempoArriendo}"/>' +
                    '</div>' +
                    '<br><br>' +
                    '<div class="col-sm-12 col-md-2 col-lg-2">'+
                    '<div class="btn-group btn-group-sm">'+
                    '<button type="submit" class="btn btn-info btn-sm" ><i class="fal fa-check" aria-hidden="true"></i></button>'+
                    '<a class="btn btn-secondary btn-sm" href="${createLink(controller: 'espacio', action: 'show', id: espacio?.id)}"><i class="fal fa-times" aria-hidden="true"></i></a>' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</g:form>');
            }


            function editCapacidadEspacio(){
                $('#capacidad').html(''+
                    '<g:form method="POST" controller="espacio" action="editarCampo" id="${espacio?.id}">' +
                        '<div class="form-group row">'+
                            '<div class="col-sm-12 col-md-4 col-lg-4">'+
                                '<g:field type="number" id="capacidad" min="1" name="capacidad" class="form-control" placeholder="Capacidad Máxima de Personas" required="" value="${espacio?.capacidad}" onkeyup="this.value=Numeros(this.value)"/>' +
                            '</div>' +
                            '<br><br>' +
                            '<div class="col-sm-12 col-md-2 col-lg-2">'+
                                '<div class="btn-group btn-group-sm">'+
                                    '<button type="submit" class="btn btn-info btn-sm" ><i class="fal fa-check" aria-hidden="true"></i></button>'+
                                    '<a class="btn btn-secondary btn-sm" href="${createLink(controller: 'espacio', action: 'show', id: espacio?.id)}"><i class="fal fa-times" aria-hidden="true"></i></a>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</g:form>');
            }

            function editEnabledEspacio() {
                var valor = document.getElementById('enabled');
                var form = document.getElementById('formEnabled');
                valor.style.display = 'none';
                form.style.visibility = 'visible';
            }

            function editTipoEspacio(){
                var valor = document.getElementById('tipoEspacio');
                var form = document.getElementById('formEditTipo');
                valor.style.display = 'none';
                form.style.visibility = 'visible';
            }

            function Numeros(string){//Solo numeros
                var out = '';
                var filtro = '1234567890';//Caracteres validos

                for (var i=0; i<string.length; i++)
                    if (filtro.indexOf(string.charAt(i)) != -1)
                        out += string.charAt(i);
                return out;
            }

            function editDireccion(){
                var boton = document.getElementById('botonDireccion')
                boton.style.display = 'block';
            }

            $('.select2').select2();

        </script>
    </body>
</html>
