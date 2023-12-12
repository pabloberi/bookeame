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

                <div class="modal fade" id="calendarModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title"><span class="js-event-title d-inline-block"></span></h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true"><i class="fal fa-times"></i></span>
                                </button>
                            </div>
                            <g:form method="POST" controller="reserva" action="reservaPrepago">
                            <div class="modal-body">
                                <g:hiddenField name="moduloId" id="moduloId" value=""/>
                                <g:hiddenField name="espacioId" id="espacioId" value="${espacio?.id}"/>
                                <g:hiddenField name="fechaReservaHidden" id="fechaReservaHidden" value=""/>
                                <div class="panel-container show">
                                    <div class="panel-content">
                                        <table class="table">
                                            <tbody>
                                            <tr class="prop">
                                                <td valign="top" class="bg-success-500 name">Datos Módulo</td>
                                                <td valign="top" class="bg-success-500 name"></td>
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
                                            <tr class="prop">
                                                <td valign="top" class="name"><g:message code="espacio.capacidad.label" default="Dirección" /></td>
                                                <td id="direccion" valign="top" class="value">${espacio?.direccion}, ${espacio?.comuna}, ${espacio?.comuna?.provincia?.region}</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            <div class="container">
                                <u><h4>Reserva Ahora</h4></u>
                                <br>
                                <g:if test="${configuracion?.tipoPago?.pospago}">
                                    <p style="font-size: 13px;"><b>Pago Presencial:</b>
                                        <br> Pagas al momento de asistir al compromiso y la reserva queda sujeta a la aprobación de la empresa
                                    </p>
                                    <br>
                                </g:if>
                                <g:if test="${configuracion?.tipoPago?.prepago}">
                                    <p style="font-size: 13px;"><b>Pago En Línea:</b><br>Pagas vía Internet y la reserva quedará aprobada inmediatamente.
                                        <br>
                                        <small>Este servicio TIENE un cargo adicional por costo operacional de $ <b id="comision"></b> .-</small>
                                    </p>
                                </g:if>
                                <g:if test="${configuracion?.tipoPago?.prepago == false && configuracion?.tipoPago?.pospago == false}">
                                    <p style="font-size: 13px;">Esta Empresa solo permite reservar llamando al <b>${configuracion?.fono}</b></p>
                                    <br>
                                </g:if>
                            </div>

                            <div class="modal-footer row">
                                <g:if test="${configuracion?.tipoPago?.prepago}">
                                    <button <%if(session['link'] != null ){ %> disabled="" <%}%> id="reservaPrepago" type="submit" class="btn btn-info" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">Pago En Línea</button>
                                </g:if>
                                <g:if test="${configuracion?.tipoPago?.pospago}">
                                   <a href="javascript: reservaPospago();" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');"><button <%if(session['link'] != null ){ %> disabled="" <%}%> id="reservaPospago" type="button" class="btn btn-outline-info" >Pago Presencial</button></a>
                                </g:if>
                            </div>
                            </g:form>
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
    function sleep(milisegundos) {
        var comienzo = new Date().getTime();
        while (true) {
            if ((new Date().getTime() - comienzo) > milisegundos)
                break;
        }
    }

    function reservaPospago() {
        var fechaReserva = document.getElementById("fechaReservaHidden").value;
        var moduloId = document.getElementById("moduloId").value;

        $.ajax({
            type: 'POST',
            url: '${g.createLink(controller: 'reserva', action: 'reservaPospago')}',
            data: {
                moduloId: moduloId,
                fechaReserva: fechaReserva,
                espacioId: ${espacio?.id}
            },
            success: function (data, textStatus) {
                window.location = "${createLink(controller: 'reserva', action: 'crearReservaUser', id: espacio?.id )}";
            }, error: function (XMLHttpRequest, textStatus, errorThrown) {
            }
        });
    }

    function reservaPrepago() {
        var fechaReserva = document.getElementById("fechaReservaHidden").value;
        var moduloId = document.getElementById("moduloId").value;

        $.ajax({
            type: 'POST',
            url: '${g.createLink(controller: 'reserva', action: 'reservaPrepago')}',
            data: {
                moduloId: moduloId,
                fechaReserva: fechaReserva,
                espacioId: ${espacio?.id}
            },
            success: function (data, textStatus) {
                window.location = data;
            }, error: function (XMLHttpRequest, textStatus, errorThrown) {
            }
        });
    }


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
            firstDay: 1,
            timeZone: 'UTC',
            defaultView: vista, // 'dayGridWeek', 'timeGridDay', 'listWeek' .
            // dateAlignment: "month", //week, month
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
                // left: 'prev,next today',
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
                <g:each in="${reservaList}" status="r" var="reserva">
                    {
                        <g:if test="${reserva?.disponible}">
                        title: "Reservado",
                        className: "bg-secondary border-info text-white",
                        usuario: "${reserva?.usuario?.username}",
                        reservaId: ${reserva?.id},
                        start: '${reserva?.fechaReserva?.toString().substring(0,10)}T${reserva?.horaInicio}:00',
                        end: '${reserva?.fechaReserva?.toString().substring(0,10)}T${reserva?.horaTermino}:00',
                        description: "reserva",
                        %{--modulo: ${modulo?.id},--}%
                        horaInicio: "${reserva?.horaInicio}",
                        horaTermino: "${reserva?.horaTermino}",
                        fechaReserva: "<g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/>",
                        valor: "$ ${reserva?.valor} .-",
                        </g:if>
                        <g:else>
                        title: "No disponible",
                        className: "bg-secondary border-info text-white",
                        usuario: "No aplica",
                        reservaId: ${reserva?.id},
                        start: '${reserva?.fechaReserva?.toString().substring(0,10)}T${reserva?.horaInicio}:00',
                        end: '${reserva?.fechaReserva?.toString().substring(0,10)}T${reserva?.horaTermino}:00',
                        description: "reserva",
                        %{--modulo: ${modulo?.id},--}%
                        horaInicio: "${reserva?.horaInicio}",
                        horaTermino: "${reserva?.horaTermino}",
                        fechaReserva: "<g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/>",
                        valor: "No aplica",
                        </g:else>

                    },
                </g:each>
                <g:if test="${reservaList.size() == 0}">
                    <g:each in="${moduloList}" status="i" var="modulo">
                        <g:each in="${dateList}" status="j" var="fecha">
                            <g:if test="${modulo?.dias.getProperty(fecha[1]) }" >
                                {
%{--                                    <g:if test="${ !reservaList.find{ it -> it?.horaInicio == modulo?.horaInicio && it?.horaTermino == modulo?.horaTermino && it?.fechaReserva == fecha[2] } }">--}%
                                        title: "Disponible",
                                        className: "bg-info border-info text-white",
                                        start: '${fecha[0]}T${modulo?.horaInicio}:00',
                                        end: '${fecha[0]}T${modulo?.horaTermino}:00',
                                        description: "reserva",
                                        modulo: ${modulo?.id},
                                        horaInicio: "${modulo?.horaInicio}",
                                        horaTermino: "${modulo?.horaTermino}",
                                        fechaReserva: "${fecha[3]}",
                                        valor: "$ ${modulo?.valor} .-",
                                        comision: '${ modulo?.costoComision }',
%{--                                    </g:if>--}%
                                },
                             </g:if>
                        </g:each>
                    </g:each>
                </g:if>
                <g:else>
                    <g:each in="${moduloList}" status="i" var="modulo">
                        <g:each in="${dateList}" status="j" var="fecha">
                            <g:if test="${modulo?.dias.getProperty(fecha[1]) }" >
                                {
                                    <g:if test="${ !reservaList.find{ it -> it?.horaInicio == modulo?.horaInicio && it?.horaTermino == modulo?.horaTermino && it?.fechaReserva == fecha[2] } }">
                                    title: "Disponible",
                                    className: "bg-info border-info text-white",
                                    start: '${fecha[0]}T${modulo?.horaInicio}:00',
                                    end: '${fecha[0]}T${modulo?.horaTermino}:00',
                                    description: "reserva",
                                    modulo: ${modulo?.id},
                                    horaInicio: "${modulo?.horaInicio}",
                                    horaTermino: "${modulo?.horaTermino}",
                                    fechaReserva: "${fecha[3]}",
                                    valor: "$ ${modulo?.valor} .-",
                                    comision: '${modulo?.costoComision }',
                                    </g:if>
                                },
                            </g:if>
                        </g:each>
                    </g:each>
                </g:else>
            ],

            eventClick:  function(info) {
                $('#calendarModal .modal-title .js-event-title').text(info.event.title);
                $('#calendarModal .js-event-description').text(info.event.extendedProps.description);
                $('#id_reserva').val(info.event.extendedProps.reservaId )
                $('#horaInicio').text(info.event.extendedProps.horaInicio)
                $('#horaTermino').text(info.event.extendedProps.horaTermino)
                $('#fechaReserva').text(info.event.extendedProps.fechaReserva)
                $('#valorReserva').text(info.event.extendedProps.valor)
                $('#comision').text(info.event.extendedProps.comision)
                if( !info.event.extendedProps.usuario ) {
                    var modulo = document.getElementById("moduloId");
                    modulo.value = info.event.extendedProps.modulo;
                    var fecha = document.getElementById("fechaReservaHidden");
                    fecha.value = info.event.extendedProps.fechaReserva;
                    $('#usuarioFila').attr("hidden",true);
                    $('#buscarUser').removeAttr("hidden");
                    $('#calendarModal').modal();
                }
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
