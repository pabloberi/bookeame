    <div class="panel-container show">
            <g:if test="${registroPagoReserva}">
                <table class="table">
                    <tbody>
                        <tr class="prop">
                            <td valign="top" class="name">Pago Realizado</td>
                            <td valign="top" class="value">$ ${fieldValue(bean: registroPagoReserva, field: "monto")} .-</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Concepto</td>
                            <td valign="top" class="value">${fieldValue(bean: registroPagoReserva, field: "concepto")}</td>
                        </tr>
                        <tr class="prop">
                            <td valign="top" class="name">Comprobante Enviado</td>
                            <td valign="top" class="value">${formatBoolean(boolean: reserva?.envioComprobante, true: "Si", false: "No") ?: "No"}</td>
                        </tr>
                    </tbody>
                </table>
                <div class="col-md-12 mt-2">
                    <button name="editRegistroPago" data-toggle="modal" data-target="#modalEditPagoReserva"
                            id="editRegistroPago" type="submit" class="btn btn-success btn-block btn-md mt-12" value="1" >
                        Editar Registro
                    </button>
                </div>
                <g:render template="modalEditPagoReserva" />
            </g:if>
            <g:else>
                <g:form method="POST" controller="reserva" action="ingresarPago" id="${reserva?.id}">
                    <div class="form-group">
                        <label class="form-label" for="valorFinal">Ingrese Pago</label>
                        <div class="input-group">
                            <div class="input-group-append">
                                <span class="input-group-text">$</span>
                            </div>
                            <g:field type="number" id="valorFinal" name="valorFinal" class="form-control" placeholder="Ingrese Pago" value="${reserva?.valor}"/>
                        </div>
                    </div>

                    <div class="col-md-12 mt-2">
                        <button name="registroPago"
                                id="registroPago" type="submit" class="btn btn-success btn-block btn-md mt-12 mb-2" value="1" >
                               Registrar
                        </button>
                    </div>
                </g:form>
            </g:else>

    </div>

<g:if test="${ registroPagoReserva && reserva?.envioComprobante != true }">
    <div class="col-md-12 mt-2">
        <a href="${createLink(controller: 'reserva', action: 'enviarComprobante', id: reserva?.id)}"
           onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
            <button name="enviarComprobante"
                    id="enviarComprobante" type="button" class="btn btn-outline-primary btn-block btn-md mt-12" >
                <span class="fal fa-envelope mr-1"></span>
                Enviar comprobante al cliente
            </button>
        </a>
    </div>
</g:if>
