package reserva

import auth.User
import empresa.Empresa
import espacio.DiaService
import espacio.Espacio
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class ReservaPeriodicaController {

    ReservaPlanificadaService reservaPlanificadaService
    def springSecurityService
    def validadorPermisosUtilService
    def groovyPageRenderer
    def utilService
    DiaService diaService
    ReservaUtilService reservaUtilService

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond reservaPlanificadaService.list(params), model:[reservaPlanificadaCount: reservaPlanificadaService.count()]
    }

    def show(Long id) {
        respond reservaPlanificadaService.get(id)
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def create() {
        try{
            User user = springSecurityService.getCurrentUser()
            Empresa empresa = Empresa.findByUsuario(user)

            List<ReservaPeriodica> reservaPlanificadaList = ReservaPeriodica.findAllByEmpresaAndFechaTerminoGreaterThanEquals(empresa, new Date() )
            List<Espacio> espacioList = Espacio.findAllByEmpresaAndEnabled(empresa, true)
            respond empresa, model: [ reservaPlanificadaList: reservaPlanificadaList, espacioList: espacioList ]

        }catch(e){
            render view: '/notFound'
            return false
        }
    }

    def save(ReservaPeriodica reservaPlanificada) {
        if (reservaPlanificada == null) {
            notFound()
            return
        }

        try {
            reservaPlanificadaService.save(reservaPlanificada)
        } catch (ValidationException e) {
            respond reservaPlanificada.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), reservaPlanificada.id])
                redirect reservaPlanificada
            }
            '*' { respond reservaPlanificada, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond reservaPlanificadaService.get(id)
    }

    def update(ReservaPeriodica reservaPlanificada) {
        if (reservaPlanificada == null) {
            notFound()
            return
        }

        try {
            reservaPlanificadaService.save(reservaPlanificada)
        } catch (ValidationException e) {
            respond reservaPlanificada.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), reservaPlanificada.id])
                redirect reservaPlanificada
            }
            '*'{ respond reservaPlanificada, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        reservaPlanificadaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'reservaPlanificada.label', default: 'ReservaPlanificada'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    @Transactional
    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def eliminarReservaPlanificada(Long id){
        try{
            ReservaPeriodica reservaPeriodica = ReservaPeriodica.get(id)
            User user = springSecurityService.getCurrentUser()

            if( user?.id == reservaPeriodica?.empresa?.usuario?.id && reservaPeriodica){
                // Obtén las reservas asociadas
                def reservasAsociadas = reservaPeriodica.reservas.toList()
                // Desvincula las reservas de la ReservaPeriodica
                reservaPeriodica.reservas.clear()
                // Guarda la ReservaPeriodica después de desvincular las reservas
                reservaPeriodica.save(flush: true, failOnError: true)
                // Elimina las reservas desvinculadas
                reservasAsociadas.each { Reserva reserva ->
                    reserva.delete(flush: true, failOnError: true)
                }
                // Finalmente, elimina la ReservaPeriodica
                reservaPeriodica.delete(flush: true, failOnError: true)

                flash.message = "Reservas Periódicas eliminadas correctamente."
            }else{
                flash.error = "Ups! Ha ocurrido un error."
            }
        }catch(e){
            flash.error = "Ups! Ha ocurrido un error."
        }
        redirect(controller: 'reservaPeriodica', action: 'create')
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def crearPlanificada(Long id){
        List<Reserva> reservaList = []
        String hini = "${params?.horaInicio}:${params?.minInicio}"
        String hter = "${params?.horaTermino}:${params?.minTermino}"
        Espacio espacio = new Espacio()
        if( (utilService?.validarHorario(hini) < utilService?.validarHorario(hter))
                && ( params?.fechaInicio != null && params?.fechaInicio?.length() > 0 )
                &&  ( params?.fechaTermino != null && params?.fechaTermino?.length() > 0 ))
        {
            try{
                ReservaPeriodica reservaPeriodica = new ReservaPeriodica()
                espacio = Espacio.get(params?.espacio?.toInteger())
                def fechaInicio = sdf.parse(params?.fechaInicio)
                def fechaTermino = sdf.parse(params?.fechaTermino)
                reservaPeriodica.fechaInicio = fechaInicio <= fechaTermino ? fechaInicio : fechaTermino
                reservaPeriodica.fechaTermino = fechaTermino >= fechaInicio ? fechaTermino : fechaInicio
                reservaPeriodica.horaInicio = hini
                reservaPeriodica.horaTermino = hter
                reservaPeriodica.espacio = espacio
                reservaPeriodica.empresa = espacio?.empresa
                reservaPeriodica.usuario = User.findById( params?.usuario.toLong() )
                reservaPeriodica.valorPorReserva = params?.valorPorReserva.toInteger()

                Dia dia = new Dia()
                dia.lunes = params?.lunes ? true : false
                dia.martes = params?.martes ? true : false
                dia.miercoles = params?.miercoles ? true : false
                dia.jueves = params?.jueves ? true : false
                dia.viernes = params?.viernes ? true : false
                dia.sabado = params?.sabado ? true : false
                dia.domingo = params?.domingo ? true : false
                diaService.save(dia)

                reservaPeriodica.dias = dia
                reservaList = crearReservasPlanificadas(reservaPeriodica)

                if( reservaList?.size() == 0 ){
                    flash.error = "No se han creado reservas. Por favor intenta nuevamente."
                    redirect(controller: 'reservaPeriodica', action: 'create' )
                    return
                }

                reservaPeriodica.reservas = reservaList
                // dice reserva planificada pero el service esta con reserva periodica
                reservaPlanificadaService.save(reservaPeriodica)
                flash.message = "Reservas Planificadas creadas exitosamente!"

                String template = groovyPageRenderer.render(template:  "/correos/confirmacionUserMasivo", model: [user: reservaPeriodica?.usuario, reservaPlanificada: reservaPeriodica])
                utilService.enviarCorreo(reservaPeriodica?.usuario?.email, "noresponder@bookeame.cl", "Tienes reservas a tu nombre", template)

            }catch(e){ flash.error = "Ups! Ha ocurrido un error."}
            render(view: 'reservasPlanificadasList', model: [reservaList: reservaList, espacio: espacio])
        }else{
            flash.error = "Fechas u Horas NO válidas"
            redirect(controller: 'reservaPeriodica', action: 'create' )
        }

    }

    List<Reserva> crearReservasPlanificadas(ReservaPeriodica reservaPeriodica ){
        List<Reserva> reservaList = []

        Calendar p = Calendar.getInstance()
        Calendar h = Calendar.getInstance()
        try{
            p.setTime(reservaPeriodica?.fechaInicio)
            h.setTime(reservaPeriodica?.fechaTermino)

            Reserva aux = new Reserva()
            Modulo modulo = new Modulo(
                    horaInicio: reservaPeriodica?.horaInicio,
                    horaTermino: reservaPeriodica?.horaTermino,
                    espacio: reservaPeriodica?.espacio
            )
            while( p.getTime() <= h.getTime() ){
                Date fechaAux = p.getTime()
                if( diaHabilitado(p.get(Calendar.DAY_OF_WEEK), reservaPeriodica?.dias )
                    && reservaUtilService?.reservaDisponible(modulo, formatFecha(fechaAux, "dd-MM-yyyy") ) ){
                    aux = new Reserva(
                            usuario: reservaPeriodica?.usuario,
                            fechaReserva: p.getTime(),
                            horaInicio: reservaPeriodica?.horaInicio,
                            horaTermino: reservaPeriodica?.horaTermino,
                            valor: reservaPeriodica?.valorPorReserva,
                            espacio: reservaPeriodica?.espacio,
                            tipoReserva: TipoReserva.get(3),
                            estadoReserva: EstadoReserva.get(2)
                    ).save()

                    if( aux != null ){
                        reservaList.add(aux)
                    }

                }
                p.add(Calendar.DAY_OF_YEAR, 1)
            }
        }catch(e){
            return reservaList
        }
        return reservaList
    }

    Boolean diaHabilitado(int valorDia, Dia dias){
        switch (valorDia){
            case 1:
                return dias?.domingo
                break
            case 2:
                return dias?.lunes
                break
            case 3:
                return dias?.martes
                break
            case 4:
                return dias?.miercoles
                break
            case 5:
                return dias?.jueves
                break
            case 6:
                return dias?.viernes
                break
            case 7:
                return dias?.sabado
                break
        }
    }

    String formatFecha(Date fecha, String patron){
        try{
            SimpleDateFormat sdf = new SimpleDateFormat(patron)
            def aux = sdf.format(fecha)
            return aux
        }catch(e){
            log.error(e)
        }
    }
}
