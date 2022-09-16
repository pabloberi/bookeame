<div class="panel-tag">
	<p>Está herramienta te permitirá crear los módulos que podrán reservar tus clientes de forma masiva.</p>
</div>

<div id="panel-7" class="panel">
	<asset:stylesheet src="formplugins/timepicker/css/bootstrap-timepicker.css"/>
	<asset:javascript src="formplugins/timepicker/js/bootstrap-timepicker.js"/>
	<div class="panel-hdr">
		<h2>
			Creación Masiva <span class="fw-300"><i>Módulos</i></span>
		</h2>
		<div class="panel-toolbar">
			<button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
			<button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
			<button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
		</div>
	</div>
	<div class="panel-container show">
		<div class="panel-content">
			<g:form method="POST" controller="modulo" action="crearMasivo" id="${espacio?.id}" >
				<div class="form-group row">
					<div class="form-group col-xs-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
						<label class="form-label">Inicio Jornada</label>
						<div class="input-group date" >
							%{--							<g:select id="horaInicio" name="horaInicio" from="" class="form-control" readonly="" required="" value="${modulo?.horaInicio}"/>--}%
							<select id="horaInicio" name="horaInicio" class="form-control" >
								<% for (int i = 0; i < 24 ; i++) {%>
								<g:if test="${i < 10 }">
									<option value="0${i}">0${i}</option>
								</g:if>
								<g:else>
									<option value="${i}">${i}</option>
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
									<option value="0${i}">0${i}</option>
								</g:if>
								<g:else>
									<option value="${i}">${i}</option>
								</g:else>
								<%}%>
							</select>
							<div class="input-group-append">
								<span class="input-group-text"><i class="fal fa-clock"></i></span>
							</div>
						</div>
					</div>

					<div class="form-group col-xs-12 col-sm-12 col-md-4 col-lg-4 col-xl-4">
						<label class="form-label">Término Jornada</label>
						<div class="input-group date" >
							%{--							<g:select id="horaInicio" name="horaInicio" from="" class="form-control" readonly="" required="" value="${modulo?.horaInicio}"/>--}%
							<select id="horaTermino" name="horaTermino" class="form-control" >
								<% for (int i = 0; i < 24 ; i++) {%>
								<g:if test="${i < 10 }">
									<option value="0${i}">0${i}</option>
								</g:if>
								<g:else>
									<option value="${i}">${i}</option>
								</g:else>
								<%}%>
							</select>
							<div class="input-group-append">
								<span class="input-group-text">:</span>
							</div>
							%{--							<g:select id="minInicio" name="minInicio" from="" class="form-control" readonly="" required="" value="${modulo?.horaInicio}"/>--}%
							<select id="minTermino" name="minTermino" class="form-control"  >
								<% for (int i = 0; i < 60 ; i++) {%>
								<g:if test="${i < 10 }">
									<option value="0${i}">0${i}</option>
								</g:if>
								<g:else>
									<option value="${i}">${i}</option>
								</g:else>
								<%}%>
							</select>
							<div class="input-group-append">
								<span class="input-group-text"><i class="fal fa-clock"></i></span>
							</div>
						</div>
					</div>

					<div class="form-group col-xs-12 col-sm-4 col-md-4 col-lg-4 col-xl-4">
						<label class="form-label">Duración Módulos</label>
						<div class="input-group date" >
							<g:field name="duracion" type="number" min="1" max="1440" class="form-control" required="" placeholder="Ingrese duración en minutos" onkeyup="this.value=Numeros(this.value)" value="${espacio?.tiempoArriendo}"/>
						</div>
					</div>

					<div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6 col-xl-6">
						<label class="form-label">Break Entre Módulos</label>
						<div class="input-group date" >
							<g:field name="tiempoMuerto" type="number" min="0" max="1440" class="form-control" required="" placeholder= "Ingrese break en minutos" onkeyup="this.value=Numeros(this.value)" />
						</div>
						<span class="help-block">
							Break, tiempo muerto o de descanso entre cada módulo. Si no tiene ingrese 0.
						</span>
					</div>

					<div class="form-group col-xs-12 col-sm-6 col-md-6 col-lg-6 col-xl-6">
						<label class="form-label">valor</label>
						<div class="input-group date" >
							<g:field name="valor" type="number" min="0" max="9999999" class="form-control" required="" value="${modulo?.valor}" placeholder="Ingrese el valor del arriendo" onkeyup="this.value=Numeros(this.value)" />
							<div class="input-group-append">
								<span class="input-group-text">$</span>
							</div>
						</div>
					</div>

					<div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-6 col-xl-6">
						<label class="form-label" >Días Habilitados</label>

						<div class="frame-wrap">

							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="lunes" id="lunes" <%if(modulo?.dias?.lunes) {%>checked=""<%}%> >
								<label class="custom-control-label" for="lunes">L</label>
							</div>
							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="martes" id="martes" <%if(modulo?.dias?.martes) {%>checked=""<%}%> >
								<label class="custom-control-label" for="martes">M</label>
							</div>
							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="miercoles" id="miercoles" <%if(modulo?.dias?.miercoles) {%>checked=""<%}%> >
								<label class="custom-control-label" for="miercoles">M</label>
							</div>
							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="jueves" id="jueves" <%if(modulo?.dias?.jueves) {%>checked=""<%}%> >
								<label class="custom-control-label" for="jueves">J</label>
							</div>
							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="viernes" id="viernes" <%if(modulo?.dias?.viernes) {%>checked=""<%}%>>
								<label class="custom-control-label" for="viernes">V</label>
							</div>
							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="sabado" id="sabado" <%if(modulo?.dias?.sabado) {%>checked=""<%}%> >
								<label class="custom-control-label" for="sabado">S</label>
							</div>
							<div class="custom-control custom-checkbox custom-control-inline">
								<input type="checkbox" class="custom-control-input" name="domingo" id="domingo" <%if(modulo?.dias?.domingo) {%>checked=""<%}%> >
								<label class="custom-control-label" for="domingo">D</label>
							</div>

						</div>
					</div>
				</div>

				<div class="btn-group btn-group-sm" style="float: right; margin-bottom: 2em; margin-right: 2em;">
					<button href="#" type="submit" class="btn btn-info btn-sm" title="Guardar">Crear</button>
					<a href="${createLink(controller: 'espacio', action: 'modulos', id: espacio?.id)}" class="btn btn-secondary btn-sm" title="Cancelar">Cancelar</a>
				</div>
			</g:form>

		</div>
	</div>
</div>
<script>
	$(".datetime").timepicker({
		timeFormat: 'HH:mm',
		showMeridian: false
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