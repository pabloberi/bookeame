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
                                <g:hiddenField name="moduloId" id="moduloId" value=""/>
                                <g:hiddenField name="fechaReservaHidden" id="fechaReservaHidden" value=""/>
                                <g:hiddenField name="id_reserva" id="id_reserva" value=""/>
%{--                                <g:set var="fechaReservaValue" id="fechaReservaHidden" value=""/>--}%
                                <div class="panel-container show">
                                    <div class="panel-content">
                                        <table class="table">
                                            <tbody>
                                            <tr class="prop">
                                                <td valign="top" class="bg-success-500 name">Datos Módulo</td>
                                                <td valign="top" class="bg-success-500 name">

                                                    <div class="form-check form-check-inline" id="noDisponible">
                                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox1" value="option1" onchange="marcarNoDisponible();">
                                                        <label class="form-check-label" for="inlineCheckbox1">Marcar como no disponible</label>
                                                    </div>
                                                    <div class="form-check form-check-inline" id="disponible" style="display: none;">
                                                        <input class="form-check-input" type="checkbox" id="inlineCheckbox2" value="option1" onchange="marcarDisponible();">
                                                        <label class="form-check-label" for="inlineCheckbox2">Marcar como disponible</label>
                                                    </div>
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
    function buscarCliente(valor) {
        $('#inputBuscador').attr('disabled', true);
        $('#inputBuscador').blur();
        $('#correo').html('<center> <i class="fal fa-spinner fa-pulse fa-3x fa-fw"></i></center>')
        var moduloId = document.getElementById('moduloId').value;
        var fechaReserva = document.getElementById('fechaReservaHidden').value;
        if( valor.length >= 4 ) {
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'user', action: 'busquedaInteligenteAdmin')}',
                data: {
                    valor: valor,
                    roleString: "ROLE_USER",
                    moduloId: moduloId,
                    fechaReserva: fechaReserva
                },
                success: function (data, textStatus) {
                    $('#correo').html(data);
                    $('#inputBuscador').attr('disabled', false);
                    $('#inputBuscador').focus();
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                    $('#inputBuscador').attr('disabled', false);
                    $('#inputBuscador').focus();
                }
            });
        }else{
            $('#correo').html('');
            $('#inputBuscador').attr('disabled', false);
            $('#inputBuscador').focus();
        }
    }

    function marcarNoDisponible() {
        var check = document.getElementById('inlineCheckbox1');
        if( check.checked ){
            var moduloId = document.getElementById('moduloId').value;
            var fechaReserva = document.getElementById('fechaReservaHidden').value;
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'reserva', action: 'marcarNoDisponible')}',
                data: {
                    moduloId: moduloId,
                    fechaReserva: fechaReserva
                },
                success: function (data, textStatus) {
                    $('#opciones').html(data);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'reserva', action: 'buscarCliente')}',
                success: function (data, textStatus) {
                    $('#opciones').html(data);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }
    }

    function marcarDisponible() {
        var check = document.getElementById('inlineCheckbox2');
        if( check.checked ){
            var reservaId = document.getElementById('id_reserva').value;
            // var fechaReserva = document.getElementById('fechaReservaHidden').value;
            $.ajax({
                type: 'POST',
                url: '${g.createLink(controller: 'reserva', action: 'marcarDisponible')}',
                data: {
                    reservaId: reservaId
                },
                success: function (data, textStatus) {
                    $('#opciones').html(data);
                }, error: function (XMLHttpRequest, textStatus, errorThrown) {
                }
            });
        }else{
            $('#opciones').html("");
        }
    }

    function sleep(milisegundos) {
        var comienzo = new Date().getTime();
        while (true) {
            if ((new Date().getTime() - comienzo) > milisegundos)
                break;
        }
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
            timeZone: 'UTC',
            firstDay: 1,
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
                            usuario: "${reserva?.usuario?.nombre ? reserva?.usuario?.nombre ?: '' + " " + reserva?.usuario?.apellidoPaterno  ?: '' : reserva?.usuario?.username}",
                            reservaId: ${reserva?.id},
                            start: '${reserva?.fechaReserva?.toString().substring(0,10)}T${reserva?.horaInicio}:00',
                            end: '${reserva?.fechaReserva?.toString().substring(0,10)}T${reserva?.horaTermino}:00',
                            description: "reserva",
                            %{--modulo: ${modulo?.id},--}%
                            horaInicio: "${reserva?.horaInicio}",
                            horaTermino: "${reserva?.horaTermino}",
                            fechaReserva: "<g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/>",
                            valor: "$ ${reserva?.valor} .-",
                            urlDelete: "${createLink(controller: 'reserva', action: reserva?.tipoReserva?.id != 2 ? 'eliminarReserva' : 'declaracionEliminacionPrepago', id: reserva?.id)}",
                            urlFicha: "${createLink(controller: 'reserva', action: 'show', id: reserva?.id)}",
                        </g:if>
                        <g:else>
                            title: "No Disponible",
                            className: "bg-orange border-info text-white",
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
                $('#fechaReservaHidden').val(info.event.extendedProps.fechaReserva)
                $('#valorReserva').text(info.event.extendedProps.valor)
                if( info.event.extendedProps.usuario ) {
                    $('#usuario').text(info.event.extendedProps.usuario)
                    $('#usuarioFila').removeAttr("hidden");
                    $('#buscarUser').attr("hidden",true);
                }else{
                    var modulo = document.getElementById("moduloId");
                    modulo.value = info.event.extendedProps.modulo;
                    var fecha = document.getElementById("fechaReservaHidden");
                    fecha.value = info.event.extendedProps.fechaReserva;
                    $('#usuarioFila').attr("hidden",true);
                    $('#buscarUser').removeAttr("hidden");
                }
                if( info.event.title=== 'No Disponible'){
                    $('#noDisponible').css("display","none");
                    $('#disponible').css("display","block");
                    $('#botonEliminar').hide();
                    // $('#inlineCheckbox2').css("display","inline-block");
                }else{
                    if(info.event.title=== 'Reservado'){
                        $('#noDisponible').css("display","none");
                        $('#disponible').css("display","none");
                        $('#botonEliminar').show();
                        $('#linkEliminar').attr('href', info.event.extendedProps.urlDelete);
                        $('#verFicha').attr('href', info.event.extendedProps.urlFicha);
                    }else{
                        $('#noDisponible').css("display","block");
                        $('#disponible').css("display","none");
                        $('#botonEliminar').hide();
                    }
                    // $('#inlineCheckbox2').css("display","none");
                }
                // $('#calendarModal .js-event-url').attr('href',info.event.url);
                $('#calendarModal').modal();
                // console.log(info.event.className);
                // console.log("texto: "+info.event.extendedProps.kiene);
                // console.log(info.event.title);
                // console.log("descripcion: "+info.event.extendedProps.description);
                // console.log("url: "+info.event.url);
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
