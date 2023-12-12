package feriados

import auth.User
import empresa.Empresa
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class FeriadoController {

    FeriadosService feriadosService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_ADMIN'])
    def index(Integer max) {
        List<Feriado> feriadosList = new ArrayList<>()
        try{
            User user = springSecurityService?.getCurrentUser()
            feriadosList = Feriado.findAllByEmpresa(Empresa.findByUsuario(user))
        }catch(Exception e){
            log.error("ha ocurrido un error al obtener los feriados")
        }
        respond feriadosList
    }

    @Secured(['ROLE_ADMIN'])
    def show(Long id) {
        respond feriadosService.get(id)
    }

    @Secured(['ROLE_ADMIN'])
    def create() {
        respond new Feriado(params)
    }

    @Secured(['ROLE_ADMIN'])
    def save(Feriado feriado) {
        if (feriado == null) {
            notFound()
            return
        }

        try {
            User user = springSecurityService?.getCurrentUser()
            feriado.empresa = Empresa.findByUsuario(user)
            feriadosService.save(feriado)
        } catch (ValidationException e) {
            respond feriado.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'feriado.label', default: 'Feriados'), feriado.id])
                redirect feriado
            }
            '*' { respond feriado, [status: CREATED] }
        }
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Long id) {
        respond feriadosService.get(id)
    }

    @Secured(['ROLE_ADMIN'])
    def actualizar(Long id) {
        Feriado feriado = Feriado.get(id)
        User user = springSecurityService?.getCurrentUser()

        if (feriado == null) {
            notFound()
            return
        }

        if(user?.id != feriado?.empresa?.usuario?.id){
            notFound()
            return
        }

        try {
            feriado.empresa = Empresa.findByUsuario(user)
            feriado.habilitado =  params?.habilitado ? true : false
            feriadosService.save(feriado)
        } catch (ValidationException e) {
            respond feriado.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'feriado.label', default: 'Feriados'), feriado.id])
                redirect feriado
            }
            '*'{ respond feriado, [status: OK] }
        }
    }

    @Secured(['ROLE_ADMIN'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        feriadosService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'feriado.label', default: 'Feriados'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'feriado.label', default: 'Feriados'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
