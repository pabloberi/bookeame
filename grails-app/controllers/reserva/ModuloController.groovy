package reserva

import espacio.DiaService
import espacio.Espacio
import espacio.ModuloService
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.apache.commons.validator.Form

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class ModuloController {

    ModuloService moduloService
    DiaService diaService
    def utilService

    static allowedMethods = [save: "POST", update: "PUT", delete: "POST"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond moduloService.list(params), model:[moduloCount: moduloService.count()]
    }

    def show(Long id) {
        respond moduloService.get(id)
    }

    def create() {
        respond new Modulo(params)
    }

    def save(Modulo modulo) {
        if (modulo == null) {
            notFound()
            return
        }

        try {
            moduloService.save(modulo)
        } catch (ValidationException e) {
            respond modulo.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'modulo.label', default: 'Modulo'), modulo.id])
                redirect modulo
            }
            '*' { respond modulo, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond moduloService.get(id)
    }

    def update(Modulo modulo) {
        if (modulo == null) {
            notFound()
            return
        }

        try {
            moduloService.save(modulo)
        } catch (ValidationException e) {
            respond modulo.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'modulo.label', default: 'Modulo'), modulo.id])
                redirect modulo
            }
            '*'{ respond modulo, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        moduloService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'modulo.label', default: 'Modulo'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'modulo.label', default: 'Modulo'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def insertarForm(Long id){
        Espacio espacio = Espacio.findById(id)
        render template: '/espacio/formModuloCreate', model: [espacio: espacio]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def insertarFormMasivo(Long id){
        Espacio espacio = Espacio.findById(id)
        render template: '/espacio/formModuloCreateMasivo', model: [espacio: espacio]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def crearModulo(Long id){
        Espacio espacio = Espacio.findById(id)
        Modulo modulo = new Modulo()
        Dia dia = new Dia()
        boolean exito = true
        String hini = "${params?.horaInicio}:${params?.minInicio}"
        String hter = "${params?.horaTermino}:${params?.minTermino}"
        if( utilService?.validarHorario(hini) < utilService?.validarHorario(hter) ){
            if(espacio){
                dia.lunes = params?.lunes ? true : false
                dia.martes = params?.martes ? true : false
                dia.miercoles = params?.miercoles ? true : false
                dia.jueves = params?.jueves ? true : false
                dia.viernes = params?.viernes ? true : false
                dia.sabado = params?.sabado ? true : false
                dia.domingo = params?.domingo ? true : false
                try{
                    diaService.save(dia)
                }catch(e){
                    exito = false
                }
                if(dia != null && exito == true){
                    modulo.horaInicio = hini
                    modulo.horaTermino = hter
                    modulo.espacio = espacio
                    modulo.dias = dia
                    modulo.valor = params?.valor.toInteger()
                    try{
                        moduloService.save(modulo)
                    }catch(e){
                        exito = false
                        diaService.delete(dia?.id)
                    }
                }else{
                    exito = false
                }
            }else{
                exito = false
            }
        }else{
            exito = false
        }

        if(exito){
            flash.message = "Módulo registrado exitosamente!"
        }else{
            flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde."
        }
        redirect(controller: 'espacio', action: 'modulos', id: espacio?.id)
    }

//    Integer validarHorario(String hora ){
//        if( hora ){
//            def posHorario = hora?.indexOf(' ') + 1
//            def posPuntos = hora?.indexOf(':')
//            String horario = hora?.substring(posHorario, hora?.length())
//            String hour = hora?.substring(0,posPuntos)
//            String minutes = hora?.substring(posPuntos + 1 , hora?.size())
//            if( hour?.size() == 1 ){
//                Formatter frm = new Formatter()
//                frm.format("%02d",hour?.toInteger())
//                hour = frm.toString()
//            }
//            if( minutes?.size() == 1){
//                Formatter min = new Formatter()
//                min?.format("%02d", minutes?.toInteger())
//                minutes = min?.toString()
//            }
//            def aux =  hour + minutes
//            return aux.toInteger()
//        }
//    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def editarModulo(Long id){
        Modulo modulo = Modulo.findById(id)
        Dia dia = Dia.findById(modulo?.dias?.id)
        boolean exito = true
        String hini = "${params?.horaInicio}:${params?.minInicio}"
        String hter = "${params?.horaTermino}:${params?.minTermino}"
        if( utilService?.validarHorario(hini) < utilService?.validarHorario(hter) ){
            if (modulo) {
                dia.lunes = params?.lunes ? true : false
                dia.martes = params?.martes ? true : false
                dia.miercoles = params?.miercoles ? true : false
                dia.jueves = params?.jueves ? true : false
                dia.viernes = params?.viernes ? true : false
                dia.sabado = params?.sabado ? true : false
                dia.domingo = params?.domingo ? true : false
                modulo.horaInicio = hini
                modulo.horaTermino = hter
                modulo.valor = params?.valor.toInteger()
                try {
                    diaService.save(dia)
                    moduloService.save(modulo)
                } catch (e) {
                    exito = false
                }
            } else {
                exito = false
            }
        }else{
            exito = false
        }
        if(exito){
            flash.message = "Módulo editado exitosamente!"
        }else{
            flash.error = "Ups! no se pudo actualizar la información. Por favor intenta más tarde."
        }
        redirect(controller: 'espacio', action: 'modulos', id: modulo?.espacio?.id)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def eliminarModulo(Long id){
        Modulo modulo = Modulo.findById(id)
        Long espacioId = modulo?.espacio?.id
        Long diaId = modulo?.dias?.id
        boolean exito = true
        try{
            moduloService.delete(modulo?.id)
        }catch(e){
            exito = false
        }
        if( exito ){
            try {
                diaService.delete(diaId)
            }catch(e){
                exito = false
            }
        }
        if( exito ){
            flash.message = "Módulo eliminado correctamente!"
        }else{
            flash.error = "Ups! no pudimos eliminar el módulo."
        }
        redirect(controller: 'espacio', action: 'modulos', id: espacioId)
    }

    String formatHora(String hora){
        if( hora ){
            def posHorario = hora?.indexOf(' ') + 1
            def posPuntos = hora?.indexOf(':')
            String horario = hora?.substring(posHorario, hora?.length())
            String hour = hora?.substring(0,posPuntos)
            String minutes = hora?.substring(posPuntos + 1 , hora?.size())
            if( hour?.size() == 1 ){
                Formatter frm = new Formatter()
                frm.format("%02d",hour?.toInteger())
                hour = frm.toString()
            }
            if( minutes?.size() == 1){
                Formatter min = new Formatter()
                min?.format("%02d", minutes?.toInteger())
                minutes = min?.toString()
            }
            return hour + ":" + minutes
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def crearMasivo(Long id){
        try{
            Espacio espacio = Espacio.get(id)
            if( espacio ){
                String horaInicio = "${params?.horaInicio}:${params?.minInicio}"
                String horaTermino = "${params?.horaTermino}:${params?.minTermino}"
                Integer valor = params?.valor.toInteger()
                Integer tiempoMuerto = params?.tiempoMuerto.toInteger()
                Integer duracion = params?.duracion.toInteger()
                for ( horario in listarHorario( horaInicio, horaTermino, tiempoMuerto, duracion ) ){
                    Dia dia = new Dia()
                    dia.lunes = params?.lunes ? true : false
                    dia.martes = params?.martes ? true : false
                    dia.miercoles = params?.miercoles ? true : false
                    dia.jueves = params?.jueves ? true : false
                    dia.viernes = params?.viernes ? true : false
                    dia.sabado = params?.sabado ? true : false
                    dia.domingo = params?.domingo ? true : false
                    diaService.save(dia)
                    agregarModulo(espacio, horario[0], horario[1], valor, dia)
                }
                flash.message = "Módulos creados correctamente."
            }
        }catch(e){
            flash.error = "Ups! Ha ocurrido un error."
        }
        redirect( controller: 'espacio', action: 'modulos', id: id )
    }

    ArrayList listarHorario(String horaInicio, String horaTermino, Integer tiempoMuerto, Integer duracion){
        def horarioList = []
        try{
            Calendar apertura = Calendar.getInstance()
            Calendar cierre =  Calendar.getInstance()
            Integer horaApertura =  horaInicio.substring(0,2).toInteger()
            Integer horaCierre = horaTermino.substring(0,2).toInteger()

            if( horaCierre < horaApertura){
                cierre.add(Calendar.DAY_OF_MONTH, 1)
            }

            apertura.set( Calendar.HOUR_OF_DAY, horaApertura )
            apertura.set( Calendar.MINUTE, horaInicio.substring(3,5).toInteger() )

            cierre.set( Calendar.HOUR_OF_DAY, horaCierre )
            cierre.set( Calendar.MINUTE, horaTermino.substring(3,5).toInteger() )

            while ( apertura.getTime() < cierre.getTime() ){
                Formatter fmHrInicio = new Formatter()
                Formatter fmMinInicio = new Formatter()

                Formatter fmHrFin = new Formatter()
                Formatter fmMinFin = new Formatter()

                Integer horaStart = apertura.get(Calendar.HOUR_OF_DAY)
                Integer minStart = apertura.get(Calendar.MINUTE)
                fmHrInicio.format("%02d",horaStart)
                fmMinInicio.format("%02d",minStart)

                apertura.add(Calendar.MINUTE, duracion)

                Integer horaFinish = apertura.get(Calendar.HOUR_OF_DAY)
                Integer minFinish = apertura.get(Calendar.MINUTE)
                fmHrFin.format("%02d",horaFinish)
                fmMinFin.format("%02d",minFinish)

                horarioList.add([ fmHrInicio.toString() + ":" + fmMinInicio.toString() , fmHrFin.toString() + ":" + fmMinFin.toString() ])
                if ( tiempoMuerto > 0 ){
                    apertura.add(Calendar.MINUTE, tiempoMuerto)
                }
            }
        }catch(e){}

        return horarioList
    }

    void agregarModulo(Espacio espacio, String horaInicio, String horaTermino, Integer valor, Dia dia){
        try{
            Modulo modulo = new Modulo()
            modulo.espacio = espacio
            modulo.horaInicio = horaInicio
            modulo.horaTermino = horaTermino
            modulo.valor = valor
            modulo.dias = dia

            moduloService.save(modulo)
        }catch(e){}
    }

}
