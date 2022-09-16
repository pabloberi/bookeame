<g:form method="POST" controller="reserva" action="disponible">
%{--    <div class="form-group row">--}%
%{--        <div class="col-sm-12 col-md-12 col-lg-12 pr-1">--}%
%{--            <label class="col-xl-12 form-label" for="motivo">Motivo</label>--}%
%{--            <g:select name="motivo" id="motivo" class="form-control select2" style="width: 100%;" optionKey="id"  from="" noSelection="['':'- Seleccione Motivo -']" />--}%
%{--        </div>--}%
%{--        <br>--}%
    </div>
%{--    <g:hiddenField name="userId" id="userId" value="${userSelect?.id}"/>--}%
    <g:hiddenField name="reservaId" id="reservaId" value="${reservaId}"/>
%{--    <g:hiddenField name="fechaReserva" id="fechaReserva" value="${fechaReserva}"/>--}%

    <div style="float: right;">
%{--        <a href="${createLink(controller:'reserva', action: 'noDisponible', params: [userId: userSelect?.id , moduloId: modulo?.id, fechaReserva: fechaReserva] ) }" >--}%
            <button type="submit" class="btn btn-primary">Habilitar módulo</button>
%{--        </a>--}%
    </div>
</g:form>