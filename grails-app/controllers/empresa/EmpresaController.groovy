package empresa

import auth.Role
import auth.User
import auth.UserRole
import auth.UserRoleService
import auth.UserService
import configuracionEmpresa.ConfiguracionEmpresa
import configuracionEmpresa.TipoPago
import gestion.General
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class EmpresaController {

    EmpresaService empresaService
    UserService userService
    UserRoleService userRoleService
    CambioDatosService cambioDatosService
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")
    def springSecurityService
    def mailService
    def groovyPageRenderer
    def utilService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        List<Empresa> empresaList = Empresa.list()
        respond empresaList
    }

    def show(Long id) {
        respond empresaService.get(id)
    }

    @Secured(['ROLE_SUPERUSER'])
    def create() {
        respond new Empresa(params)
    }

    def save(Empresa empresa) {
        if (empresa == null) {
            notFound()
            return
        }

        try {
            empresaService.save(empresa)
        } catch (ValidationException e) {
            respond empresa.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'empresa.label', default: 'Empresa'), empresa.id])
                redirect empresa
            }
            '*' { respond empresa, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def edit(Long id) {
        respond empresaService.get(id)
    }

    def update(Empresa empresa) {
        if (empresa == null) {
            notFound()
            return
        }

        try {
            empresaService.save(empresa)
        } catch (ValidationException e) {
            respond empresa.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'empresa.label', default: 'Empresa'), empresa.id])
                redirect empresa
            }
            '*'{ respond empresa, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        empresaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'empresa.label', default: 'Empresa'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'empresa.label', default: 'Empresa'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def editarCampo(Long id){
        User user = springSecurityService.getCurrentUser()
        Empresa empresa = Empresa.findByUsuario(user)
        boolean exito = true

        if( empresa ){
            try{
                for( value in params ) {
                    empresa.setProperty( value?.key, value?.value )
                    break
                }
                empresaService.save(empresa)
            }catch(e){ exito = false }
        }else{ exito = false }

        if( exito ){ flash.message = "Campo editado correctamente!" }else{ flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde." }
        redirect( controller: 'user', action: 'show', id: user?.id)
    }

    def editarRut(){
        User user = springSecurityService.getCurrentUser()
        Empresa empresa = Empresa.findByUsuario(user)
        boolean exito = true
        char dv = params?.dv
        if( empresa ){
            if( validarDv( params?.rut, dv)){
                try{
                    empresa.rut = params?.rut
                    empresa.dv = params?.dv
                    empresaService.save(empresa)
                }catch(e){
                    exito = false
                    flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde."
                }
            }else{
                exito = false
                flash.error = "Rut Erróneo!"
            }
        }else{
            exito = false
        }

        if( exito ){ flash.message = "Campo editado correctamente!" }
        redirect( controller: 'user', action: 'show', id: user?.id)
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
    def crearEmpresa(){
        boolean exito = true
        params?.fechaNacRepresentante = sdf.parse(params?.fechaNacRepresentante)
        char dvEmpresa = params?.dvEmpresa
        char dvRep = params?.dvRepresentante
        if( validarDv(params?.rutEmpresa, dvEmpresa) && validarDv(params?.rutRepresentante, dvRep)){
            try{
                User user = new User(
                        username: params?.emailEmpresa,
                        password: params?.passwordEmpresa,
                        email: params?.emailEmpresa,
                        celular: params?.celularRepresentante, //representante legal
                        nombre: params?.nombreRepresentante, //representante legal
                        apellidoMaterno: params?.apellidoMaternoRepresentante, //representante legal
                        apellidoPaterno: params?.apellidoPaternoRepresentante, //representante legal
                        fechaNac: params?.fechaNacRepresentante, //representante legal
                        rutRepresentante: params?.rutRepresentante, //representante legal
                        dvRepresentante: params?.dvRepresentante, //representante legal
                        rut: params?.rutEmpresa,
                        dv: params?.dvEmpresa,
                        enabled: false
                ).save(failOnError: true)
                if( user ){
                    Empresa empresa = new Empresa(
                            giro: params?.giro,
                            razonSocial: params?.razonSocial,
                            rut: params?.rutEmpresa,
                            dv: params?.dvEmpresa,
                            direccion: params?.direccionEmpresa,
                            email: params?.emailEmpresa,
                            usuario: user,
                            enabled: false
                    ).save(failOnError: true)
                    if( empresa ){
                        if( asignarRolNuevo('ROLE_ADMIN', user) ){
                           try{
                               TipoPago tipoPago = new TipoPago().save(failOnError: true)
                               ConfiguracionEmpresa configuracionEmpresa = new ConfiguracionEmpresa(
                                       empresa: empresa,
                                       tipoPago: tipoPago
                               ).save(failOnError: true)
                           }catch(e){}
                        }else{
                            flash.message = "Ups! Ha ocurrido un error :( Por favor contáctate con nuestros canales de atención. No queremos que quedes fuera :)"
                            exito = false
                        }
                    }else{
                        try{
                            userService.delete(user?.id)
                        }catch(e){}
                        flash.message = "Ups! Ha ocurrido un error :( Por favor contáctate con nuestros canales de atención. No queremos que quedes fuera :)"
                        exito = false
                    }
                }else{
                    flash.message = "Ups! Ha ocurrido un error :( Por favor contáctate con nuestros canales de atención. No queremos que quedes fuera :)"
                    exito = false
                }
            }catch(e){
                flash.message = "Ups! Ha ocurrido un error :( Por favor contáctate con nuestros canales de atención. No queremos que quedes fuera :)"
                exito = false
            }
        }else{
            flash.message = "Rut Empresa o Rut Representante NO válido."
            exito = false
        }

        if( exito ){
            flash.message = 'Registro creado exitosamente! Dentro de las próximas 48 horas habilitaremos tu cuenta.'
        }
        redirect controller: 'user', action: 'registro'
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

    @Secured(['ROLE_SUPERUSER'])
    def solicitudEmpresa(){
        List<Empresa> empresaList = []
        try{
            empresaList = Empresa.createCriteria().list {
                and{
                    eq('enabled', false)
                    usuario{
                        eq('enabled', false)
                    }
                }
            }
        }catch(e){}

        respond empresaList
    }

    @Secured(['ROLE_SUPERUSER'])
    def aprobarSolicitud(Long id){
        Empresa empresa = Empresa.get(id)
        if( empresa ){
            try{
                empresa.enabled = true
                empresa.usuario.enabled = true
                empresaService.save(empresa)

                String template = groovyPageRenderer.render(template:  "/correos/activarCtaAdmin", model: [empresa: empresa])
                utilService.enviarCorreo(empresa?.usuario?.email, "noresponder@bookeame.cl", "Cuenta Aprobada", template  )

                flash.message = "Empresa aprobada correctamente."
            }catch(e){ flash.error = "Ups! Ha ocurrido un error."}
        }else{ flash.error = "Ups! Ha ocurrido un error."}

        redirect(controller: 'empresa', action: 'solicitudEmpresa')
    }

    def modificacionEmpresa(){
        List<CambioDatos> cambioDatosList = []
        try{
            cambioDatosList = CambioDatos.list()
        }catch(e){}

        respond cambioDatosList
    }

    @Secured(['ROLE_SUPERUSER'])
    def aprobarCambioDatos(Long id){
        try{
            CambioDatos cambioDatos = CambioDatos.get(id)
            Empresa empresa = cambioDatos?.empresa
            empresa.giro = cambioDatos?.giro
            empresa.razonSocial = cambioDatos?.razonSocial
            empresa.rut = cambioDatos?.rut
            empresa.dv = cambioDatos?.dv
            empresa.direccion = cambioDatos?.direccion
            empresa.usuario.nombre = cambioDatos?.nombre
            empresa.usuario.apellidoPaterno = cambioDatos?.apellidoPaterno
            empresa.usuario.apellidoMaterno = cambioDatos?.apellidoMaterno
            empresa.usuario.celular = cambioDatos?.celular
            empresa.usuario.fechaNac = cambioDatos?.fechaNac
            empresa.usuario.rutRepresentante = cambioDatos?.rutUser
            empresa.usuario.dvRepresentante = cambioDatos?.dvUser
            empresaService.save(empresa)
            cambioDatosService.delete(cambioDatos?.id)
            flash.message = "Cambio Aprobado Correctamente."
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'empresa', action: 'modificacionEmpresa')
    }

    @Secured(['ROLE_SUPERUSER'])
    def rachazarCambioDatos(Long id){
        try{
            cambioDatosService.delete(id)
            flash.message = "Cambio rechazado correctamente."
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'empresa', action: 'modificacionEmpresa')
    }

    @Secured(['ROLE_SUPERUSER'])
    def bannearUsuario( Long id ){
        try{
            Empresa empresa = Empresa.get(id)
            empresa?.usuario?.enabled = false
            empresa?.usuario?.accountLocked = true
            empresa?.enabled = false
            empresaService.save(empresa)
            flash.message = "Empresa y Usuario banneado correctamente."
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'empresa', action: 'index')
    }

    @Secured(['ROLE_SUPERUSER'])
    def desbannearUsuario(Long id){
        try{
            Empresa empresa = Empresa.get(id)
            empresa?.usuario?.enabled = true
            empresa?.usuario?.accountLocked = false
            empresa?.enabled = true
            empresaService.save(empresa)
            flash.message = "Empresa y Usuario Desbanneado correctamente."
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'empresa', action: 'index')
    }

    def showCambio(Long id){
        CambioDatos cambioDatos = CambioDatos.get(id)
        respond cambioDatos, model: [empresa: cambioDatos?.empresa]
    }

}
