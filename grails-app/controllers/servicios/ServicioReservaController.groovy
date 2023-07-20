package servicios

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class ServicioReservaController {

    ServicioReservaService servicioReservaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond servicioReservaService.list(params), model:[servicioReservaCount: servicioReservaService.count()]
    }

    def show(Long id) {
        respond servicioReservaService.get(id)
    }

    def create() {
        respond new ServicioReserva(params)
    }

    def save(ServicioReserva servicioReserva) {
        if (servicioReserva == null) {
            notFound()
            return
        }

        try {
            servicioReservaService.save(servicioReserva)
        } catch (ValidationException e) {
            respond servicioReserva.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'servicioReserva.label', default: 'ServicioReserva'), servicioReserva.id])
                redirect servicioReserva
            }
            '*' { respond servicioReserva, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond servicioReservaService.get(id)
    }

    def update(ServicioReserva servicioReserva) {
        if (servicioReserva == null) {
            notFound()
            return
        }

        try {
            servicioReservaService.save(servicioReserva)
        } catch (ValidationException e) {
            respond servicioReserva.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'servicioReserva.label', default: 'ServicioReserva'), servicioReserva.id])
                redirect servicioReserva
            }
            '*'{ respond servicioReserva, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        servicioReservaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'servicioReserva.label', default: 'ServicioReserva'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'servicioReserva.label', default: 'ServicioReserva'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
