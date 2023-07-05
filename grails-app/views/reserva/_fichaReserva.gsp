
        <div class="panel-container show">
            <table class="table">
                <tbody>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.valor.label" default="Código" /></td>
                    <td valign="top" class="value">${fieldValue(bean: reserva, field: "codigo")}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.fechaReserva.label" default="Fecha de Reserva" /></td>
                    <td valign="top" class="value"><g:formatDate type="date" style="FULL" date="${reserva?.fechaReserva}"/></td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.fechaReserva.label" default="Horario" /></td>
                    <td valign="top" class="value">${reserva?.horaInicio} - ${reserva?.horaTermino}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.valor.label" default="Valor" /></td>
                    <td valign="top" class="value">$ ${fieldValue(bean: reserva, field: "valor")} .-</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.espacio.label" default="Espacio" /></td>
                    <td valign="top" class="value">${fieldValue(bean: reserva, field: "espacio")}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.estadoReserva.label" default="Estado Reserva" /></td>
                    <td valign="top" class="value">${fieldValue(bean: reserva, field: "estadoReserva")}</td>
                </tr>
                <tr class="prop">
                    <td valign="top" class="name"><g:message code="reserva.tipoReserva.label" default="Tipo Reserva" /></td>
                    <td valign="top" class="value">${fieldValue(bean: reserva, field: "tipoReserva")}</td>
                </tr>
                <sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_ADMIN">
                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="reserva.usuario.label" default="Usuario" /></td>
                        <td valign="top" class="value">${fieldValue(bean: reserva, field: "usuario")}</td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="reserva.usuario.label" default="Celular Usuario" /></td>
                        <td valign="top" class="value">${reserva?.usuario?.celular}</td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="reserva.usuario.label" default="Nombre" /></td>
                        <td valign="top" class="value">${reserva?.usuario?.nombre} ${reserva?.usuario?.apellidoPaterno}</td>
                    </tr>
                </sec:ifAnyGranted>
                <sec:ifAnyGranted roles="ROLE_SUPERUSER, ROLE_USER">
                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="mapa.enabled.label" default="Dirección" /></td>
                        <td valign="top" class="value" >${reserva?.espacio?.direccion}, ${reserva?.espacio?.comuna}, ${reserva?.espacio?.comuna?.provincia?.region}</td>
                    </tr>
                    <tr class="prop">
                        <td valign="top" class="name"><g:message code="mapa.enabled.label" default="Contacto Empresa" /></td>
                        <td valign="top" class="value" >${configuracion?.fono ?: 'N/A'}</td>
                    </tr>

                </sec:ifAnyGranted>
                </tbody>
            </table>
            <g:render template="botoneraAdmin" model="[ hoy: hoy,
                                                        reserva: reserva,
                                                        configuracion: configuracion,
                                                        esReservaVigente: esReservaVigente,
                                                        esReservaHistorica: esReservaHistorica,
                                                        esReservaPosPagoPendiente: esReservaPosPagoPendiente
            ]"/>
            <g:render template="botoneraUser" model="[ hoy: hoy,
                                                       reserva: reserva,
                                                       configuracion: configuracion,
                                                       puedeCancelar: puedeCancelar,
                                                       puedeReagendar: puedeReagendar
            ]"/>
            <g:render template="reagendar" model="[reserva: reserva, configuracion: configuracion]"/>
        </div>
