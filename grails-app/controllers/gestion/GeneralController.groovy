package gestion

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class GeneralController {

    GeneralService generalService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond generalService.list(params), model:[generalCount: generalService.count()]
    }

    def show(Long id) {
        respond generalService.get(id)
    }

    def create() {
        respond new General(params)
    }

    def save(General general) {
        if (general == null) {
            notFound()
            return
        }

        try {
            generalService.save(general)
        } catch (ValidationException e) {
            respond general.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'general.label', default: 'General'), general.id])
                redirect general
            }
            '*' { respond general, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond generalService.get(id)
    }

    def update(General general) {
        if (general == null) {
            notFound()
            return
        }

        try {
            generalService.save(general)
        } catch (ValidationException e) {
            respond general.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'general.label', default: 'General'), general.id])
                redirect general
            }
            '*'{ respond general, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        generalService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'general.label', default: 'General'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'general.label', default: 'General'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
