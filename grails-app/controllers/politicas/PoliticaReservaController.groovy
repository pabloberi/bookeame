package politicas

import auth.User
import empresa.Empresa
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class PoliticaReservaController {

    PoliticaReservaService politicaReservaService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(["ROLE_ADMIN"])
    def show(Long id) {
        redirect(controller: 'politicaReserva', action: 'create')
    }

    @Secured(["ROLE_ADMIN"])
    def create() {
        List<PoliticaReserva> politicaReservaList = new ArrayList<>()
        try{
            User user = springSecurityService.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)
            politicaReservaList = PoliticaReserva.findAllByEmpresa(empresa)
        }catch(Exception e){}
        respond new PoliticaReserva(params), model: [politicaReservaList: politicaReservaList]
    }

    @Secured(["ROLE_ADMIN"])
    def save(PoliticaReserva politicaReserva) {
        if (politicaReserva == null) {
            notFound()
            return
        }

        try {
            User user = springSecurityService.getCurrentUser()
            politicaReserva.empresa = Empresa.findByUsuario(user)
            politicaReservaService.save(politicaReserva)
            flash.message = "Política guardada exitosamente!"
        } catch (ValidationException e) {
            respond politicaReserva.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'politicaReserva.label', default: 'PoliticaReserva'), politicaReserva.id])
                redirect politicaReserva
            }
            '*' { respond politicaReserva, [status: CREATED] }
        }
    }

    @Secured(['ROLE_ADMIN'])
    def edit(Long id) {
        respond politicaReservaService.get(id)
    }

    @Secured(['ROLE_ADMIN'])
    def actualizar(PoliticaReserva politicaReserva) {
        if (politicaReserva == null) {
            notFound()
            return
        }

        try {
            User user = springSecurityService.getCurrentUser()
            politicaReserva.empresa = Empresa.findByUsuario(user)
            politicaReservaService.save(politicaReserva)
            flash.message = "Política guardada exitosamente!"
        } catch (ValidationException e) {
            respond politicaReserva.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'politicaReserva.label', default: 'PoliticaReserva'), politicaReserva.id])
                redirect politicaReserva
            }
            '*'{ respond politicaReserva, [status: OK] }
        }
    }

    @Secured(["ROLE_ADMIN"])
    def eliminar(Long id) {
        if (id == null) {
            notFound()
            return
        }
        User user = springSecurityService.getCurrentUser()
        Empresa empresa = Empresa.findByUsuario(user)
        PoliticaReserva politicaReserva = PoliticaReserva.get(id)

        if( empresa?.id != politicaReserva?.empresa?.id){
            notFound()
            return
        }

        politicaReservaService.delete(id)

//        request.withFormat {
//            form multipartForm {
//                flash.message = message(code: 'default.deleted.message', args: [message(code: 'politicaReserva.label', default: 'PoliticaReserva'), id])
//                redirect action:"create", method:"GET"
//            }
//            '*'{ render status: NO_CONTENT }
//        }
        redirect(controller: 'politicaReserva', action: 'create')
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'politicaReserva.label', default: 'PoliticaReserva'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
