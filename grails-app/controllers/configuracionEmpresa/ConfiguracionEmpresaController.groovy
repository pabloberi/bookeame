package configuracionEmpresa

import auth.User
import empresa.Empresa
import flow.Comision
import flow.FlowEmpresa
import flow.FlowEmpresaService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class ConfiguracionEmpresaController {

    ConfiguracionEmpresaService configuracionEmpresaService
    FlowEmpresaService flowEmpresaService
    def springSecurityService
    def flowService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond configuracionEmpresaService.list(params), model:[configuracionEmpresaCount: configuracionEmpresaService.count()]
    }

    @Secured(['ROLE_SUPERUSER'])
    def show(Long id) {
        respond configuracionEmpresaService.get(id)
    }

    @Secured(['ROLE_SUPERUSER'])
    def create() {
        respond new ConfiguracionEmpresa(params)
    }

    def save(ConfiguracionEmpresa configuracionEmpresa) {
        if (configuracionEmpresa == null) {
            notFound()
            return
        }

        try {
            configuracionEmpresaService.save(configuracionEmpresa)
        } catch (ValidationException e) {
            respond configuracionEmpresa.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'configuracionEmpresa.label', default: 'ConfiguracionEmpresa'), configuracionEmpresa.id])
                redirect configuracionEmpresa
            }
            '*' { respond configuracionEmpresa, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def edit(Long id) {
        respond configuracionEmpresaService.get(id)
    }

    def update(ConfiguracionEmpresa configuracionEmpresa) {
        if (configuracionEmpresa == null) {
            notFound()
            return
        }

        try {
            configuracionEmpresaService.save(configuracionEmpresa)
        } catch (ValidationException e) {
            respond configuracionEmpresa.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'configuracionEmpresa.label', default: 'ConfiguracionEmpresa'), configuracionEmpresa.id])
                redirect configuracionEmpresa
            }
            '*'{ respond configuracionEmpresa, [status: OK] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        configuracionEmpresaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'configuracionEmpresa.label', default: 'ConfiguracionEmpresa'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'configuracionEmpresa.label', default: 'ConfiguracionEmpresa'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def configuracionEmpresa(){
        User user = springSecurityService.getCurrentUser()
        ConfiguracionEmpresa configuracionEmpresa
        if( user ){
            Empresa empresa = Empresa.findByUsuario(user)
            if( empresa ){
                configuracionEmpresa  =  ConfiguracionEmpresa.findByEmpresa(empresa)
                FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa(empresa)
                if( configuracionEmpresa ){
                    respond configuracionEmpresa, model: [flowEmpresa: flowEmpresa]
                }else{
                    redirect(controller: 'home', action: 'dashboard')
                }
            }else{
                redirect(controller: 'home', action: 'dashboard')
            }
        }else{
            redirect(controller: 'home', action: 'dashboard')
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def guardarConfiguracionEmpresa(Long id){
        boolean exito = true
        ConfiguracionEmpresa conf = ConfiguracionEmpresa.findById(id)
        conf?.diasAMostrar = params?.diasAMostrar.toInteger()
        conf?.tipoPago?.prepago = params?.prepago == "on" ? true : false
        conf?.tipoPago?.pospago = params?.pospago == "on" ? true : false

        try{
            if( conf?.tipoPago?.prepago ){
                if(validarKeys(params?.apiKey, params?.secretKey)){
                    FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa(conf?.empresa) ?: new FlowEmpresa()
                    flowEmpresa.apiKey = params?.apiKey
                    flowEmpresa.secretKey = params?.secretKey
                    flowEmpresa?.empresa = conf?.empresa
                    flowEmpresa?.comision = Comision.get( params?.comision?.toLong() ?: 1l )

                    flowEmpresaService.save(flowEmpresa)
                    configuracionEmpresaService.save(conf)
                }else{
                    exito = false
                    flash.error = "ApiKey y SecretKey NO son válidas!"
                }
            }else{
                configuracionEmpresaService.save(conf)
            }

        }catch(e){
            exito = false
            flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
        }
        if( exito){
            flash.message = "Configuración guardada con éxito!"
        }
        redirect(controller: 'configuracionEmpresa', action: 'configuracionEmpresa')
    }

    Boolean validarKeys(String apiKey, String secretKey){
        if( apiKey && secretKey){
            if( apiKey?.length() > 0 && secretKey?.length() ){
                boolean response = flowService.getPaymentsValidate(apiKey, secretKey)
                return response
            }else{ return false }
        }else{ return false }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def guardarTelefono(){
        User user = springSecurityService.getCurrentUser()
        if( user ){
            Empresa empresa = Empresa.findByUsuario(user)
            if( empresa ){
                ConfiguracionEmpresa configuracionEmpresa  =  ConfiguracionEmpresa.findByEmpresa(empresa)
                configuracionEmpresa.fono = params?.fono
                try{
                    configuracionEmpresaService.save(configuracionEmpresa)
                }catch(e){
                    flash.error = "Ups! Ha ocurrido un error"
                    redirect(controller: 'configuracionEmpresa', action: 'configuracionEmpresa')
                }
                flash.message = "Dato guardado correctamente!"
                redirect(controller: 'configuracionEmpresa', action: 'configuracionEmpresa')
            }else{
                flash.error = "Ups! Ha ocurrido un error"
                redirect(controller: 'configuracionEmpresa', action: 'configuracionEmpresa')
            }
        }else{
            flash.error = "Ups! Ha ocurrido un error"
            redirect(controller: 'configuracionEmpresa', action: 'configuracionEmpresa')
        }
    }
}
