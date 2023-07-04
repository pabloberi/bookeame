<%@ page import="reserva.Reserva" %>

<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="dashboard" />
    <g:set var="entityName" value="${message(code: 'espacio.label', default: 'Espacio')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>
</head>
<body>
<asset:stylesheet src="miscellaneous/fullcalendar/fullcalendar.bundle.css"/>
<asset:stylesheet src="app.bundle.css"/>

<asset:stylesheet src="miscellaneous/jqvmap/jqvmap.bundle.css"/>
<asset:stylesheet src="/formplugins/bootstrap-datepicker/bootstrap-datepicker.css"/>


<div style="margin-bottom: 2em;">
    <a href="${createLink(controller: 'reserva', action: 'reservaPlanificada', id: espacio?.id)}"><button class="btn btn-success" type="button">Reservas Masivas</button></a>
</div>
<div id="panel-7" class="panel">
    <div class="panel-hdr">
        <h2>
            Reserva <span class="fw-300"><i>${espacio?.nombre}</i></span>
        </h2>
        <div class="panel-toolbar">
            <button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
            <button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
            <button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
        </div>
    </div>
    <div class="panel-container show">
        <div class="panel-content row">
            <div class="col-xl-2"></div>
            <div id="calendar" class="col-xl-8"></div>
            <div class="col-xl-2"></div>
            <!-- Modal : TODO -->
            <div class="modal fade" id="calendarModal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h4 class="modal-title"><span class="js-event-title d-inline-block"></span></h4>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true"><i class="fal fa-times"></i></span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="panel-container show">
                                <div class="panel-content">
                                    <table class="table">
                                        <tbody>
                                        <tr class="prop">
                                            <td valign="top" class="bg-success-500 name">Datos Módulo</td>
                                            <td valign="top" class="bg-success-500 name">

