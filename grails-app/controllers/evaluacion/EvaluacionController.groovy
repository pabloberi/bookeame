package evaluacion

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class EvaluacionController {

    EvaluacionService evaluacionService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond evaluacionService.list(params), model:[evaluacionCount: evaluacionService.count()]
    }

    def show(Long id) {
        respond evaluacionService.get(id)
    }

    def create() {
        respond new Evaluacion(params)
    }

    def save(Evaluacion evaluacion) {
        if (evaluacion == null) {
            notFound()
            return
        }

        try {
            evaluacionService.save(evaluacion)
        } catch (ValidationException e) {
            respond evaluacion.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'evaluacion.label', default: 'Evaluacion'), evaluacion.id])
                redirect evaluacion
            }
            '*' { respond evaluacion, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond evaluacionService.get(id)
    }

    def update(Evaluacion evaluacion) {
        if (evaluacion == null) {
            notFound()
            return
        }

        try {
            evaluacionService.save(evaluacion)
        } catch (ValidationException e) {
            respond evaluacion.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'evaluacion.label', default: 'Evaluacion'), evaluacion.id])
                redirect evaluacion
            }
            '*'{ respond evaluacion, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        evaluacionService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'evaluacion.label', default: 'Evaluacion'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'evaluacion.label', default: 'Evaluacion'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
