<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
	<div class="panel-container show">
		<div class="panel-content">
			<div class="form-group">
				<div class="custom-control custom-switch">
					<input type="checkbox" class="custom-control-input" name="habilitado" id="habilitado"
						   <% if( feriado?.habilitado || feriado?.id == null){%>checked=""<%}%>
					>
					<label class="custom-control-label" for="habilitado">
						Habilitado
					</label>
				</div>
			</div>

			<div class="form-group col-xs-12 col-sm-12 col-md-12 col-lg-12 col-xl-12">
				<label class="form-label" for="fecha">Fecha Feriado</label>
				<div class="input-group">
					<g:field type="text" id="fecha" name="fecha" data-date-format="dd-mm-yyyy" class="form-control datepicker-1"
							 readonly="" placeholder="dd-mm-aaaa" required="" value="${feriado?.fecha}"/>
					<div class="input-group-append">
						<span class="input-group-text fs-xl">
							<i class="fal fa-calendar-check"></i>
						</span>
					</div>
				</div>
			</div>

			<div class="row no-gutters">
				<div class="col-md-12 ml-auto text-right">
					<g:if test="${actionName == 'create'}">
						<button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-12">Crear</button>
					</g:if>
					<g:if test="${actionName == 'edit'}">
						<button id="js-login-btn" type="submit" class="btn btn-block btn-info btn-lg mt-12">Editar</button>
					</g:if>
				</div>
			</div>

		</div>
	</div>

	<asset:javascript src="/formplugins/select2/select2.bundle.js"/>

<script>
	<g:if test="${flash.message}">
		$(document).ready( function () {
			toastr.success("${flash.message}");
		});
	</g:if>
	<g:if test="${flash.error}">
		$(document).ready( function () {
			toastr.warning("${flash.error}");
		});
	</g:if>
	function Numeros(string){//Solo numeros
	    var out = '';
	    var filtro = '1234567890';//Caracteres validos

	    for (var i=0; i<string.length; i++)
	        if (filtro.indexOf(string.charAt(i)) != -1)
	            out += string.charAt(i);
	    return out;
	}



	$('.datepicker-1').datepicker({
		todayHighlight: true,
		language: 'esp',
		orientation: "bottom right"
	});


</script>
