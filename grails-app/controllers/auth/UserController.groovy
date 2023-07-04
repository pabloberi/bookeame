package auth

import gestion.General
import empresa.CambioDatos
import empresa.Empresa
import grails.gorm.transactions.Transactional
import reserva.Modulo
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class UserController {

    UserService userService
    UserRoleService userRoleService
    def springSecurityService
    def mailService
    def groovyPageRenderer
    def utilService

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")


    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        List<User> userList = UserRole.findAllByRole(Role.findByAuthority("ROLE_USER")).user
        respond userList
    }


    def show(Long id) {
        User user = springSecurityService.getCurrentUser()
        if( user?.id == id){
            if(user.authorities.findAll().find { it -> it.authority == "ROLE_ADMIN" } ){
                Empresa empresa = Empresa.findByUsuario(user)
                respond userService.get(id), model: [empresa: empresa, cambioDatosList: CambioDatos.findAllByEmpresa(empresa)]
            }else{
                respond userService.get(id)
            }
        }else{
//            if(user.authorities.findAll().find { it -> it.authority == "ROLE_SUPERUSER" } ){
//                respond userService.get(id)
//            }else{
                render view: '/notFound'
//            }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def create() {
        respond new User(params)
    }

    def save(User user) {
        if (user == null) {
            notFound()
            return
        }

        try {
            userService.save(user)
        } catch (ValidationException e) {
            respond user.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*' { respond user, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def edit(Long id) {
        respond userService.get(id)
    }

    def update(User user) {
        if (user == null) {
            notFound()
            return
        }

        try {
            userService.save(user)
        } catch (ValidationException e) {
            respond user.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*'{ respond user, [status: OK] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        userService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN', 'ROLE_USER'])
    def editarCampo(){
        User user = springSecurityService.getCurrentUser()
        boolean exito = true

        if( user ){
            try{
                for( value in params ) {
                    user.setProperty( value?.key, value?.value )
                    break
                }
                userService.save(user)
            }catch(e){ exito = false }
        }else{ exito = false }

        if( exito ){ flash.message = "Campo editado correctamente!" }else{ flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde." }
        redirect( controller: 'user', action: 'show', id: user?.id)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN', 'ROLE_USER'])
    def editDistance(){
        User user = springSecurityService.getCurrentUser()
        boolean exito = true

        if( user ){
            try{
                user.distance = params?.distance.toInteger()
                userService.save(user)
            }catch(e){ exito = false }
        }else{ exito = false }

        if( exito ){ flash.message = "Campo editado correctamente!" }else{ flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde." }
        redirect( controller: 'user', action: 'show', id: user?.id)
    }


    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def busquedaInteligenteAdmin(String valor, String roleString, Long moduloId, String fechaReserva){
        Role role = Role.findByAuthority(roleString)
        def userList = []

        def userRoleList = UserRole.executeQuery("from UserRole where role.id = "+ role?.id + " and user.username like '" + valor + "%'")

        for( usr in userRoleList){
            if( usr?.user?.enabled ){
                userList.add(usr?.user)
            }
        }

        if( userList.size() > 0 ){
            render template: '/reserva/tablaResultUser', model:[userList: userList, moduloId: moduloId, fechaReserva: fechaReserva]
        }else{
            render template: '/reserva/formResultUser', model: [moduloId: moduloId, fechaReserva: fechaReserva]
        }
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def seleccionUser(Long userId){

        User user = User.findById(userId)

        if( user != null ){
            render template: '/reserva/tablaSelectUser', model: [userSelect: user, tokenUser: ""]
        }else{
            return
        }
    }

    @Secured(['permitAll'])
    def registro(){}

    @Secured(['permitAll'])
    def registroUser(){
        def user
        if( params?.fechaNac && params?.fechaNac.length() > 8) {
            params?.fechaNac = sdf.parse(params?.fechaNac)
        }
        char dv = params?.dv

        if( validarDv(params?.rut, dv) ){
            try{
                String token = UUID.randomUUID().toString()
                user = new User(
                        username: params?.email,
                        password: params?.password,
                        nombre: params?.nombre,
                        apellidoPaterno: params?.apellidoPaterno,
                        apellidoMaterno: params?.apellidoMaterno,
                        email: params?.email,
                        celular: params?.celular,
                        fechaNac: params?.fechaNac ? params?.fechaNac : new Date(),
                        rut: params?.rut,
                        dv: params?.dv,
                        accountLocked: true,
                        invitado: false,
                        tokenPassword: token
                ).save(failOnError: true)
            } catch (ValidationException e) {
                flash.message = 'Ups! Tu rut y/o correo ya se encuentran registrados.'
            }
            if( user != null ){
                if( asignarRolNuevo("ROLE_USER", user ) ){
                    //CORREO ACTIVACION USER
                    String link = createLink( base: General.findByNombre("baseUrl")?.valor, controller: 'user', action: 'activarCtaUser', id: user?.id)
                    String template = groovyPageRenderer.render(template:  "/correos/activarCtaUser", model: [user: user, link: link + "?token=${user?.tokenPassword}"])
                    utilService.enviarCorreo(user?.email, "noresponder@bookeame.cl", "Hola ${user?.nombre}", template  )

                    flash.message = 'Registro creado exitosamente! Te hemos enviado un correo para validar tus datos.'
                }else{
                    try{
                        userService.delete(user?.id)
                    }catch(e){
                        flash.message = 'Ups! no pudimos procesar tu solicitud :('
                    }
                    flash.message = 'Ups! no pudimos procesar tu solicitud :('
                }

            }else{
                flash.message = 'Ups! Tu rut y/o correo ya se encuentran registrados.'
            }
        }else{
            flash.message = 'Ups! rut erróneo. Por favor ingresa un rut válido.'
        }
        redirect action: 'registro'
    }

    @Secured(['permitAll'])
    boolean asignarRolNuevo(String rol, User user){
        boolean exito = true
        try{
            def role = Role.findByAuthority(rol)
            UserRole userRole  = new UserRole()
            userRole.user = user
            userRole.role = role
            userRoleService.save(userRole)
        }catch(e){
            userService.delete(user?.id)
            exito = false
        }
        if( exito ){
            return true
        }else{
            return false
        }
    }

    @Secured(['permitAll']) // validar seguridad
    def activarCtaUser(Long id){
        User user = User.findById(id)
        if(user != null){
            if(user?.accountLocked && user?.tokenPassword == params?.token ){
                user.accountLocked = false
                user.tokenPassword = ""
                try{
                    userService.save(user)
                }catch(e){}
                //CORREO CONFIRMACION USER
                String template = groovyPageRenderer.render(template:  "/correos/enviarDatosUser", model: [user: user])
                utilService.enviarCorreo(user?.email, "noresponder@bookeame.cl", "Ya somos amigos!", template  )

                flash.message = "Felicitaciones, tu usuario ha sido activado exitosamente! Qué esperas para ingresar?"
                redirect action: 'registro'
            }else{
                flash.message = "Tu cuenta ya había sido activada ;)"
                redirect action: 'registro'
            }
        }else{
            flash.message = "Ups! no pudimos activar tu usuario :("
            redirect action: 'registro'
        }
    }

    @Secured(['permitAll'])
    def validarDv(String rut, char dv){

        if(rut != "" && dv != null){
            boolean validacion
            dv.upperCase
            int M=0,S=1,T=Integer.parseInt(rut)
            for(;T!=0;T/=10) S=(S+T%10*(9-M++%6))%11
            if (dv.equals((char)(S!=0?S+47:75))) {
                validacion = true
            } else {
                validacion = false
            }
            return  validacion
        }

    }

    @Secured(['permitAll'])
    def validarDvAjax(String rut, char dv){

        if(rut != "" && dv != null){
            boolean validacion
            dv.upperCase
            int M=0,S=1,T=Integer.parseInt(rut)
            for(;T!=0;T/=10) S=(S+T%10*(9-M++%6))%11
            if (dv.equals((char)(S!=0?S+47:75))) {
                validacion = true
            } else {
                validacion = false
            }
            render  validacion
        }

    }

    @Secured(['permitAll'])
    def compararPass(String string1, String string2){
        boolean validacion
        if( string1 == string2){
            validacion = true
        }else{
            validacion = false
        }
        render validacion
    }

    @Secured(['permitAll'])
    def recuperarPass(){}

    @Secured(['permitAll'])
    def recoveryPassword(){
        if(params?.email){
            User user =  User.findByEmail(params?.email)
            if(user){
                String confirmCode = UUID.randomUUID().toString()
                user.tokenPassword = confirmCode
                userService.save(user)

                //CORREO RECUPERAR PASSWORD
                String link = createLink( base: General.findByNombre("baseUrl")?.valor, controller: 'user', action: 'formPass', id: user?.id)
                String template = groovyPageRenderer.render(template:  "/correos/recuperarContraseña", model: [user: user,link: link + "?token=${user?.tokenPassword}" ])
                utilService.enviarCorreo(user?.email, "noresponder@bookeame.cl", "Recupera tu cuenta", template  )

                flash.message = 'Te hemos enviado un correo para cambiar tu contraseña!'
                redirect action: 'recuperarPass'
            }else{
                flash.message = 'No tenemos tu correo en nuestros registros. Por favor completa el formulario de registro.'
                redirect action: 'recuperarPass'
            }
        }else{
            flash.message = 'Ups! Tuvimos probemas con tu correo. Por favor intenta nuevamente.'
            redirect action: 'recuperarPass'
        }
    }

    @Secured(['permitAll'])
    def formPass(Long id){
        User user = User.get(id)
        if( user?.tokenPassword == params?.token ){
            respond id: id, model: [token: params?.token]
        }else{
            redirect(controller: 'login', action: 'auth')
        }
    }

    @Secured(['permitAll'])
    def cambiarPassRecupera(Long id){
        User user = User.findById(id)
        if( user != null && params?.password != null && user?.tokenPassword == params?.token ){
            user.password = params?.password
            user.tokenPassword = null
            try{
                userService.save(user)
            }catch(e){}
            flash.message = 'Hemos cambiado tu contraseña con éxito!'
            redirect action: 'recuperarPass'
        }else{
            flash.message = 'Ups! No hemos podido completar tu solicitud :('
            redirect action: 'recuperarPass'
        }
    }

    @Secured(['permitAll'])
    def registroInvitado(Long id){
        User user = User.findById(id)
        if( user != null ){
            if( user?.invitado ){
                respond user
            }else{
                redirect action: 'registro'
            }
        }else{
            redirect action: 'registro'
        }
    }

    @Secured(['permitAll'])
    def editarUserInvitado(Long id){
        boolean exito = true

        User user = User.findById(id)
        if( params?.fechaNac && params?.fechaNac.length() > 8){
            params?.fechaNac = sdf.parse(params?.fechaNac)
        }

        char dv = params?.dv

        if( user != null && validarDv(params?.rut, dv ) && user?.rut == null){
            user.nombre = params?.nombre
            user.apellidoPaterno = params?.apellidoPaterno
            user.apellidoMaterno = params?.apellidoMaterno
            if( params?.fechaNac ) {
                user.fechaNac = params?.fechaNac
            }
            user.rut = params?.rut
            user.dv = params?.dv
//            user.direccion = params?.direccion
            user.password = params?.password
            user.tokenPassword = UUID.randomUUID().toString()

            try{
                userService.save(user)
            }catch(e){
                exito = false
            }

        }else{
            exito = false
        }
        if( exito ){
            String link = createLink( base:  General.findByNombre("baseUrl")?.valor, controller: 'user', action: 'activarCtaUser', id: user?.id)
            String template = groovyPageRenderer.render(template:  "/correos/activarCtaUser", model: [user: user, link: link + "?token=${user?.tokenPassword}" ])
            utilService.enviarCorreo(user?.email, "noresponder@bookeame.cl", "Bienvenido", template  )

            flash.message = 'Registro creado exitosamente! Te hemos enviado un correo para validar tus datos.'
            redirect action: 'registro'
        }else{
            flash.message = 'Ups! rut erróneo. Por favor ingresa un rut válido.'
            redirect action: 'registro'
        }

    }

    def subirImagenPerfil(){
        User user = springSecurityService.getCurrentUser()
        if( user ){
            def doc = params?.fotoPerfil
            if( !doc.empty ){
                try {
                    String extension = utilService.obtenerExtension(doc.filename)
                    String nombreArchivo = "perfil" + user?.id
                    InputStream docIS = doc.inputStream
                    def path = General.findByNombre('pathImg')?.valor + "users/" + user?.id + "/"
                    utilService.uploadFile(docIS.bytes, nombreArchivo + extension, path)
                    // linux = /imagenes/users/id/nombre.png
                    // windows = /imagenes/users/id/nombre.png
                    user.foto = nombreArchivo + extension
                    userService.save(user)
                    flash.message = "Imagen subida correctamente."
                } catch (ValidationException e) {
                    flash.error = "Error inesperado."
                }
            }else{
                flash.error = "Debe subir una foto."
            }
        }else{
            flash.error = "Error inesperado."
        }
        if(params?.id){
            redirect (controller: params?.controlador, action: params?.metodo, id: params?.id)

        }else{
            redirect (controller: params?.controlador, action: params?.metodo)

        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def bannearUsuario( Long id ){
        try{
            User user = User.get(id)
            user.enabled = false
            user.accountLocked = true
            userService.save(user)
            flash.message = "Usuario banneado correctamente."
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'user', action: 'index')
    }

    @Secured(['ROLE_SUPERUSER'])
    def desbannearUsuario(Long id){
        try{
            User user = User.get(id)
            user.enabled = true
            user.accountLocked = false
            userService.save(user)
            flash.message = "Usuario Desbanneado correctamente."
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'user', action: 'index')
    }

}
