package Alarma

import auth.User
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import reserva.Dia
import reserva.Modulo
import reserva.Reserva

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class AlarmaController {

    AlarmaService alarmaService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    @Secured('ROLE_USER')
    def index(Integer max) {
        User usuario = springSecurityService.getCurrentUser()
        respond Alarma.findAllByUsuario(usuario)
    }

    @Secured('ROLE_USER')
    def save(Alarma alarma) {
        if (alarma == null) {
            notFound()
            return
        }
        Reserva reserva = Reserva.get(params?.reserva?.toLong())
        if( reserva == null ){
            flash.error = "No se encuentra el horario. "
            redirect( controller: 'alarma', action: 'index' )
            return
        }
        alarma.usuario = springSecurityService.getCurrentUser()
        alarma.horario = reserva?.inicioExacto
        alarma.reservaId = reserva?.id
        alarma?.espacio = reserva?.espacio

        try {
            if( Alarma.findAllByUsuario(alarma?.usuario)?.size() >= 2 ){
                flash.error = "Máximo DOS alarmas en simultáneo."
                redirect( controller: 'alarma', action: 'index' )
                return
            }
            alarmaService.save(alarma)
        } catch (ValidationException e) {
            flash.error = "Ha ocurrido un error al crear tu alarma. Intenta nuevamente."
            respond alarma.errors, view:'index'
            return
        }

        flash.message = "Alarma Creada exitosamente!"
        redirect( controller: 'alarma', action: 'index' )
    }

    @Secured('ROLE_USER')
    def eliminar(Long id) {
        try{
            if (id == null) {
                notFound()
                return
            }

            if( Alarma.get(id)?.usuario != springSecurityService?.getCurrentUser() ){
                flash.message = "No se puede eliminar la alarma!"
                redirect( controller: 'alarma', action: 'index' )
                return
            }
            alarmaService.delete(id)

            flash.message = "Alarma Eliminada exitosamente!"
            redirect( controller: 'alarma', action: 'index' )
        }catch(Exception e){
            flash.message = "No se puede eliminar la alarma!"
            redirect( controller: 'alarma', action: 'index' )
            return
        }
    }

    @Secured('ROLE_USER')
    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'alarma.label', default: 'Alarma'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
