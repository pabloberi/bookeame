<%@ page import="gestion.General" %>
<!DOCTYPE html>
<g:applyLayout name="dashboard">
    <sec:ifAnyGranted roles="ROLE_ADMIN">
        <g:render template="homeAdmin" model="[espacioList: espacioList]"/>
    </sec:ifAnyGranted>

    <sec:ifAnyGranted roles="ROLE_USER">
%{--        <div id="vistaUser">--}%
            <g:render template="homeUser" />
            %{--            <g:render template="homeUser" model="[ubicacionUser: ubicacionUser]"/>--}%
%{--        </div>--}%

%{--        <g:render template="ubicacionUser"/>--}%

%{--        <script async defer--}%
%{--                src="https://maps.googleapis.com/maps/api/js?key=${General.findByNombre("keyGoogleMaps").valor}&callback=initMap">--}%
%{--        </script>--}%

%{--        <script>--}%
%{--            var coords = {};    //coordenadas obtenidas con la geolocalización--}%

%{--            //Funcion principal--}%
%{--            initMap = function () {--}%
%{--                //usamos la API para geolocalizar el usuario--}%
%{--                navigator.geolocation.getCurrentPosition(--}%
%{--                    function (position){--}%
%{--                        <g:if test="${ubicacionUser}">--}%
%{--                            coords =  {--}%
%{--                                lng: ${ubicacionUser?.longitud},--}%
%{--                                lat: ${ubicacionUser?.latitud}--}%
%{--                            };--}%
%{--                        </g:if>--}%
%{--                        <g:else>--}%
%{--                            coords =  {--}%
%{--                                lng: position.coords.longitude,--}%
%{--                                lat: position.coords.latitude--}%
%{--                            };--}%
%{--                        </g:else>--}%
%{--                        setMapa(coords);  //pasamos las coordenadas al metodo para crear el mapa--}%

%{--                        function setMapa (coords) {--}%
%{--                            //Se crea una nueva instancia del objeto mapa--}%
%{--                            var map = new google.maps.Map(document.getElementById('map'),--}%
%{--                                {--}%
%{--                                    zoom: 13,--}%
%{--                                    center:new google.maps.LatLng(coords.lat,coords.lng),--}%

%{--                                });--}%

%{--                            //Creamos el marcador en el mapa con sus propiedades--}%
%{--                            //para nuestro obetivo tenemos que poner el atributo draggable en true--}%
%{--                            //position pondremos las mismas coordenas que obtuvimos en la geolocalización--}%
%{--                            marker = new google.maps.Marker({--}%
%{--                                map: map,--}%
%{--                                draggable: true,--}%
%{--                                animation: google.maps.Animation.DROP,--}%
%{--                                position: new google.maps.LatLng(coords.lat,coords.lng),--}%

%{--                            });--}%
%{--                            //agregamos un evento al marcador junto con la funcion callback al igual que el evento dragend que indica--}%
%{--                            //cuando el usuario a soltado el marcador--}%
%{--                            // marker.addListener('click', toggleBounce);--}%

%{--                            // marker.addListener( 'dragend', function (event)--}%
%{--                            // {--}%
%{--                            //     //escribimos las coordenadas de la posicion actual del marcador dentro del input #coords--}%
%{--                            //     document.getElementById("latitud").value = this.getPosition().lat();--}%
%{--                            //     document.getElementById("longitud").value = this.getPosition().lng();--}%
%{--                            //--}%
%{--                            // });--}%
%{--                        }--}%

%{--                        $.ajax({--}%
%{--                            type: 'POST',--}%
%{--                            url: '${g.createLink(controller: 'home', action: 'espaciosCerca')}',--}%
%{--                            <g:if test="${ ubicacionUser?.id == null }">--}%
%{--                                data: {lat: coords.lat, lng: coords.lng},--}%
%{--                            </g:if>--}%
%{--                            <g:else>--}%
%{--                                data: { lat: ${ubicacionUser?.latitud}, lng: ${ubicacionUser?.longitud} },--}%
%{--                            </g:else>--}%
%{--                            success: function (data, textStatus) {--}%
%{--                                $('#vistaUser').html(data);--}%
%{--                            }, error: function (XMLHttpRequest, textStatus, errorThrown) {--}%
%{--                            }--}%
%{--                        });--}%
%{--                    },function(error){console.log(error);});--}%
%{--            }--}%

%{--            <g:if test="${ ubicacionUser?.id == null }">--}%
%{--                $( document ).ready(function() {--}%
%{--                    $('#ubicacionUser').modal('toggle');--}%
%{--                });--}%
%{--            </g:if>--}%

%{--        </script>--}%
    </sec:ifAnyGranted>
</g:applyLayout>
