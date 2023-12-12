<asset:stylesheet src="/formplugins/select2/select2.bundle.css"/>
	<div class="panel-container show">
		<div class="panel-content">
			<div class="form-group">
				<div class="custom-control custom-switch">
					<input type="checkbox" class="custom-control-input" name="habilitado" id="habilitado"
						   <% if( servicio?.habilitado || servicio?.id == null){%>checked=""<%}%>
					>
					<label class="custom-control-label" for="habilitado">
						Habilitado
					</label>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label" for="nombre">Nombre</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="text" id="nombre" name="nombre" class="form-control" placeholder="Ingrese nombre" required="" value="${servicio?.nombre}"/>
				</div>
			</div>
			<div class="form-group">
				<label class="form-label" for="descripcion">Descripción</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="text" id="descripcion" name="descripcion" class="form-control" placeholder="Ingrese descripción" required="" value="${servicio?.descripcion}"/>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label" for="valor">Valor</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="number" id="valor" min="1" name="valor" class="form-control" placeholder="Valor del Servicio" required="" value="${servicio?.valor}" onkeyup="this.value=Numeros(this.value)"/>
				</div>
			</div>

			<div class="form-group">
				<label class="form-label" for="valor">Duración en minutos</label>
				<div class="input-group">
					<div class="input-group-prepend">
						<span class="input-group-text"></span>
					</div>
					<g:field type="number" id="duracionAdicional" min="0" name="duracionAdicional" class="form-control" placeholder="Duración en minutos" required="" value="${servicio?.duracionAdicional}" onkeyup="this.value=Numeros(this.value)"/>
				</div>
			</div>

			<div class="form-group">
				<div class="col-sm-12 col-md-12 col-lg-12 pr-1">
					<label class="form-label" for="espacios">Espacios que puedan ofrecer el servicio</label>
					<div class="input-group">
						<g:select id="espacios" name="espacios" class="form-control select2 multiple" from="${espacioList}"
								  required="" style="width: 100%;"
								  optionKey="id" value="${servicio?.espacios?.id}" optionValue="nombre" multiple="true"/>
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



	$('.select2').select2();



</script>
