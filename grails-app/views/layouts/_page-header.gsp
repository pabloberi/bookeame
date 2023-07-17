<%@ page import="gestion.General; ubicacion.UbicacionUser; espacio.TipoEspacio; auth.User;" %>
<!-- BEGIN Page Header -->
<header class="page-header" role="banner">
    <!-- we need this logo when user switches to nav-function-top -->
    <div class="page-logo">
        <a href="#" class="page-logo-link press-scale-down d-flex align-items-center position-relative" data-toggle="modal" data-target="#modal-shortcut">
            <asset:image src="logo.png" aria-roledescription="logo" alt="logo"/>

            <span class="page-logo-text mr-1">{{app-flavor}}</span>
            <span class="position-absolute text-white opacity-50 small pos-top pos-right mr-2 mt-n2">{{app-flavor-subscript}}</span>

            <i class="fal fa-angle-down d-inline-block ml-1 fs-lg color-primary-300"></i>

        </a>
    </div>
    %{--{{#if appLayoutShortcut}}--}%
    <!-- DOC: nav menu layout change shortcut -->
    <div class="hidden-md-down dropdown-icon-menu position-relative">
        <a href="#" class="header-btn btn js-waves-off" data-action="toggle" data-class="nav-function-hidden" title="Hide Navigation">
            <i class="ni ni-menu"></i>
        </a>
        <ul>
            <li>
                <a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-minify" title="Minify Navigation">
                    <i class="ni ni-minify-nav"></i>
                </a>
            </li>
            <li>
                <a href="#" class="btn js-waves-off" data-action="toggle" data-class="nav-function-fixed" title="Lock Navigation">
                    <i class="ni ni-lock-nav"></i>
                </a>
            </li>
        </ul>
    </div>
    %{--{{/if}}--}%

    <!-- DOC: mobile button appears during mobile width -->
    <div class="hidden-lg-up">
        <a href="#" class="header-btn btn press-scale-down" data-action="toggle" data-class="mobile-nav-on">
            <i class="ni ni-menu"></i>
        </a>
    </div>

    <div class="ml-auto d-flex">
        <a href="#" class="header-icon" data-toggle="modal" data-target=".js-modal-messenger">
            <div class="hidden-sm-down">
                <script>
                    var meses = new Array ("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre");
                    var diasSemana = new Array("Domingo","Lunes","Martes","Miércoles","Jueves","Viernes","Sábado");
                    var f=new Date();
                    document.write(diasSemana[f.getDay()] + ", " + f.getDate() + " de " + meses[f.getMonth()] + " de " + f.getFullYear());
                </script>
            </div>
        </a>
        <div>
            <div id="hora" style="color: #050505; margin-top: 15px; padding: 5px 15px; font-size: 17px;"></div>
            <script>
                function startTime() {
                    var today=new Date();
                    var h=today.getHours();
                    var m=today.getMinutes();
                    var s=today.getSeconds();
                    m = checkTime(m);
                    s = checkTime(s);
                    document.getElementById('hora').innerHTML = h+":"+m+":"+s;
                    var t = setTimeout(function(){startTime()},500);
                }
                function checkTime(i) {
                    if (i<10) {i = "0" + i}  // add zero in front of numbers < 10
                    return i;
                }
            </script>
        </div>
%{--        <sec:ifAnyGranted roles="ROLE_USER">--}%

%{--            <a href="javascript: verUbicacion();" class="header-icon" title="Mi ubicacion actual">--}%
%{--                <i class="fal fa-map"></i>--}%
%{--            </a>--}%
%{--            <% UbicacionUser ubicacionUser = UbicacionUser.findByUsuarioAndEnUso(user, true) %>--}%

%{--            <script>--}%
%{--                function verUbicacion() {--}%
%{--                    $('#ubicacionConsulta').modal('toggle');--}%
%{--                }--}%
%{--            </script>--}%
%{--        </sec:ifAnyGranted>--}%

    <g:if test="${session['link'] && session['temp']}">
        <%
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(session["temp"]?.dateCreated)

            calendar.add(Calendar.MINUTE, 4)
        %>
        <g:if test="${calendar.getTime() > new Date() }" >
            <!-- carrito compras -->
            <div>
                <a href="#" class="header-icon" data-toggle="dropdown" title="Tienes 1 reservas en tu carrito">
                    <i class="fal fa-shopping-cart"></i>
%{--                    <span id="minutes"></span>:<span id="seconds"></span>--}%
                    <span class="badge badge-icon" style="width: auto;">
                        <span style="font-size: 9px" id="minutes"></span>:<span style="font-size: 9px" id="seconds"></span>
                    </span>
                </a>
                <div class="dropdown-menu dropdown-menu-animated dropdown-xl">
                    <g:render template="/layouts/dropdown-notification"/>
                </div>
            </div>

            <script>
                document.addEventListener('DOMContentLoaded', () => {

                    //===
                    // VARIABLES
                    //===
                    const DATE_TARGET =  new Date( '${ g.formatDate(format: "MM-dd-yyyy HH:mm", date: calendar.getTime() ) }' );
                    // DOM for render
                    const SPAN_MINUTES = document.querySelector('span#minutes');
                    const SPAN_SECONDS = document.querySelector('span#seconds');
                    // Milliseconds for the calculations
                    const MILLISECONDS_OF_A_SECOND = 1000;
                    const MILLISECONDS_OF_A_MINUTE = MILLISECONDS_OF_A_SECOND * 60;
                    const MILLISECONDS_OF_A_HOUR = MILLISECONDS_OF_A_MINUTE * 60;
                    // const MILLISECONDS_OF_A_DAY = MILLISECONDS_OF_A_HOUR * 24

                    //===
                    // FUNCTIONS
                    //===

                    /**
                     * Method that updates the countdown and the sample
                     */
                    function updateCountdown() {
                        // Calcs
                        const NOW = new Date()
                        const DURATION = DATE_TARGET - NOW;
                        // const REMAINING_DAYS = Math.floor(DURATION / MILLISECONDS_OF_A_DAY);
                        // const REMAINING_HOURS = Math.floor((DURATION % MILLISECONDS_OF_A_DAY) / MILLISECONDS_OF_A_HOUR);
                        const REMAINING_MINUTES = Math.floor((DURATION % MILLISECONDS_OF_A_HOUR) / MILLISECONDS_OF_A_MINUTE);
                        const REMAINING_SECONDS = Math.floor((DURATION % MILLISECONDS_OF_A_MINUTE) / MILLISECONDS_OF_A_SECOND);
                        // Thanks Pablo Monteserín (https://pablomonteserin.com/cuenta-regresiva/)

                        // Render
                        // SPAN_DAYS.textContent = REMAINING_DAYS;
                        // SPAN_HOURS.textContent = REMAINING_HOURS;
                        if(REMAINING_MINUTES >= 0 && REMAINING_SECONDS >= 0 ){
                            SPAN_MINUTES.textContent = REMAINING_MINUTES;
                            if( REMAINING_SECONDS < 10 ){
                                SPAN_SECONDS.textContent = '0' + REMAINING_SECONDS;
                            }else{
                                SPAN_SECONDS.textContent = REMAINING_SECONDS;
                            }
                        }else{
                            // if( !$('#botonPago').classList.contains('disabled') ){
                            //     $('#botonPago').style.visibility = 'hidden';
                                <%
                                    session['link'] = null
                                    session['temp'] = null
                                %>
                                location.reload();
                            // }
                        }

                        // SPAN_SECONDS.textContent = REMAINING_SECONDS;
                        // if( REMAINING_MINUTES === 0 && REMAINING_SECONDS === 0 ){
                        //     location.reload();
                        // }
                    }

                    //===
                    // INIT
                    //===
                    updateCountdown();
                    // Refresh every second
                    setInterval(updateCountdown, MILLISECONDS_OF_A_SECOND);
                });
            </script>
            <!-- carrito compras -->
        </g:if>
        <g:else>
            <g:if test="${session['link'] && session['temp']}">
                <%
                    session['link'] = null
                    session['temp'] = null
                %>
            </g:if>
        </g:else>
    </g:if>


        <div>
            <a href="#" data-toggle="dropdown" title="email" class="header-icon d-flex align-items-center justify-content-center ml-2" aria-expanded="false">
                <g:if test="${user?.foto}">
                    <g:if test="${user?.provider == 'google'}">
                        <img src="${raw(user?.foto)}" style="height: 50px; width: 50px;" alt="" class="profile-image rounded-circle"/>
                    </g:if>
                    <g:else>
                        <asset:image src="/imagenes/users/${user?.id}/${user?.foto}" style="height: 50px; width: 50px;" alt="" class="profile-image rounded-circle"/>
                    </g:else>
                </g:if>
                <g:else>
                    <asset:image src="/imagenes/imagenNula.png" style="height: 50px; width: 50px;" alt="" class="profile-image rounded-circle"/>
                </g:else>
            </a>
            <div class="dropdown-menu dropdown-menu-animated dropdown-lg">
                <div class="dropdown-header bg-trans-gradient d-flex flex-row py-4 rounded-top">
                    <div class="d-flex flex-row align-items-center mt-1 mb-1 color-white">
                        <span class="mr-2">
                            <g:if test="${user?.foto}">
                                <g:if test="${user?.provider == 'google'}">
                                    <img src="${raw(user?.foto)}"  absolute="true"
                                           style="height: 45px; width: 45px;" alt="" class="profile-image rounded-circle" />
                                </g:if>
                                <g:else>
                                    <asset:image src="/imagenes/users/${user?.id}/${user?.foto}" style="height: 45px; width: 45px;" alt="" class="profile-image rounded-circle"/>
                                </g:else>
                            </g:if>
                            <g:else>
                                <asset:image src="/imagenes/imagenNula.png" style="height: 45px; width: 45px;" alt="" class="profile-image rounded-circle"/>
                            </g:else>
                        </span>
                        <div class="info-card-text">
                            <div class="fs-lg text-truncate text-truncate-lg">${user?.username}</div>
                            <sec:ifAnyGranted roles="ROLE_USER">
                                <span class="text-truncate text-truncate-md opacity-80">
                                    <b style="float: right;">${g.formatNumber(format: "###,##0", number: user?.indiceConfianza , maxFractionDigits: 1) } <span><i class="fal fa-star"></i></span></b>
                                </span>
                            </sec:ifAnyGranted>
                        </div>
                    </div>
                </div>
                <div class="dropdown-divider m-0"></div>
                <a href="${createLink(controller: 'user', action: 'show', id: user?.id )}" class="dropdown-item">
                    <span data-i18n="drpdwn.settings">Mi perfil</span>
                </a>
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                <div class="dropdown-divider m-0"></div>
                <a href="${createLink(controller: 'configuracionEmpresa', action: 'configuracionEmpresa')}" class="dropdown-item">
                    <span data-i18n="drpdwn.settings">Configuraciones</span>
                </a>
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles="ROLE_USER">
                    <div class="dropdown-divider m-0"></div>
                    <a href="${createLink(controller: 'ubicacionUser', action: 'index')}" class="dropdown-item">
                        <span data-i18n="drpdwn.settings">Mis direcciones</span>
                    </a>
                </sec:ifAnyGranted>

                <div class="dropdown-divider m-0 hidden-sm-down"></div>

                <a href="#" class="dropdown-item hidden-sm-down" data-action="app-fullscreen">
                    <span data-i18n="drpdwn.fullscreen">Fullscreen</span>
                    <i class="float-right text-muted fw-n">F11</i>
                </a>

                <div class="dropdown-divider m-0"></div>
                <a class="dropdown-item fw-500 pt-3 pb-3" href="${createLink(controller: 'logout', action: '')}">
                    <span data-i18n="drpdwn.page-logout">Salir</span>
                </a>
            </div>
        </div>

    </div>


%{--    <sec:ifAnyGranted roles="ROLE_USER">--}%
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
%{--                        coords =  {--}%
%{--                            lng: ${ubicacionUser?.longitud},--}%
%{--                            lat: ${ubicacionUser?.latitud}--}%
%{--                        };--}%
%{--                        </g:if>--}%
%{--                        <g:else>--}%
%{--                        coords =  {--}%
%{--                            lng: position.coords.longitude,--}%
%{--                            lat: position.coords.latitude--}%
%{--                        };--}%
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
%{--                        }--}%

%{--                    },function(error){console.log(error);});--}%
%{--            }--}%
%{--        </script>--}%
%{--    </sec:ifAnyGranted>--}%
<!--Start of Tawk.to Script-->
%{--    <script type="text/javascript">--}%
%{--        var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();--}%
%{--        (function(){--}%
%{--            var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];--}%
%{--            s1.async=true;--}%
%{--            s1.src='https://embed.tawk.to/60d27cda65b7290ac637612f/1f8r3fdk6';--}%
%{--            s1.charset='UTF-8';--}%
%{--            s1.setAttribute('crossorigin','*');--}%
%{--            s0.parentNode.insertBefore(s1,s0);--}%
%{--        })();--}%
%{--    </script>--}%
    <!--End of Tawk.to Script-->
</header>
%{--<sec:ifAnyGranted roles="ROLE_USER">--}%
%{--    <g:render template="/ubicacionUser/ubicacionConsulta"/>--}%
%{--</sec:ifAnyGranted>--}%

<!-- END Page Header -->
