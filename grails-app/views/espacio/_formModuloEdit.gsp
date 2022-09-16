%{--<div id="panel-7" class="panel">--}%
	<asset:stylesheet src="formplugins/timepicker/css/bootstrap-timepicker.css"/>
	<asset:javascript src="formplugins/timepicker/js/bootstrap-timepicker.js"/>
%{--	<div class="panel-hdr">--}%
%{--		<h2>--}%
%{--			Módulo <span class="fw-300"><i>${modulo?.horaInicio ?: 'Nuevo'} </i></span>--}%
%{--		</h2>--}%
%{--		<div class="panel-toolbar">--}%
%{--			<button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>--}%
%{--			<button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>--}%
%{--			<button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>--}%
%{--		</div>--}%
%{--	</div>--}%
%{--	<div class="panel-container show">--}%
%{--		<div class="panel-content">--}%
<!-- Modal -->
<div id="modulo${modulo?.id}" class="modal fade" role="dialog">
	<div class="modal-dialog">

		<!-- Modal content-->
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">&times;</button>
%{--				<h4 class="modal-title">Modal Header</h4>--}%
			</div>
		<g:form method="POST" controller="modulo" action="editarModulo" id="${modulo?.id}" >
			<div class="modal-body">

%{--					<div class="form-group row">--}%
%{--						<div class="form-group  col-xs-12 col-sm-4 col-md-4 col-lg-4 col-xl-4">--}%
%{--							<label class="form-label">Hora Inicio</label>--}%
%{--							<div class="input-group date" >--}%
%{--								<g:field type="text" name="horaInicio" class="form-control datetime" readonly="" required="" value="${modulo?.horaInicio}"/>--}%
%{--								<div class="input-group-append">--}%
%{--									<span class="input-group-text"><i class="fal fa-clock"></i></span>--}%
%{--								</div>--}%
%{--							</div>--}%
%{--						</div>--}%

