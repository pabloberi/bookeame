package ubicación

import auth.User
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class UbicacionUserController {

    UbicacionUserService ubicacionUserService
    def springSecurityService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond ubicacionUserService.list(params), model:[ubicacionUserCount: ubicacionUserService.count()]
    }

    def show(Long id) {
        respond ubicacionUserService.get(id)
    }

    def create() {
        User user = springSecurityService.getCurrentUser()

        if( user ){
            List<UbicacionUser> ubicacionUserList = UbicacionUser.findAllByUsuario(user)
            respond new UbicacionUser(params), model: [ubicacionUserList: ubicacionUserList]
        }else{
            respond new UbicacionUser(params)
        }
    }

    def save(UbicacionUser ubicacionUser) {
        if (ubicacionUser == null) {
            notFound()
            return
        }

        try {
            ubicacionUserService.save(ubicacionUser)
        } catch (ValidationException e) {
            respond ubicacionUser.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), ubicacionUser.id])
                redirect ubicacionUser
            }
            '*' { respond ubicacionUser, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond ubicacionUserService.get(id)
    }

    def update(UbicacionUser ubicacionUser) {
        if (ubicacionUser == null) {
            notFound()
            return
        }

        try {
            ubicacionUserService.save(ubicacionUser)
        } catch (ValidationException e) {
            respond ubicacionUser.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), ubicacionUser.id])
                redirect ubicacionUser
            }
            '*'{ respond ubicacionUser, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        ubicacionUserService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    def guardarUbicacionUser(){
        boolean exito = true
        User user = springSecurityService.getCurrentUser()
        if( user ){
            try{
                UbicacionUser ubicacion = new UbicacionUser(
                        latitud: new Float(params?.latitud),
                        longitud: new Float(params?.longitud),
                        usuario: user,
                        direccion: params?.nombre
                ).save(failOnError: true)
            }catch(e){
                exito = false
            }
        }else{
            exito = false
        }

        if(exito){
            flash.message = "Dirección guardada correctamente."
        }else{
            flash.error = "Ups! Ha ocurrido un error."
        }

        redirect(controller: 'ubicacionUser', action: 'create')
    }

    def asignarEnUso(Long id){
        boolean exito = true
        User user = springSecurityService.getCurrentUser()
        UbicacionUser ubicacionUser = UbicacionUser.findById(id)

        if( ubicacionUser && user ){
            List<UbicacionUser> ubicacionUserList = UbicacionUser.findAllByUsuario(user)
            for( ubicacion in ubicacionUserList ){
                try{
                    if( ubicacion?.id == ubicacionUser?.id ){
                        ubicacion.enUso = true
                    }else{
                        ubicacion.enUso = false
                    }
                    ubicacionUserService.save(ubicacion)
                }catch(e){}
            }
        }else{
            exito = false
        }

        if(exito){
            flash.message = "Dirección guardada correctamente."
        }else{
            flash.error = "Ups! Ha ocurrido un error."
        }

        redirect(controller: 'ubicacionUser', action: 'create')
    }

    def eliminarUbicacion(Long id){
        boolean exito = true

        try{
            ubicacionUserService.delete(id)
        }catch(e){
            exito = false
        }

        if(exito){
            flash.message = "Dirección eliminada correctamente."
        }else{
            flash.error = "Ups! Ha ocurrido un error."
        }

        redirect(controller: 'ubicacionUser', action: 'create')
    }



}
