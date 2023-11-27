package reserva

import auth.User
import empresa.Empresa
import espacio.DiaService
import espacio.Espacio
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
    def create(Long id) {
        try{
            if( !validadorPermisosUtilService?.validarRelacionEmpresaUser(id) ){
                render view: '/notFound'
                return false
            }

            Empresa empresa = Empresa.get(id)

            List<ReservaPeriodica> reservaPlanificadaList = ReservaPeriodica.findAllByEmpresaAndFechaTerminoGreaterThanEquals(empresa, new Date() )
            respond empresa, model: [ reservaPlanificadaList: reservaPlanificadaList ]

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

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def eliminarReservaPlanificada(Long id){
        ReservaPeriodica reservaPlanificada = ReservaPeriodica.get(id)
        def espacioId = reservaPlanificada?.espacioId
        try{
            User user = springSecurityService.getCurrentUser()
            if( user?.id == reservaPlanificada?.empresa?.usuario?.id ){
                reservaPlanificadaService.delete(reservaPlanificada?.id)
                flash.message = "Reserva Planificada eliminada correctamente."
            }else{
                flash.error = "Ups! Ha ocurrido un error."
            }
        }catch(e){
            flash.error = "Ups! Ha ocurrido un error."
        }
        redirect(controller: 'reserva', action: 'reservaPlanificada', id: espacioId)
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def crearPlanificada(Long id){
        List<Reserva> reservaList = []
        String hini = "${params?.horaInicio}:${params?.minInicio}"
        String hter = "${params?.horaTermino}:${params?.minTermino}"
        Espacio espacio = new Espacio()
        if( (utilService?.validarHorario(hini) < utilService?.validarHorario(hter)) && ( params?.fechaInicio != null && params?.fechaInicio?.length() > 0 ) &&  ( params?.fechaTermino != null && params?.fechaTermino?.length() > 0 )){
            try{
                ReservaPeriodica reservaPlanificada = new ReservaPeriodica()
                espacio = Espacio.get(id)
                def fechaInicio = sdf.parse(params?.fechaInicio)
                def fechaTermino = sdf.parse(params?.fechaTermino)
                reservaPlanificada.fechaInicio = fechaInicio <= fechaTermino ? fechaInicio : fechaTermino
                reservaPlanificada.fechaTermino = fechaTermino >= fechaInicio ? fechaTermino : fechaInicio
                reservaPlanificada.horaInicio = hini
                reservaPlanificada.horaTermino = hter
                reservaPlanificada.espacio = espacio
                reservaPlanificada.empresa = espacio?.empresa
                reservaPlanificada.usuario = User.findById( params?.usuario.toLong() )
                reservaPlanificada.valorPorReserva = params?.valorPorReserva.toInteger()

                Dia dia = new Dia()
                dia.lunes = params?.lunes ? true : false
                dia.martes = params?.martes ? true : false
                dia.miercoles = params?.miercoles ? true : false
                dia.jueves = params?.jueves ? true : false
                dia.viernes = params?.viernes ? true : false
                dia.sabado = params?.sabado ? true : false
                dia.domingo = params?.domingo ? true : false
                diaService.save(dia)

                reservaPlanificada.dias = dia
                reservaList = crearReservasPlanificadas(reservaPlanificada)
                reservaPlanificadaService.save(reservaPlanificada)
                flash.message = "Reservas Planificadas creadas exitosamente!"

                String template = groovyPageRenderer.render(template:  "/correos/confirmacionUserMasivo", model: [user: reservaPlanificada?.usuario, reservaPlanificada: reservaPlanificada])
                utilService.enviarCorreo(reservaPlanificada?.usuario?.email, "noresponder@bookeame.cl", "Tienes reservas a tu nombre", template)

            }catch(e){ flash.error = "Ups! Ha ocurrido un error."}
            render(view: 'reservasPlanificadasList', model: [reservaList: reservaList, espacio: espacio])
        }else{
            flash.error = "Fechas u Horas NO válidas"
            redirect(controller: 'reserva', action: 'reservaPlanificada', id: id )
        }

    }

    List<Reserva> crearReservasPlanificadas(ReservaPeriodica reservaPlanificada ){
        List<Reserva> reservaList = []

        Calendar p = Calendar.getInstance()
        Calendar h = Calendar.getInstance()
        try{
            p.setTime(reservaPlanificada?.fechaInicio)
            h.setTime(reservaPlanificada?.fechaTermino)

            while( p.getTime() <= h.getTime() ){
                if( diaHabilitado(p.get(Calendar.DAY_OF_WEEK), reservaPlanificada?.dias ) ){
                    if( esHorarioLibre(p.getTime(), reservaPlanificada?.espacio?.id, reservaPlanificada?.horaInicio, reservaPlanificada?.horaTermino ) ){
                        reservaList.add(
                                new Reserva(
                                        usuario: reservaPlanificada?.usuario,
                                        fechaReserva: p.getTime(),
                                        horaInicio: reservaPlanificada?.horaInicio,
                                        horaTermino: reservaPlanificada?.horaTermino,
                                        valor: reservaPlanificada?.valorPorReserva,
                                        espacio: reservaPlanificada?.espacio,
                                        tipoReserva: TipoReserva.get(3),
                                        estadoReserva: EstadoReserva.get(2)
                                ).save()
                        )
                    }
                }
                p.add(Calendar.DAY_OF_YEAR, 1)
            }
        }catch(e){}
        return reservaList
    }
}
