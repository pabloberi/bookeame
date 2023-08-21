<%@ page import="evaluacion.EvaluacionToUser" %>
<g:form method="POST" controller="reserva" action="ingresarPago" id="${reserva?.id}">

    <div class="panel-container show">
        <g:if test="${reserva?.tipoReserva?.id == 1 || reserva?.tipoReserva?.id == 3}">
                <div class="form-group">
                    <label class="form-label" for="valorFinal">Ingrese Pago</label>
                    <div class="input-group">
                        <div class="input-group-append">
                            <span class="input-group-text">$</span>
                        </div>
                        <g:field type="number" id="valorFinal" name="valorFinal" class="form-control" placeholder="Ingrese Pago" value="${reserva?.valorFinal}"/>
                    </div>
                </div>
        </g:if>
        <g:if test="${reserva?.tipoReserva?.id == 2}">
            <table class="table">
                <tbody>
                    <tr class="prop">
                        <td valign="top" class="name">Pago Realizado</td>
                        <td valign="top" class="value">${fieldValue(bean: reserva, field: "valorFinal")}</td>
                    </tr>
                </tbody>
            </table>
        </g:if>
    </div>

    <div class="col-md-12 mt-4">
        <g:if test="${ reserva?.tipoReserva?.id != 2 }">
            <button name="registroPago"
                    id="registroPago" type="submit" class="btn btn-success btn-block btn-md mt-12 mb-2" value="1" >
                Actualizar
            </button>
        </g:if>
        <g:if test="${ reserva?.valorFinal && reserva?.envioComprobante != true }">
            <a href="${createLink(controller: 'reserva', action: 'enviarComprobante', id: reserva?.id)}"
               onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');">
                <button name="enviarComprobante"
                        id="enviarComprobante" type="button" class="btn btn-outline-primary btn-block btn-md mt-12" >
                    <span class="fal fa-envelope mr-1"></span>
                    Enviar comprobante al cliente
                </button>
            </a>
        </g:if>
    </div>

</g:form>
