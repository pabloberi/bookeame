<%@ page import="evaluacion.EvaluacionToEspacio; evaluacion.EvaluacionToUser" %>
        <div class="modal fade" id="modalEvaluacionUser${reserva?.id}" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Tu opinión nos importa</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true"><i class="fal fa-times"></i></span>
                        </button>
                    </div>
                    <g:form method="POST" controller="reserva" action="evaluacionEspacio" id="${reserva?.id}">
                        <div class="modal-body">
                            <div class="panel-container show">
                                <div class="panel-content">
                                    <h6>Queremos saber como ha sido tu experiencia con el espacio ${reserva?.espacio} el día <g:formatDate format="dd-MM-yyyy" date="${reserva?.fechaReserva}"/> </h6>
                                    <div class="frame-wrap">
                                        <div class="form-group row">
                                            <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                                <label class="col-xl-12 form-label" for="notaEspacio">Nota</label>
                                                <g:select name="notaEspacio" id="notaEspacio${reserva?.id}" class="form-control select2" style="width: 100%;" optionKey="id" required="" from="${EvaluacionToEspacio.list('sort': "nota" , order: 'asc')}" noSelection="['':'- Seleccione Nota -']" />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <div class="col-sm-12 col-md-12 col-lg-12 pr-1">
                                                <label class="col-xl-12 form-label" for="comentarioEspacio">Comentario</label>
                                                <g:field type="text" id="comentarioEspacio${reserva?.id}" name="comentarioEspacio" class="form-control" placeholder="Opcional"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="submit" type="button" class="btn btn-primary">Enviar</button>
                        </div>
                    </g:form>

                </div>
            </div>
        </div>



