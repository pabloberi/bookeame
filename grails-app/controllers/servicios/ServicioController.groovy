package servicios

import auth.User
import empresa.Empresa
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
        respond new Servicio(params)
    }

    @Secured(['ROLE_ADMIN'])
    def save(Servicio servicio) {
        if (servicio == null) {
            notFound()
            return
        }

        try {
            User user = springSecurityService?.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)
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
            respond servicioService.get(id)
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
            User user = springSecurityService?.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)
            servicio.empresa = empresa
            servicioService.save(servicio)
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
