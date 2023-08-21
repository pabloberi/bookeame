<%@ page import="evaluacion.EvaluacionToUser" %>
<g:form method="POST" controller="reserva" action="registrarEvaluacion" id="${reserva?.id}">

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
            <button name="evaluacion"
                    id="evaluacion" type="submit" class="btn btn-success btn-block btn-md mt-12" value="1" >
                Actualizar
            </button>
        </div>
    </div>

</g:form>