%{--						<div class="form-group col-xs-12 col-sm-4 col-md-4 col-lg-4 col-xl-4">--}%
%{--							<label class="form-label">Hora Término</label>--}%
%{--							<div class="input-group date" >--}%
%{--								<g:field name="horaTermino" type="text" class="form-control datetime" readonly="" required="" value="${modulo?.horaTermino}" />--}%
%{--								<div class="input-group-append">--}%
%{--									<span class="input-group-text"><i class="fal fa-clock"></i></span>--}%
%{--								</div>--}%
%{--							</div>--}%
%{--						</div>--}%
						<div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
							<label class="form-label">Hora Inicio</label>
							<div class="input-group date" >
								%{--							<g:select id="horaInicio" name="horaInicio" from="" class="form-control" readonly="" required="" value="${modulo?.horaInicio}"/>--}%
								<select id="horaInicio" name="horaInicio" class="form-control" >
									<% for (int i = 0; i < 24 ; i++) {%>
									<g:if test="${i < 10 }">
										<option value="0${i}" <%if( i == modulo?.horaInicio?.substring(0,2)?.toInteger() ){%> selected="selected" <%}%> >0${i}</option>
									</g:if>
									<g:else>
										<option value="${i}" <%if( i == modulo?.horaInicio?.substring(0,2)?.toInteger() ){%> selected="selected" <%}%> >${i}</option>
									</g:else>
									<%}%>
								</select>
								<div class="input-group-append">
									<span class="input-group-text">:</span>
								</div>
								%{--							<g:select id="minInicio" name="minInicio" from="" class="form-control" readonly="" required="" value="${modulo?.horaInicio}"/>--}%
								<select id="minInicio" name="minInicio" class="form-control" >
									<% for (int i = 0; i < 60 ; i++) {%>
									<g:if test="${i < 10 }">
										<option value="0${i}" <%if( i == modulo?.horaInicio?.substring(3,5)?.toInteger() ){%> selected="selected" <%}%> >0${i}</option>
									</g:if>
									<g:else>
										<option value="${i}" <%if( i == modulo?.horaInicio?.substring(3,5)?.toInteger() ){%> selected="selected" <%}%> >${i}</option>
									</g:else>
									<%}%>
								</select>
								<div class="input-group-append">
									<span class="input-group-text"><i class="fal fa-clock"></i></span>
								</div>
							</div>
						</div>

						<div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
							<label class="form-label">Hora Término</label>
							<div class="input-group date" >
								<select id="horaTermino" name="horaTermino" class="form-control">
									<% for (int i = 0; i < 24 ; i++) {%>
									<g:if test="${i < 10 }">
										<option value="0${i}" <%if( i == modulo?.horaTermino?.substring(0,2)?.toInteger() ){%> selected="selected" <%}%> >0${i}</option>
									</g:if>
									<g:else>
										<option value="${i}" <%if( i == modulo?.horaTermino?.substring(0,2)?.toInteger() ){%> selected="selected" <%}%> >${i}</option>
									</g:else>
									<%}%>
								</select>
								<div class="input-group-append"><span class="input-group-text">:</span></div>
								<select id="minTermino" name="minTermino" class="form-control" value="00" >
									<% for (int i = 0; i < 60 ; i++) {%>
									<g:if test="${i < 10 }">
										<option value="0${i}" <%if( i == modulo?.horaTermino?.substring(3,5)?.toInteger() ){%> selected="selected" <%}%> >0${i}</option>
									</g:if>
									<g:else>
										<option value="${i}" <%if( i == modulo?.horaTermino?.substring(3,5)?.toInteger() ){%> selected="selected" <%}%> >${i}</option>
									</g:else>
									<%}%>
								</select>
								<div class="input-group-append">
									<span class="input-group-text"><i class="fal fa-clock"></i></span>
								</div>
							</div>
						</div>

						<div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
							<label class="form-label">valor</label>
							<div class="input-group date" >
								<g:field name="valor" type="number" min="0" max="9999999" class="form-control" required="" value="${modulo?.valor}" onkeyup="this.value=Numeros(this.value)"/>
								<div class="input-group-append">
									<span class="input-group-text">$</span>
								</div>
							</div>
						</div>

						<div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
							<label class="form-label" >Días Habilitados</label>

							<div class="frame-wrap">

								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="lunes" id="lunes${modulo?.id}" <%if(modulo?.dias?.lunes) {%>checked=""<%}%> >
									<label class="custom-control-label" for="lunes${modulo?.id}">L</label>
								</div>
								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="martes" id="martes${modulo?.id}" <%if(modulo?.dias?.martes) {%>checked=""<%}%> >
									<label class="custom-control-label" for="martes${modulo?.id}">M</label>
								</div>
								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles${modulo?.id}" <%if(modulo?.dias?.miercoles) {%>checked=""<%}%> >
									<label class="custom-control-label" for="miercoles${modulo?.id}">M</label>
								</div>
								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="jueves" id="jueves${modulo?.id}" <%if(modulo?.dias?.jueves) {%>checked=""<%}%> >
									<label class="custom-control-label" for="jueves${modulo?.id}">J</label>
								</div>
								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="viernes" id="viernes${modulo?.id}" <%if(modulo?.dias?.viernes) {%>checked=""<%}%>>
									<label class="custom-control-label" for="viernes${modulo?.id}">V</label>
								</div>
								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="sabado" id="sabado${modulo?.id}" <%if(modulo?.dias?.sabado) {%>checked=""<%}%> >
									<label class="custom-control-label" for="sabado${modulo?.id}">S</label>
								</div>
								<div class="custom-control custom-checkbox custom-control-inline">
									<input type="checkbox" class="custom-control-input" name="domingo" id="domingo${modulo?.id}" <%if(modulo?.dias?.domingo) {%>checked=""<%}%> >
									<label class="custom-control-label" for="domingo${modulo?.id}">D</label>
								</div>

							</div>
						</div>

			</div>
			<div class="modal-footer">
				<div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
					<button href="#" type="submit" class="btn btn-info btn-sm" title="Guardar">Guardar</button>
					<a href="${createLink(controller: 'modulo', action: 'eliminarModulo', id: modulo?.id)}" class="btn btn-secondary btn-sm" title="Eliminar">Eliminar</a>
				</div>
			</div>
		</g:form>
		</div>

	</div>
</div>


%{--		</div>--}%
%{--	</div>--}%
%{--</div>--}%
<script>
	$(".datetime").timepicker({
		timeFormat: 'HH:mm',
		showMeridian:false
	});

	function Numeros(string){//Solo numeros
		var out = '';
		var filtro = '1234567890';//Caracteres validos

		for (var i=0; i<string.length; i++)
			if (filtro.indexOf(string.charAt(i)) != -1)
				out += string.charAt(i);
		return out;
	}
</script>