package reserva

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class ReservaPlanificadaController {

    ReservaPlanificadaService reservaPlanificadaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond reservaPlanificadaService.list(params), model:[reservaPlanificadaCount: reservaPlanificadaService.count()]
    }

    def show(Long id) {
        respond reservaPlanificadaService.get(id)
    }

    def create() {
        respond new ReservaPlanificada(params)
    }

    def save(ReservaPlanificada reservaPlanificada) {
        if (reservaPlanificada == null) {
            notFound()
            return
        }

        try {
            reservaPlanificadaService.save(reservaPlanificada)
        } catch (ValidationException e) {
            respond reservaPlanificada.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), reservaPlanificada.id])
                redirect reservaPlanificada
            }
            '*' { respond reservaPlanificada, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond reservaPlanificadaService.get(id)
    }

    def update(ReservaPlanificada reservaPlanificada) {
        if (reservaPlanificada == null) {
            notFound()
            return
        }

        try {
            reservaPlanificadaService.save(reservaPlanificada)
        } catch (ValidationException e) {
            respond reservaPlanificada.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), reservaPlanificada.id])
                redirect reservaPlanificada
            }
            '*'{ respond reservaPlanificada, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        reservaPlanificadaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
