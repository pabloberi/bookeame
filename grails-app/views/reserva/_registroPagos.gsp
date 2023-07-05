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

    <div class="panel-container show">
        <div class="form-group mt-5">
            <h5>Tu opinión nos importa</h5>
            <h6>Queremos saber como ha sido tu experiencia con el usuario ${reserva?.usuario} el día <g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/> </h6>
        </div>

        <div class="form-group">
            <label class="form-label" for="notaUser">Califica al usuario</label>
            <div class="input-group">
                <g:select name="notaUser" id="notaUser" class="form-control select2" style="width: 100%;" optionKey="id"
                          from="${EvaluacionToUser.list('sort': "nota" , order: 'asc')}" noSelection="['':'- Seleccione Nota -']"
                value="${reserva?.evaluacion?.evaluacionToUser?.id}"/>
            </div>
        </div>
        <div class="form-group row">
            <label class="col-xl-12 form-label" for="comentarioUser">Comentario</label>
            <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                <g:field type="text" id="comentarioUser" name="comentarioUser" class="form-control" placeholder="Opcional"/>
            </div>
        </div>

        <div class="col-md-12 ">
            <button name="registroPago"
                    id="registroPago" type="submit" class="btn btn-success btn-block btn-md mt-12" value="1" >
                Actualizar
            </button>
        </div>
    </div>

</g:form>