%{--                                                <div class="form-check form-check-inline" id="noDisponible">--}%
%{--                                                    <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1" onchange="marcarNoDisponible();">--}%
%{--                                                    <label class="form-check-label" for="inlineCheckbox1">Marcar como no disponible</label>--}%
%{--                                                </div>--}%
%{--                                                <div class="form-check form-check-inline" id="disponible" style="display: none;">--}%
%{--                                                    <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="option1" onchange="marcarDisponible();">--}%
%{--                                                    <label class="form-check-label" for="inlineCheckbox2">Marcar como disponible</label>--}%
%{--                                                </div>--}%
                                            </td>
                                        </tr>
                                        <tr class="prop">
                                            <td valign="top" class="name"><g:message code="espacio.tiempo.label" default="Fecha" /></td>
                                            <td id="fechaReserva" valign="top" class="value"></td>
                                        </tr>
                                        <tr class="prop">
                                            <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Inicio" /></td>
                                            <td id="horaInicio" valign="top" class="value"></td>
                                        </tr>
                                        <tr class="prop">
                                            <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Término" /></td>
                                            <td id="horaTermino" valign="top" class="value"></td>
                                        </tr>
                                        <tr class="prop">
                                            <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Valor" /></td>
                                            <td id="valorReserva" valign="top" class="value"></td>
                                        </tr>
                                        <tr class="prop" id="usuarioFila" hidden>
                                            <td valign="top" class="name"><g:message code="espacio.tipoEspacio.label" default="Usuario" /></td>
                                            <td id="usuario" valign="top" class="value"></td>
                                        </tr>
                                        </tbody>
                                    </table>
                                    <div id="botonEliminar" style="float: right; display: none;">
                                        <a href="#" id="verFicha"><button class="btn btn-info btn-md" > Ver más </button></a>
                                        <a href="#" id="linkEliminar"><button class="btn btn-danger btn-md" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"> Eliminar </button></a>
                                    </div>
                                    <div id="opciones">
                                        <table class="table" hidden id="buscarUser" >
                                            <tbody>
                                            <tr class="prop">
                                                <td valign="top" class="bg-success-500 name">Reservar a  Cliente</td>
                                                <td valign="top" class="bg-success-500 name">
                                                    <div class="d-flex position-relative ml-auto " style="max-width: 15rem;">
                                                        <input id="inputBuscador" type="text" class="form-control bg-subtlelight pl-6" placeholder="Correo Usuario" onkeyup="buscarCliente(this.value)">
                                                        <i class="fal fa-search position-absolute pos-left fs-lg px-3 py-2 mt-1 text-black-50"></i>
                                                    </div>
                                                </td>
                                            </tr>
                                            </tbody>
                                        </table>
                                        <div id="correo"></div>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                        </div>
                    </div>
                </div>
            </div>
            <!-- Modal end -->

        </div>

    </div>
</div>
<asset:javascript src="miscellaneous/fullcalendar/fullcalendar.bundle.js"/>
<asset:javascript src="dependency/moment/moment.js"/>


<script>
    var todayDate = moment().startOf('day');
    var YM = todayDate.format('YYYY-MM');
    var YESTERDAY = todayDate.clone().subtract(1, 'day').format('YYYY-MM-DD');
    var TODAY = todayDate.format('YYYY-MM-DD');
    var TOMORROW = todayDate.clone().add(1, 'day').format('YYYY-MM-DD');

    var vista = 'listWeek';
    if( window.screen.width > 750 ){
        vista = 'dayGridWeek';
    }

    document.addEventListener('DOMContentLoaded', function () {
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            plugins: ['dayGrid', 'list', 'timeGrid', 'interaction', 'bootstrap'],
            themeSystem: 'bootstrap',
            timeZone: 'UTC',
            firstDay: 1,
            defaultView: vista, // 'dayGridWeek', 'timeGridDay', 'listWeek' .
            dayGrid:{
                day: false
            },
            buttonText: {
                today:    'Hoy',
                month:    'Mes',
                week:     'Semana',
                day:      'Día',
                list:     'Lista'
            },
            eventTimeFormat: {
                hour: 'numeric',
                minute: '2-digit',
                meridiem: 'short'
            },
            navLinks: true,
            header: {
                left: 'prev,next today addEventButton',
                center: 'title',
                right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
            },
            footer: {
                left:   '',
                center: '',
                right:  ''
            },
            locale: 'es',
            editable: false,
            eventLimit: true,
            views: {
                sevenDays: {
                    type: 'agenda',
                    buttonText: '7 Days',
                    visibleRange: function(currentDate) {
                        return {
                            start: currentDate.clone().subtract(2, 'days'),
                            end: currentDate.clone().add(5, 'days'),
                            start: todayDate,
                            end: todayDate.add(7,'days'),
                        };
                    },
                    duration: {days: 7},
                    dateIncrement: { days: 1 },
                },

            },

            events: [
                <g:each in="${eventoList}" status="r" var="evento">
                    {
                        title: "${evento?.getTitle() ?: 'n/A'}",
                        className: "${evento?.getClassName() ?: 'n/A'}",
                        start: '${evento?.getStart() ?: 'n/A'}',
                        end: '${evento?.getEnd() ?: 'n/A'}',
                        description: "${evento?.getDescription() ?: 'n/A'}",
                        horaInicio: "${evento?.getHoraInicio() ?: 'n/A'}",
                        horaTermino: "${evento?.getHoraTermino() ?: 'n/A'}",
                        fechaReserva: "${evento?.getFechaReserva() ?: 'n/A'}",
                        valor: "${evento?.getValor() ?: 'n/A'}",
                        modulo: "${evento?.getModulo() ?: 'n/A' }",

                        <sec:ifAnyGranted roles="ROLE_ADMIN">
                            usuario: "${evento?.getUsuario() ?: 'n/A'}",
                            reservaId: '${evento?.getReservaId() ?: 'n/A'}',
                            urlDelete: "${evento?.getUrlDelete() ?: 'n/A'}",
                            urlFicha: "${evento?.getUrlFicha() ?: 'n/A'}",
                        </sec:ifAnyGranted>
                    },
                </g:each>
            ],

            eventClick:  function(info) {
                <sec:ifAnyGranted roles="ROLE_USER">
                    if(info.event.title === 'Disponible'){
                        var params = "fecha=" + info.event.extendedProps.fechaReserva + "&moduloId=" + info.event.extendedProps.modulo;
                        window.location.href = "${createLink(controller: 'reserva', action: 'create', id: espacio?.id)}?" +params ;
                    }
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles="ROLE_ADMIN">
                    if(info.event.title === 'Disponible'){
                        var params = "fecha=" + info.event.extendedProps.fechaReserva + "&moduloId=" + info.event.extendedProps.modulo;
                        window.location.href = "${createLink(controller: 'reserva', action: 'create', id: espacio?.id)}?" +params ;
                    }else{
                        if( info.event.title=== 'Reservado' ){
                            $('#calendarModal .modal-title .js-event-title').text(info.event.title);
                            $('#calendarModal .js-event-description').text(info.event.extendedProps.description);
                            $('#horaInicio').text(info.event.extendedProps.horaInicio)
                            $('#horaTermino').text(info.event.extendedProps.horaTermino)
                            $('#fechaReserva').text(info.event.extendedProps.fechaReserva)
                            $('#valorReserva').text(info.event.extendedProps.valor)

                            $('#usuario').text(info.event.extendedProps.usuario)
                            $('#usuarioFila').removeAttr("hidden");
                            $('#buscarUser').attr("hidden",true);

                            $('#botonEliminar').show();
                            $('#linkEliminar').attr('href', info.event.extendedProps.urlDelete);
                            $('#verFicha').attr('href', info.event.extendedProps.urlFicha);
                        }

                        $('#calendarModal').modal();
                     }
                </sec:ifAnyGranted>
            },
            viewRender: function(view) {
                localStorage.setItem('calendarDefaultView',view.name);
                $('.fc-toolbar .btn-primary').removeClass('btn-primary').addClass('btn-outline-secondary');
            },

        });
        calendar.render();
    });

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

</script>
</body>
</html>
