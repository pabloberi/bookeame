package servicios

import auth.User
import empresa.Empresa
import espacio.Espacio
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class ServicioController {

    ServicioService servicioService
    def springSecurityService
    def validadorPermisosUtilService

    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    @Secured(['ROLE_ADMIN'])
    def index() {
        User user = springSecurityService.getCurrentUser()
        Empresa empresa = Empresa.findByUsuario(user)
        respond Servicio.findAllByEmpresa(empresa)
    }

    @Secured(['ROLE_ADMIN'])
    def create() {
        List<Espacio> espacioList = new ArrayList<>()
        espacioList = Espacio.findAllByEmpresa(Empresa.findByUsuario(springSecurityService?.getCurrentUser()))
        respond new Servicio(params), model: [ espacioList: espacioList ]
    }

    @Secured(['ROLE_ADMIN'])
    def save(Servicio servicio) {
        if (servicio == null) {
            notFound()
            return
        }

        try {
            //TODO: VALIDAR QUE LOS ESPACIOS ESTEN ASOCIADOS A LA EMPRESA DEL USUARIO
            User user = springSecurityService?.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)
            servicio.habilitado =  params?.habilitado ? true : false
            servicio.empresa = empresa
            servicioService.save(servicio)
        } catch (ValidationException e) {
            flash.error = " Ha ocurrido un error, Intenta nuevamente."
            respond servicio.errors, view:'create'
            return
        }

        flash.message = "Servicio creado con exito"
        redirect(action: 'edit', id: servicio?.id)
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Long id) {
        try{
            if( !validadorPermisosUtilService?.validarRelacionEmpresaUser(Servicio.get(id)?.empresaId) ){
                notFound()
                return
            }
            List<Espacio> espacioList = new ArrayList<>()
            espacioList = Espacio.findAllByEmpresa(Empresa.findByUsuario(springSecurityService?.getCurrentUser()))
            Servicio servicio = servicioService.get(id)
            respond servicio, model: [ espacioList: espacioList ]
        }catch(e){
            notFound()
            return
        }
    }

    @Secured(['ROLE_ADMIN'])
    def update(Servicio servicio) {
        if (servicio == null) {
            notFound()
            return
        }
        if( !validadorPermisosUtilService?.validarRelacionEmpresaUser(servicio?.empresaId) ){
            notFound()
            return
        }

        try {
            //TODO: VALIDAR QUE LOS ESPACIOS ESTEN ASOCIADOS A LA EMPRESA DEL USUARIO
            User user = springSecurityService?.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)
            servicio.empresa = empresa
            servicio.habilitado =  params?.habilitado ? true : false
            servicioService.save(servicio)
        } catch (ValidationException e) {
            flash.error = " Ha ocurrido un error, Intenta nuevamente."
            respond servicio.errors, view:'edit'
            return
        }

        flash.message = "Servicio editado con exito"
        redirect(action: 'edit', id: servicio?.id)
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'servicio.label', default: 'Servicio'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
