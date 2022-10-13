package espacio

import auth.User
import gestion.General
import empresa.Empresa
import reserva.Dia
import reserva.Modulo
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import ubicacion.Comuna
import ubicacion.Provincia
import ubicacion.Region

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class EspacioController {

    EspacioService espacioService
    ModuloService moduloService
    DiaService diaService
    def springSecurityService
    def utilService
    def mailService
    def groovyPageRenderer

    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def index(Integer max) {
        User user = springSecurityService.getCurrentUser()
        if(user.authorities.findAll().find { it -> it.authority == "ROLE_ADMIN" } ){
            List<Espacio> espacioList = Espacio.createCriteria().list {
                and{
                    empresa{
                        usuario{
                            eq('id', user?.id )
                        }
                    }
                }
            }
            respond espacioList
        }
        if(user.authorities.findAll().find { it -> it.authority == "ROLE_SUPERUSER" } ){
            params.max = Math.min(max ?: 10, 100)
            respond espacioService.list(params), model:[espacioCount: espacioService.count()]
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def show(Long id) {
        if(validarRelacionEspacioUser(id)){
            respond espacioService.get(id)
        }else{
            render view: '/notFound'
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def create() {
        respond new Espacio(params)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def save(Espacio espacio) {
        if (espacio == null) {
            notFound()
            return
        }

        try {
            espacio.enabled = params?.enabled ? true : false

            User user = springSecurityService.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)
            espacio.empresa = empresa
//            espacio.latitud = new Float(params?.latitud)
//            espacio.longitud = new Float(params?.longitud)
            espacio.comuna = Comuna.findById( params?.comuna.toInteger() )
            espacio.direccion = params?.direccion
            espacioService.save(espacio)

            def doc = request.getFile('espacioFoto')

            if( !doc.empty ){
                String nombreArchivo = "espacio" + espacio?.id
                String extension = utilService.obtenerExtension(doc.filename)
                InputStream docIS = doc.inputStream
                def path = General.findByNombre('pathImg')?.valor + "espacios/" + espacio?.id + "/"
                utilService.uploadFile(docIS.bytes, nombreArchivo + extension, path)

                espacio.foto = nombreArchivo + extension
                espacio.extension = extension
                espacioService.save(espacio)
            }
        } catch (ValidationException e) {
            respond espacio.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = "Espacio Creado Correctamente!"
                redirect espacio
            }
            '*' { respond espacio, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def edit(Long id) {
        respond espacioService.get(id)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def update(Espacio espacio) {
        String mensaje
        if (espacio == null) {
            notFound()
            return
        }

        try {
//            espacio.latitud = new Float(params?.latitud)
//            espacio.longitud = new Float(params?.longitud)
            espacio.comuna = Comuna.findById( params?.comuna.toInteger() )
            espacio.direccion = params?.direccion
            espacio.enabled = params?.enabled ? true : false
            def doc = request.getFile('espacioFoto')

            if( !doc.empty ){
                String nombreArchivo = "espacio" + espacio?.id
                String extension = utilService.obtenerExtension(doc.filename)
                InputStream docIS = doc.inputStream
                def path = General.findByNombre('pathImg')?.valor + "espacios/" + espacio?.id + "/"
                utilService.uploadFile(docIS.bytes, nombreArchivo + extension, path)

                espacio.foto = nombreArchivo + extension
                espacio.extension = extension
                espacioService.save(espacio)
            }
            espacioService.save(espacio)
            mensaje = "Espacio editado correctamente."
        } catch (ValidationException e) {
            respond espacio.errors, view:'edit'
            mensaje = "Ha ocurrido un error."
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = mensaje
                redirect espacio
            }
            '*'{ respond espacio, [status: OK] }
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        espacioService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'espacio.label', default: 'Espacio'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'espacio.label', default: 'Espacio'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    Boolean validarRelacionEspacioUser(Long espacioId){
        Espacio espacio = Espacio.findById(espacioId)
        User user = springSecurityService.getCurrentUser()

        if( espacio && user ){
            Empresa empresa = Empresa.findByUsuario(user)
            if( empresa?.id == espacio?.empresaId ){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def editarCampo(Long id){
        Espacio espacio = Espacio.findById(id)
        boolean exito = true
        def valor
        def campo
        if( espacio ){
            try{
                for( value in params ){
                    campo = value?.key
                    if( value?.key == 'tiempoArriendo' || value?.key == 'capacidad' ) {
                        valor = value?.value.toInteger()
                    } else{
                        valor = value?.value
                    }
                    if( value?.key == 'tipoEspacio' ){
                        valor = TipoEspacio?.findById(value?.value.toInteger())
                    }
                    if( value?.key == 'enabledCheck' ){
                        valor = true
                        campo = 'enabled'
                    }
                    if( value?.key == 'controller' ){
                        valor = false
                        campo = 'enabled'
                    }
                    espacio.setProperty( campo, valor )
                    break
                }
                espacioService.save(espacio)
            }catch(e){ exito = false }
        }else{ exito = false }

        if( exito ){ flash.message = "Campo editado correctamente!" }else{ flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde." }
        redirect( controller: 'espacio', action: 'show', id: espacio?.id)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def modulos(Long id){
        Espacio espacio = Espacio.findById(id)
        List<Modulo> moduloList
        if(validarRelacionEspacioUser(id)){
            moduloList = Modulo.findAllByEspacio(espacio)
            respond espacio, model: [moduloList: moduloList]
        }else{
            render view: '/notFound'
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def edicionMasivaModulos(Long id){
        Espacio espacio = Espacio.findById(id)
        List<Modulo> moduloList
        if(validarRelacionEspacioUser(id)){
            moduloList = Modulo.findAllByEspacio(espacio)
            def lunes = params?.lunes ? true : false
            def martes = params?.martes ? true : false
            def miercoles = params?.miercoles ? true : false
            def jueves = params?.jueves ? true : false
            def viernes = params?.viernes ? true : false
            def sabado = params?.sabado ? true : false
            def domingo = params?.domingo ? true : false

            for( md in moduloList ){
                Dia dia = md?.dias
                dia?.lunes = lunes
                dia?.martes = martes
                dia?.miercoles = miercoles
                dia?.jueves = jueves
                dia?.viernes = viernes
                dia?.sabado = sabado
                dia?.domingo = domingo
                dia.save()
                try{
                    diaService.save(dia)
                }catch(e){}
            }
            redirect( controller: 'espacio', action: 'modulos', id: espacio?.id)
        }else{
            render view: '/notFound'
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def editarDireccion(Long id){
        boolean exito = true
        Espacio espacio = Espacio.findById(id)
        if( espacio ){
            espacio.latitud = new Float(params?.latitud)
            espacio.longitud = new Float(params?.longitud)
            try{
                espacioService.save(espacio)
            }catch(e){ exito = false }
        }else{ exito = false }

        if( exito ){ flash.message = "Campo editado correctamente!" }else{ flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde."  }

        redirect( controller: 'espacio', action: 'show', id: espacio?.id)
    }

    def editarEspacio(Long id){
        boolean exito = true
        try{
            Espacio espacio = Espacio.findById(id)
            espacio.nombre = params?.nombre
        }catch(e){

        }
    }

    def cargarComuna(Long regionId){
        List<Comuna> comunaList = []
        if( regionId ){
            try{
                Region region =  Region.findById(regionId)
                List<Provincia> provinciaList =  Provincia.findAllByRegion(region)
                for( provincia in  provinciaList ){
                    comunaList.addAll( Comuna.findAllByProvincia(provincia) )
                }
            }catch(e){}
        }
        render g.select(id: 'comuna', name: 'comuna',required: 'required', from: comunaList.sort { it?.comuna } , optionKey: 'id', noSelection: ['':'- Seleccione Comuna -'], class: "form-control select2", style:"width: 100%;" )
    }

}
