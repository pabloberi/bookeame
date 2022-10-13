<%@ page import="ubicacion.UbicacionUser; gestion.General" %>
<div class="modal fade" id="ubicacionConsulta">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Mi ubicacion</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true"><i class="fal fa-times"></i></span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning" role="alert">
                    <strong>Información.</strong> Esta ubicacion la obtenemos de tu libreta de direcciones o de tu dispositivo. ¿Es correcta?
                </div>
                <br>
                <div class="container">
                    <div id="map" class="card-img-top" style="width:100%;height: 300px;"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary" class="close" data-dismiss="modal">Si</button>
                <a href="${createLink(controller: 'ubicacionUser', action: 'create')}" class="btn btn-secondary">No, es otra.</a>
            </div>
        </div>
    </div>
</div>
