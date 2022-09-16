package reserva

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class ReservaTempController {

    ReservaTempService reservaTempService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond reservaTempService.list(params), model:[reservaTempCount: reservaTempService.count()]
    }

    def show(Long id) {
        respond reservaTempService.get(id)
    }

    def create() {
        respond new ReservaTemp(params)
    }

    def save(ReservaTemp reservaTemp) {
        if (reservaTemp == null) {
            notFound()
            return
        }

        try {
            reservaTempService.save(reservaTemp)
        } catch (ValidationException e) {
            respond reservaTemp.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'reservaTemp.label', default: 'ReservaTemp'), reservaTemp.id])
                redirect reservaTemp
            }
            '*' { respond reservaTemp, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond reservaTempService.get(id)
    }

    def update(ReservaTemp reservaTemp) {
        if (reservaTemp == null) {
            notFound()
            return
        }

        try {
            reservaTempService.save(reservaTemp)
        } catch (ValidationException e) {
            respond reservaTemp.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'reservaTemp.label', default: 'ReservaTemp'), reservaTemp.id])
                redirect reservaTemp
            }
            '*'{ respond reservaTemp, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        reservaTempService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'reservaTemp.label', default: 'ReservaTemp'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'reservaTemp.label', default: 'ReservaTemp'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
