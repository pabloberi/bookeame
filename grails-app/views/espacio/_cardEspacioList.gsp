<div class="card-deck" >
    <g:each in="${espacioList}" status="i" var="espacio">
        <div class="carta col-xs-12 col-sm-6 col-md-4 col-lg-4 col-xl-3" style="margin-bottom: 2em;" value="${espacio?.tipoEspacio?.id}">
            <div class="card">
                <g:if test="${espacio?.foto}">
                    <asset:image src="/imagenes/espacios/${espacio?.id}/${espacio?.foto}" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                </g:if>
                <g:else>
                    <asset:image src="/imagenes/imagenNula.png" alt="" style="width:auto; height: auto; max-height: 15em; max-width: 100%"/>
                </g:else>

                <div class="w-100 bg-fusion-50 rounded-top" style="width: 25em;" >
                    %{--                                        bg-fusion-50--}%
                </div>
                <div class="card-body">
                    <h5 class="card-title">${espacio?.nombre}  <b style="float: right;">${g.formatNumber(format: "###,##0", number: espacio?.notaUsuarios , maxFractionDigits: 1) } <span><i class="fal fa-star"></i></span></b></h5>
                    <p><b>Capacidad:</b> ${espacio?.capacidad} Personas</p>
                    <p class="card-text">${espacio.descripcion}</p>
                </div>
                <div class="card-footer">
                    <g:if test="${espacio?.tieneModulos }">
                    <div class="btn-group btn-group-sm" style="float: right;">
                        <a href="${createLink(controller: 'reserva', action: 'selectServicio', id: espacio?.id)}" class="btn btn-info btn-sm" title="Crear Reserva"><i class="fal fa-calendar-alt"></i></a>
                    </div>
                    </g:if>
                    <g:else>
                        <a href="#" class="btn btn-secondary btn-sm" title="Calendario No Disponible" disabled=""><i class="fal fa-ban"></i></a>
                    </g:else>
                </div>
            </div>
        </div>
    </g:each>
</div>
