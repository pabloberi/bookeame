package reserva

import espacio.DiaService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class DiaController {

    DiaService diaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond diaService.list(params), model:[diaCount: diaService.count()]
    }

    @Secured(['ROLE_SUPERUSER'])
    def show(Long id) {
        respond diaService.get(id)
    }

    @Secured(['ROLE_SUPERUSER'])
    def create() {
        respond new Dia(params)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def save(Dia dia) {
        if (dia == null) {
            notFound()
            return
        }

        try {
            diaService.save(dia)
        } catch (ValidationException e) {
            respond dia.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'dia.label', default: 'Dia'), dia.id])
                redirect dia
            }
            '*' { respond dia, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def edit(Long id) {
        respond diaService.get(id)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def update(Dia dia) {
        if (dia == null) {
            notFound()
            return
        }

        try {
            diaService.save(dia)
        } catch (ValidationException e) {
            respond dia.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'dia.label', default: 'Dia'), dia.id])
                redirect dia
            }
            '*'{ respond dia, [status: OK] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        diaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'dia.label', default: 'Dia'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'dia.label', default: 'Dia'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
