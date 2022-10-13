package ubicacion

import auth.User
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import ubicacion.UbicacionUser

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class UbicacionUserController {

    UbicacionUserService ubicacionUserService
    def springSecurityService
    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_USER'])
    def index(Integer max) {
        User user = springSecurityService.getCurrentUser()
        List<UbicacionUser> ubicacionUserList = UbicacionUser.createCriteria().list() {
            and{
                usuario{
                    eq('id', user?.id)
                }

            }
        }
        respond ubicacionUserList

        /* params.max = Math.min(max ?: 10, 100)
         respond ubicacionUserService.list(params), model:[ubicacionUserCount: ubicacionUserService.count()]*/
    }

//    def show(Long id) {
//        respond ubicacionUserService.get(id)
//    }

//    @Secured(['ROLE_USER'])
//    def create() {
//        User user = springSecurityService.getCurrentUser()
//
//        if( user ){
//            List<UbicacionUser> ubicacionUserList = UbicacionUser.findAllByUsuario(user)
//            respond new UbicacionUser(params), model: [ubicacionUserList: ubicacionUserList]
//        }else{
//            respond new UbicacionUser(params)
//        }
//    }


//    @Secured(['ROLE_USER'])
//    def save(UbicacionUser ubicacionUser) {
//        if (ubicacionUser == null) {
//            notFound()
//            return
//        }
//
//        try {
//            ubicacionUserService.save(ubicacionUser)
//        } catch (ValidationException e) {
//            respond ubicacionUser.errors, view:'index'
//            return
//        }
//
//        request.withFormat {
//            form multipartForm {
//                flash.message = message(code: 'default.created.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), ubicacionUser.id])
//                redirect ubicacionUser
//            }
//            '*' { respond ubicacionUser, [status: CREATED] }
//        }
//    }

//    def edit(Long id) {
//        respond ubicacionUserService.get(id)
//    }

//    def update(UbicacionUser ubicacionUser) {
//        if (ubicacionUser == null) {
//            notFound()
//            return
//        }
//
//        try {
//            ubicacionUserService.save(ubicacionUser)
//        } catch (ValidationException e) {
//            respond ubicacionUser.errors, view:'edit'
//            return
//        }
//
//        request.withFormat {
//            form multipartForm {
//                flash.message = message(code: 'default.updated.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), ubicacionUser.id])
//                redirect ubicacionUser
//            }
//            '*'{ respond ubicacionUser, [status: OK] }
//        }
//    }

//    def delete(Long id) {
//        if (id == null) {
//            notFound()
//            return
//        }
//
//        ubicacionUserService.delete(id)
//
//        request.withFormat {
//            form multipartForm {
//                flash.message = message(code: 'default.deleted.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), id])
//                redirect action:"index", method:"GET"
//            }
//            '*'{ render status: NO_CONTENT }
//        }
//    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'ubicacionUser.label', default: 'UbicacionUser'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Secured(['ROLE_USER'])
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

    @Secured(['ROLE_USER'])
    def asignarEnUso(Long id){
        boolean exito = true
        User user = springSecurityService.getCurrentUser()
        UbicacionUser ubicacionUser = UbicacionUser.findById(id)

        if( ubicacionUser?.usuario?.id == user?.id ){
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

    @Secured(['ROLE_USER'])
    def eliminarUbicacion(Long id){
        boolean exito = false
        User user = springSecurityService.getCurrentUser()
        UbicacionUser ubicacionUser = UbicacionUser.findById(id)
        try{
            if( user?.id == ubicacionUser?.usuario?.id ){
                ubicacionUserService.delete(id)
                exito = true
            }
        }catch(e){
            exito = false
        }

        if(exito){
            flash.message = "Dirección eliminada correctamente."
        }else{
            flash.error = "Ups! Ha ocurrido un error."
        }

        redirect(controller: 'ubicacionUser', action: 'index')
    }


    @Secured(['ROLE_USER'])
    def insertarForm(){
        render template: '/ubicacionUser/formDireccionCreate'
    }

    @Secured(['ROLE_USER'])
    def crearDireccion(){

        boolean exito = true
        UbicacionUser ubicacionUser = new UbicacionUser(params)
        ubicacionUser.usuario = springSecurityService.getCurrentUser()
        try {
            ubicacionUserService.save(ubicacionUser)
        } catch(e){
            exito = false
        }

        if (exito) {
            flash.message = "Dirección registrado exitosamente!"
        } else {
            flash.error = "Ups! no se pudo registrar la información. Por favor intenta más tarde."
        }
        redirect(controller: 'ubicacionUser', action: 'index')

    }

    @Secured(['ROLE_USER'])
    def editarDireccion(Long id){
        UbicacionUser ubicacionUser = UbicacionUser.findById(id)
        UbicacionUser ubicacionUser1 = new UbicacionUser(params)

        boolean exito = true

        if (ubicacionUser){
            ubicacionUser?.region = ubicacionUser1?.region // Region.get( params?.region?.toLong() )
            ubicacionUser?.comuna = ubicacionUser1?.comuna
            ubicacionUser?.direccion = params?.direccion // params?.direccion

            try {
                ubicacionUserService.save(ubicacionUser)
            }catch (e){
                exito = false
            }
        }else{
            exito = false
        }

        if(exito){
            flash.message = "Dirección editada exitosamente!"
        }else{
            flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde."
        }
        redirect(controller: 'ubicacionUser', action: 'index')

    }

    @Secured(['ROLE_USER'])
    def habilitarDireccion(Long id){
        boolean exito = true
        User user  = springSecurityService.getCurrentUser()
        List <UbicacionUser> ubicacionUserList = UbicacionUser.createCriteria().list(){  //list
            and {
                usuario{
                    eq('id', user?.id)
                }
            }
        }
        for (ubicacionUser in ubicacionUserList){
            if (ubicacionUser?.id == id){
                if (!ubicacionUser?.enUso){
                    ubicacionUser?.enUso = true
                }else{
                    ubicacionUser?.enUso = false
                }
                try {
                    ubicacionUserService.save(ubicacionUser)
                }catch(e){
                    exito = false
                }
            }else{
                ubicacionUser?.enUso = false
                try {
                    ubicacionUserService.save(ubicacionUser)
                }catch(e){
                    exito = false
                }
            }
        }
        if (exito) {
            flash.message = "Dirección Habilitada/Deshabilitada exitosamente!"
        } else {
            flash.error = "Ups! no se pudo habilitar la dirección. Por favor intenta más tarde."
        }
    }

    def cargarComuna(Long regionId, Long ubicacionId){
        List<Comuna> comunaList = []

        if( regionId){
            try{
                Region region =  Region.findById(regionId)
                List<Provincia> provinciaList =  Provincia.findAllByRegion(region)

                for( provincia in  provinciaList ){
                    comunaList.addAll( Comuna.findAllByProvincia(provincia) )
                }
            }catch(e){}
        }
        if (ubicacionId){
            UbicacionUser ubicacionUser = UbicacionUser.findById(ubicacionId)

            render g.select(id: 'comuna', name: 'comuna',required: 'required', multiple: "", from: comunaList , optionKey: 'id', class: "form-control select2", style:"width: 100%; ", value: ubicacionUser?.comuna?.id)
        }else{
            render g.select(id: 'comuna', name: 'comuna',required: 'required', multiple: "", from: comunaList.sort { it?.comuna } , optionKey: 'id', noSelection: ['':'- Seleccione Comuna -'], class: "form-control select2", style:"width: 100%;" )
        }
    }



}






