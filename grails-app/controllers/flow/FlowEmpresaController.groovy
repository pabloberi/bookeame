package flow

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class FlowEmpresaController {

    FlowEmpresaService flowEmpresaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond flowEmpresaService.list(params), model:[flowEmpresaCount: flowEmpresaService.count()]
    }

    @Secured(['ROLE_SUPERUSER'])
    def show(Long id) {
        respond flowEmpresaService.get(id)
    }

    @Secured(['ROLE_SUPERUSER'])
    def create() {
        respond new FlowEmpresa(params)
    }

    def save(FlowEmpresa flowEmpresa) {
        if (flowEmpresa == null) {
            notFound()
            return
        }

        try {
            flowEmpresaService.save(flowEmpresa)
        } catch (ValidationException e) {
            respond flowEmpresa.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'flowEmpresa.label', default: 'FlowEmpresa'), flowEmpresa.id])
                redirect flowEmpresa
            }
            '*' { respond flowEmpresa, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def edit(Long id) {
        respond flowEmpresaService.get(id)
    }

    def update(FlowEmpresa flowEmpresa) {
        if (flowEmpresa == null) {
            notFound()
            return
        }

        try {
            flowEmpresaService.save(flowEmpresa)
        } catch (ValidationException e) {
            respond flowEmpresa.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'flowEmpresa.label', default: 'FlowEmpresa'), flowEmpresa.id])
                redirect flowEmpresa
            }
            '*'{ respond flowEmpresa, [status: OK] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        flowEmpresaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'flowEmpresa.label', default: 'FlowEmpresa'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'flowEmpresa.label', default: 'FlowEmpresa'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

}
