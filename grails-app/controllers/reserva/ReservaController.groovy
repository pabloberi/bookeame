package reserva

import auth.Role
import auth.User
import auth.UserRole
import auth.UserService
import configuracionEmpresa.ConfiguracionEmpresa
import dto.EventoCalendario
import dto.CrearReservaRs
import dto.ModuloDto
import espacio.DiaService
import flow.FlowEmpresa
import gestion.EncryptionUtilsService
import gestion.General
import empresa.Empresa
import espacio.Espacio
import espacio.EspacioService
import evaluacion.Evaluacion
import evaluacion.EvaluacionService
import evaluacion.EvaluacionToEspacio
import gestion.NotificationService
import grails.plugin.springsecurity.annotation.Secured
import politicas.PoliticaReserva
import servicios.Servicio
import servicios.ServicioReserva
import servicios.ServicioUtilService

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class ReservaController {

    ReservaService reservaService
    EvaluacionService evaluacionService
    EspacioService espacioService
    ReservaTempService reservaTempService
    NotificationService notificationService

    ReservaUtilService reservaUtilService
    PrepagoUtilService  prepagoUtilService
    ServicioUtilService servicioUtilService

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")
    def springSecurityService
    def flowService
    def groovyPageRenderer
    def utilService
    def validaPermisosReservaUtilService
    def formatoFechaUtilService
    def validadorPermisosUtilService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def show(Long id) {
        if(validadorPermisosUtilService?.validarRelacionReservaUser(id)){
            Reserva reserva = reservaService.get(id)
            try{
                List<ServicioReserva> servicioReservaList = servicioUtilService.getServiciosPorReserva(reserva?.id)
                if(validadorPermisosUtilService.esRoleAdmin()){
                    ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa)?.fono
                    respond reserva, model: [
                            esReservaVigente: validaPermisosReservaUtilService?.esReservaVigente(reserva),
                            esReservaPosPagoPendiente: validaPermisosReservaUtilService?.esReservaPosPagoPendiente(reserva),
                            esReservaHistorica: validaPermisosReservaUtilService?.esReservaHistorica(reserva),
                            configuracion: ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa),
                            servicioReservaList: servicioReservaList,
                            valor: reservaUtilService.getValorReserva(reserva?.id)
                    ]
                }
                if(validadorPermisosUtilService.esRoleUser()){
                    ConfiguracionEmpresa configuracion = ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa)
                    List<PoliticaReserva> politicaReservaList = PoliticaReserva.findAllByEmpresa(reserva?.espacio?.empresa)
                    respond reserva, model: [
                            hoy: new Date(),
                            configuracion: configuracion,
                            puedeCancelar: validadorPermisosUtilService.userPuedeCancelarReserva(reserva,configuracion),
                            puedeReagendar: validadorPermisosUtilService.userPuedeReagendarReserva(reserva, configuracion),
                            servicioReservaList: servicioReservaList,
                            valor: reservaUtilService.getValorReserva(reserva?.id),
                            politicaReservaList: politicaReservaList
                    ]
                }
            }catch(e){
                render view: '/error'
            }
        }else{
            render view: '/notFound'
        }
    }

    def selectServicio(Long id){
        try{
            Espacio espacio = Espacio.findById(id)
            List<Servicio> servicioList = reservaUtilService?.getServiciosPorEspacio(id)
            if( servicioList?.size() > 0 ){
                respond servicioList, model:[espacio:espacio, botonVolver: true]
                return
            }
            redirect( controller: 'reserva', action: 'calendario', id: espacio?.id)
        }catch(Exception e){
            log.error(e)
            flash.error = "Ha ocurrido un error inesperado. Por favor intenta más tarde."
        }

    }

    def calendarioServicio(Long id){
        List<EventoCalendario> eventoList = []

        try{
            Espacio espacio = Espacio.get(id)
            Servicio servicio = Servicio.get(params?.servicio?.toLong())
            if( servicio == null ){
                redirect(controller: 'reserva', action: 'selectServicio', id: id )
                return
            }
            eventoList = reservaUtilService.getEventosCalendario(espacio?.id, servicio?.id)
            if( servicio?.duracionAdicional > 0 ){
                eventoList = reservaUtilService?.filtrarModulosPorServicio(eventoList, servicio?.id)
            }

            if( validadorPermisosUtilService?.esRoleUser() ){
                eventoList.removeAll{ eli -> eli?.getTitle() == "Reservado" }
                // ESTE IF ES PARA LAS ALARMAS
                List<Reserva> reservas = Reserva.findAllByEspacioAndInicioExactoGreaterThan(espacio, new Date() )
                List<PoliticaReserva> politicaReservaList = PoliticaReserva.findAllByEmpresa(espacio?.empresa)
                render(view: 'calendario', model: [eventoList: eventoList,
                                                   reservas: reservas,
                                                   espacio: espacio,
                                                   politicaReservaList: politicaReservaList
                ])
                return
            }
            render(view: 'calendario', model: [eventoList: eventoList, espacio: espacio, servicio: servicio])
            return
        }catch(Exception e){
            log.error(e)
            flash.error = "Ha ocurrido un error inesperado. Por favor intenta más tarde."
            redirect(controller: 'reserva', action: 'selectServicio', id: id )
            return
        }
    }

    def calendario(Long id){
        List<EventoCalendario> eventoList = []
        Espacio espacio = Espacio.findById(id)
        try{
            eventoList = reservaUtilService.getEventosCalendario(espacio?.id, null)
            if( validadorPermisosUtilService?.esRoleUser() ){ // ESTE IF ES PARA LAS ALARMAS
                List<Reserva> reservas = Reserva.findAllByEspacioAndInicioExactoGreaterThan(espacio, new Date() )
                List<PoliticaReserva> politicaReservaList = PoliticaReserva.findAllByEmpresa(espacio?.empresa)
                respond espacio, model: [eventoList: eventoList,
                                         reservas: reservas,
                                         politicaReservaList: politicaReservaList
                ]
                return
            }
        }catch(e){
            log.error(e)
            flash.error = "Ha ocurrido un error inesperado. Por favor intenta más tarde."
        }
        respond espacio, model: [eventoList: eventoList]
    }

    def create(String fecha, String moduloId, Long id, Long servicioId) {
        List<Servicio> servicioList = []
        String horaTermino
        Integer valor
        ModuloDto moduloDto = new ModuloDto()

        try{
            if( reservaUtilService?.puedeCrearReserva(moduloId?.toLong(), id, fecha) ){
                Espacio espacio = Espacio.get( id )
                Modulo modulo = Modulo.get( moduloId?.toLong() )
                ConfiguracionEmpresa configuracion = ConfiguracionEmpresa.findByEmpresa(espacio?.empresa)
                Date fechaCompleta = formatoFechaUtilService?.stringToDateConverter( fecha, "dd-MM-yyyy" )
                Servicio servicio = Servicio.get(servicioId)
                FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa(espacio?.empresa)
                if( servicio != null && servicio?.duracionAdicional > 0){
                    horaTermino = reservaUtilService?.nuevaHoraInicio(modulo?.horaInicio, servicio?.duracionAdicional)
                    valor = servicio?.valor
                }else{
                    horaTermino = modulo?.horaTermino
                    valor = modulo?.valor
                }
                moduloDto = reservaUtilService?.convertModuloToDto(modulo, horaTermino, valor)

                respond espacio, model: [   modulo:         modulo,
                                            horaTermino:    horaTermino,
                                            valor:          valor,
                                            fecha:          fechaCompleta,
                                            fechaReserva:   fecha,
                                            prepago:        configuracion?.tipoPago?.prepago,
                                            pospago:        configuracion?.tipoPago?.pospago,
                                            token:          reservaUtilService?.encriptarDatosReserva(moduloDto,espacio,fecha),
                                            reserva:        new Reserva(params),
                                            comision:       prepagoUtilService?.costoTransaccion(modulo?.valor,
                                                    flowEmpresa.comision?.valor) ?:0,
                                            servicio: servicio,
                                            cobroComision:  flowEmpresa?.comision?.valor ?:0,
                                            textoBotonPrepago: reservaUtilService?.textoValorPrepago(flowEmpresa?.comision?.valor ?: 0)
                ]
            }else{
                flash.error = "Ha ocurrido un error inesperado. Por favor intenta más tarde."
                redirect(controller: 'home', action: 'dashboard')
            }
        }catch(e){
            log.error(e)
            flash.error = "Ha ocurrido un error inesperado. Por favor intenta más tarde."
            redirect(controller: 'home', action: 'dashboard')
        }
    }

    @Secured(['ROLE_USER'])
    def save() {
        try{
            CrearReservaRs crearReservaRs = reservaUtilService.crearReserva( params, params?.tipoReservaId?.toLong() )
            if( crearReservaRs.getCodigo() == "0" ){
                switch ( params?.tipoReservaId ){
                    case "1":
                        flash.message = crearReservaRs.getMensaje()
                        redirect( controller: 'reserva', action: 'show', id: crearReservaRs.getReservaId() )
                        break
                    case "2":
                        session['link'] = crearReservaRs?.mensaje
                        session['temp'] = ReservaTemp.get(crearReservaRs?.reservaId)
                        redirect(url: crearReservaRs?.mensaje)
                        break
                }
            }else{
                flash.error = crearReservaRs.getMensaje()
                redirect(controller: 'reserva', action: 'create',
                        params: [
                                fecha: params?.fechaReserva,
                                moduloId: params?.moduloId,
                                id: params?.espacioId
//                                servicioId: null

                        ])
            }
        }catch(e){
            flash.error = "Ha ocurrido un error inesperado."
            log.error("Ha ocurrido un error inesperado.")
            redirect(controller: 'reserva', action: 'create', params: [
                    fecha: params?.fechaReserva,
                    moduloId: params?.moduloId,
                    id: params?.espacioId
//                                servicioId: null
            ])
        }
    }

    @Secured(['ROLE_ADMIN'])
    def saveManual() {
        try{
            CrearReservaRs crearReservaRs = reservaUtilService.crearReserva( params,3 )
            if( crearReservaRs.getCodigo() == "0" ){
                flash.message = crearReservaRs.getMensaje()
                redirect( controller: 'reserva', action: 'show', id: crearReservaRs.getReservaId() )
            }else{
                flash.error = crearReservaRs.getMensaje()
                redirect(controller: 'home', action: 'dashboard')
            }
        }catch(e){
            flash.error = "Ha ocurrido un error inesperado."
            log.error("Ha ocurrido un error inesperado.")
            redirect(controller: 'home', action: 'dashboard')
        }

    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'reserva.label', default: 'Reserva'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }


    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def reservasVigentesAdmin(){
        User user = springSecurityService.getCurrentUser()
        List<Reserva> reservaList = []
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        try{
            reservaList = Reserva.createCriteria().list {
                and{
                    ge('terminoExacto', c.getTime())
                    estadoReserva {
                        ne('id', 3l)
                    }
                    espacio{
                        empresa{
                            usuario{
                                eq('id', user?.id)
                            }
                        }
                    }
                }
            }
        }catch(e){}
        render view: 'reservasVigentesAdmin', model: [reservaList: reservaList]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def reservasHistoricasAdmin(){
        User user = springSecurityService.getCurrentUser()
        List<Reserva> reservaList = []
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        def today = c.getTime()
        c.add(Calendar.MONTH, -2 )
        def twoMonthAgo = c.getTime()
        try{
            reservaList = Reserva.createCriteria().list {
                and{
                    between('terminoExacto', twoMonthAgo, today)
                    estadoReserva {
                        ne('id', 3l)
                    }
                    espacio{
                        empresa{
                            usuario{
                                eq('id', user?.id)
                            }
                        }
                    }
                }
            }
        }catch(e){}
        render view: 'reservasHistoricasAdmin', model: [reservaList: reservaList]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def reservasVigentesUser(){
        List<Reserva> reservaList = []
        User user = springSecurityService.getCurrentUser()
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        try {
            reservaList = Reserva.createCriteria().list {
                and{
                    ge('terminoExacto', c.getTime())
                    estadoReserva {
                        ne('id', 3l)
                    }
                    usuario{
                        eq('id', user?.id)
                    }
                }
            }
        }catch(e){}

        render view: 'reservasVigentesUser', model: [reservaList: reservaList]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def reservasHistoricasUser(){
        List<Reserva> reservaList = []
        User user = springSecurityService.getCurrentUser()
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        def today = c.getTime()
        c.add(Calendar.MONTH, -2 )
        def twoMonthAgo = c.getTime()
        try{
            reservaList = Reserva.createCriteria().list {
                and{
                    between('terminoExacto', twoMonthAgo, today)
                    estadoReserva {
                        ne('id', 3l)
                    }
                    usuario{
                        eq('id', user?.id)
                    }
                }
            }
        }catch(e){}
        render view: 'reservasHistoricasUser', model: [reservaList: reservaList]
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def solicitudReservaAdmin(){

        User user = springSecurityService.getCurrentUser()
        Empresa empresa = Empresa.findByUsuario(user)

        Date fechaActual = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(fechaActual)
        c.set(Calendar.MILLISECOND, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.HOUR_OF_DAY, 0)

        if(user != null && empresa != null){
            List<Espacio> espacioList = Espacio.findAllByEmpresa(empresa)
            List<Reserva> solicitudList = Reserva.createCriteria().list{
                and{
                    ge('fechaReserva', c.getTime())
                    estadoReserva {
                        eq('id', 1l)
                    }
                    tipoReserva {
                        eq('id', 1l)
                    }
                    or {
                        for( esp in espacioList ){
                            espacio {
                                eq('id', esp?.id)
                            }
                        }
                    }
                }
            }

            render(view: 'solicitudReservaAdmin', model: [solicitudList: solicitudList])
        }
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def aprobarSolicitud(Long id){
        boolean exito = true
        Reserva reserva = Reserva.findById(id)
        if(reserva){
            if( reserva?.estadoReservaId == 1 ){
                try{
                    reserva.estadoReserva = EstadoReserva.findById(2)
                    reservaService.save(reserva)
                    correoConfirmacionReserva(reserva?.id)
                    notificationService.sendPushNotification(reserva?.usuarioId, "Tu reserva ha sido aprobada", "Tu solicitud a ${reserva?.espacio?.nombre} para" +
                            " el ${formatDate(format: 'dd-MM-yyyy', date: reserva?.fechaReserva)} ${reserva?.horaInicio} a ${reserva?.horaTermino} ha sido aprobada. No faltes!")
                }catch(e){
                    exito = false
                    flash.error = "Ups! no hemos podido aprobar la solicitud. Por favor intenta más tarde."
                }
            }else{
                exito = false
                flash.error = "Ups! no hemos podido aprobar la solicitud. Por favor intenta más tarde."
            }
        }else{
            exito = false
            flash.error = "Ups! no hemos podido aprobar la solicitud. Por favor intenta más tarde."
        }
        if( exito ){ flash.message = "Reserva aprobada correctamente!"}
        redirect( controller: 'reserva', action: 'solicitudReservaAdmin')
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def cancelarSolicitud(Long id){
        boolean exito = true
        Reserva reserva = Reserva.findById(id)
        if(reserva){
            try{
                String nombre = reserva?.espacio?.nombre
                String fecha = formatDate(format: 'dd-MM-yyyy', date: reserva?.fechaReserva)
                String inicio = reserva?.horaInicio
                String fin = reserva?.horaTermino
                String email = reserva?.usuario?.email
                String espacio = reserva?.espacio?.nombre
                String razonSocial = reserva?.espacio?.empresa?.razonSocial
                User user = reserva?.usuario
                reservaService.delete(reserva?.id)
                String template = groovyPageRenderer.render(template:  "/correos/cancelReservaByAdmin", model: [espacio: espacio, fecha: fecha, hora: inicio, razonSocial: razonSocial, user: user ])
                utilService.enviarCorreo(email, "noresponder@bookeame.cl", "Reserva Cancelada", template  )
                notificationService.sendPushNotification(reserva?.usuarioId, "Tu reserva ha sido rechazada", "Tu solicitud a ${nombre} para" +
                        " el ${fecha} ${inicio} a ${fin} ha sido rechazada.")
            }catch(e){
                exito = false
                flash.error = "Ups! no hemos podido cancelar la solicitud. Por favor intenta más tarde."
            }
        }else{
            exito = false
            flash.error = "Ups! no hemos podido cancelar la solicitud. Por favor intenta más tarde."
        }

        if( exito ){ flash.message = "Reserva cancelada correctamente!" }
        redirect( controller: 'reserva', action: 'solicitudReservaAdmin')
    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def evaluacionEspacio(Long id){
        boolean exito = true
        Reserva reserva = Reserva.findById(id)
        if(reserva){
            try{
                Evaluacion evaluacion = reserva?.evaluacion ?: new Evaluacion()
                evaluacion.evaluacionToEspacio = EvaluacionToEspacio.findById(params?.notaEspacio.toInteger())
                evaluacion.comentarioToEspacio = params?.comentarioEspacio ? params?.comentarioEspacio : "No Registra"

                evaluacionService.save(evaluacion)
                reserva.evaluacion = evaluacion
                reservaService.save(reserva)
            }catch(e){
                flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
                exito = false
            }
        }else{
            flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
            exito = false
        }

        if( exito ){
            flash.message = "Muchas Gracias por completar la evaluación."
            actualizarNotaEspacio(reserva?.espacio, reserva?.evaluacion?.evaluacionToEspacio?.nota)
        }
        redirect(controller: 'reserva', action: 'reservasHistoricasUser' )
    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    void actualizarNotaEspacio(Espacio espacio, Integer nota) {
        try {
            if (espacio != null && nota != null) {
                espacio.notaAcumulada = nota + espacio?.notaAcumulada
                espacio.notaContador = espacio?.notaContador + 1
                if (espacio?.notaUsuarios == 0) {
                    espacio.notaUsuarios = nota
                } else {
                    def promedio = espacio?.notaAcumulada / espacio?.notaContador
                    espacio.notaUsuarios = promedio.round(1)
                }
                espacioService.save(espacio)
            }
        }catch(e) {}
    }

    //TODO: TRAZAR
    @Secured(['permitAll()'])
    def confirmFlow(String token){
        boolean exito = true
        println(token)
        ReservaTemp reserva = ReservaTemp.findByToken(token)
        if( reserva ){
            FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa( reserva?.espacio?.empresa)
            if(flowEmpresa){
                def response = flowService.paymentStatus(token,flowEmpresa?.apiKey,flowEmpresa?.secretKey)

                if( response == 2 ){
                    try{
                        Reserva res = new Reserva()
                        res.usuario = reserva?.usuario
                        res.fechaReserva = reserva?.fechaReserva
                        res.horaInicio = reserva?.horaInicio
                        res.horaTermino = reserva?.horaTermino
                        res.valor = prepagoUtilService?.costoTransaccion(reserva?.valor, flowEmpresa?.comision?.valor ) ?: reserva?.valor
                        res.valorFinal = res.valor
                        res.valorComisionFlow = prepagoUtilService?.costoTransaccion(reserva?.valor, flowEmpresa?.comision?.valor ) - reserva?.valor
                        res.espacio = reserva?.espacio
                        res.tipoReserva = reserva?.tipoReserva
                        res.estadoReserva = reserva?.estadoReserva
                        res.evaluacion = reserva?.evaluacion
                        res.token = reserva?.token
                        reservaService.save(res)
                        correoConfirmacionReserva(res?.id)
                        notificationService.sendPushNotification(res?.usuarioId,"Nueva reserva registrada", "Tienes una nueva reserva en tu agenda.")
                        reservaTempService.delete(reserva?.id)
                        session['link'] = null
                        session['temp'] = null
                    }catch(e){}
                }else{
                    reservaTempService.delete(reserva?.id)
                    exito = false
                }
            }else{ exito = false }
        }else{ exito = false }
        return exito
    }

    def marcarNoDisponible(){
        render template: 'marcarNoDisponible', model: [moduloId: params?.moduloId, fechaReserva: params?.fechaReserva]
    }
    def marcarDisponible(){
        render template: 'marcarDisponible', model: [reservaId: params?.reservaId]
    }

    def buscarCliente(){
        render template: 'buscarCliente'
    }

    def noDisponible(){
        boolean exito = true
        Modulo modulo = new Modulo()
        if( params?.moduloId != null && params?.fechaReserva != null ){
            modulo = Modulo.findById(params?.moduloId.toLong())

            if( modulo != null && params?.fechaReserva != null ){
                def pattern = "dd-MM-yyyy"
                def date = new SimpleDateFormat(pattern).parse(params?.fechaReserva)
                if( reservaUtilService?.reservaDisponible(
                        reservaUtilService?.convertModuloToDto(modulo, modulo?.horaTermino, modulo?.valor),
                        params?.fechaReserva)
                ) {

                    try {
                        Reserva reserva = new Reserva()
//                        reserva.usuario = user
                        reserva.fechaReserva = date
                        reserva.horaInicio = modulo?.horaInicio
                        reserva.horaTermino = modulo?.horaTermino
                        reserva.valor = modulo?.valor
                        reserva.espacio = modulo?.espacio
                        reserva.tipoReserva = TipoReserva.findById(3)
                        reserva.estadoReserva = EstadoReserva.findById(3)
                        reserva.disponible = false
                        reservaService.save(reserva)
//                        notificationService.sendPushNotification(reserva?.espacio?.empresa?.usuarioId, "Solicitud de reserva", "Tienes una solicitud de reserva pospago.")
                    } catch (e) {
                        exito = false
                        flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
                    }

                }else{
                    exito = false
                    flash.error = "Módulo no disponible."
                }
            }else{
                exito = false
                flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
            }
        }else{
            exito = false
            flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
        }
        if( exito ){ flash.message = "Reserva marcada como NO DISPONIBLE exitosamente."}

        redirect(controller: 'reserva', action: 'crearReservaManual', id: modulo?.espacio?.id )
    }

    def disponible(){
        def espacioId
        try{
            Reserva reserva = Reserva.get(params?.reservaId.toLong())
            espacioId = reserva?.espacio?.id
            reservaService.delete(reserva?.id)
            flash.message = 'Módulo habilitado correctamente.'
        }catch(e){
            flash.error = 'Ha ocurrido un error.'
        }
        redirect(controller: 'reserva', action: 'crearReservaManual', id: espacioId )
    }

    def correoConfirmacionReserva(Long id){
        try{
            Reserva reserva = Reserva.get(id)

            //CORREO CONFIRMACION USER
            String templateUser = groovyPageRenderer.render(template:  "/correos/confirmacionReservaUser", model: [reserva: reserva, serverBaseURL: General.findByNombre("baseUrl")?.valor])
            utilService.enviarCorreo( reserva?.usuario?.email, "noresponder@bookeame.cl", "Confirmación de reserva", templateUser)

            if( reserva?.usuario?.invitado ){
                //CORREO INVITACION USER
                String link = createLink( base:  General.findByNombre("baseUrl")?.valor, controller: 'user', action: 'registroInvitado', id: reserva?.usuario?.id)
                String template = groovyPageRenderer.render(template: "/correos/invitarUser", model: [user: reserva?.usuario, link: link ])
                utilService.enviarCorreo(reserva?.usuario?.email, "noresponder@bookeame.cl", "${reserva?.usuario?.nombre} Se parte de Bookeame", template  )
            }

            //CORREO CONFIRMACION EMPRESA
            String templateEmpresa = groovyPageRenderer.render(template:  "/correos/confirmacionReservaAdmin", model: [reserva: reserva,  serverBaseURL: General.findByNombre("baseUrl")?.valor])
            utilService.enviarCorreo( reserva?.espacio?.empresa?.usuario?.email, "noresponder@bookeame.cl", "Confirmación de reserva", templateEmpresa)

        }catch(e){}
    }

    @Secured(['ROLE_USER','ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def eliminarReserva(Long id){
        Reserva reserva = Reserva.get(id)
        if(reserva?.tipoReservaId == 2 ){
            flash.error="No se ha podido eliminar la reserva porque hay un pago realizado de por medio."
            redirect(controller: 'reserva', action: 'show', id: reserva?.id)
        }
        try{
            if(reservaUtilService.eliminarReserva(id)){
                flash.message="Reserva eliminada correctamente."
            }else{
                flash.error="No se ha podido eliminar la reserva, por favor intenta más tarde."
            }
        }catch(e){
            flash.error = "Ha ocurrido un error."
            render view: '/notFound'
        }
        if( validadorPermisosUtilService.esRoleUser()){
            redirect(controller: 'reserva', action: 'reservasVigentesUser')
        }
        if( validadorPermisosUtilService.esRoleAdmin()){
            redirect(controller: 'reserva', action: 'calendario', id: reserva?.espacio?.id)
        }
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def eliminarReservaPrepago(Long id){
        String espacio
        String fecha
        String hora
        String razonSocial
        String email
        Long espacioId
        User usuario = new User()
        try{
            User user = springSecurityService.getCurrentUser()
            Reserva reserva = Reserva.get(id)
            espacioId = reserva?.espacio?.id
            if( reserva?.espacio?.empresa?.usuario?.id == user?.id ){
                if( reserva?.inicioExacto > new Date() ){
                    RefundReserva refundReserva = new RefundReserva(
                            numeroOrden: params?.numeroOrden,
                            numeroReembolso: params?.numeroReembolso,
                            monto: params?.monto,
                            espacio: reserva?.espacio,
                            inicio: reserva?.inicioExacto,
                            termino: reserva?.terminoExacto,
                            token: reserva?.token,
                            acepta: params?.acepta ? true : false
                    ).save()
                    email = reserva?.usuario?.email
                    espacio = reserva?.espacio?.nombre
                    fecha = g.formatDate(format: "dd-MM-yyyy", date: reserva?.fechaReserva)
                    hora = reserva?.horaInicio
                    razonSocial = reserva?.espacio?.empresa?.razonSocial
                    usuario = reserva?.usuario
                    reservaService.delete(reserva?.id)

                    String template = groovyPageRenderer.render(template:  "/correos/cancelReservaByAdminPrepago",
                            model: [espacio: espacio, fecha: fecha, hora: hora, razonSocial: razonSocial, user: usuario, refundReserva: refundReserva])
                    utilService.enviarCorreo(email, "noresponder@bookeame.cl", "Reserva Cancelada", template  )

                    flash.message = "Reserva eliminada correctamente."
                }else{
                    flash.error = "NO se puede eliminar una reserva Histórica."
                }

            }
        }catch(e){
            flash.error = "Ha ocurrido un error."
        }
        redirect(controller: 'reserva', action: 'crearReservaManual', id: espacioId)
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def declaracionEliminacionPrepago(Long id){
        Reserva reserva = Reserva.get(id)
        if( validadorPermisosUtilService?.validarRelacionReservaUser(reserva?.id) ){
            respond Reserva.get(id)
        }else{
            render view: '/notFound'
        }
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def busquedaInteligenteAdmin(String valor, String roleString){
        Role role = Role.findByAuthority(roleString)
        def userList = []

        def userRoleList = UserRole.executeQuery("from UserRole where role.id = "+ role?.id + " and user.username like '" + valor + "%'")
        for( usr in userRoleList){
            if( usr?.user?.enabled ){
                userList.add(usr?.user)
            }
        }

        if( userList.size() > 0 ){
            render g.select(id: 'usuario', name: 'usuario',required: 'required', from: userList, optionKey: 'id', noSelection: ['': "- ${ userList?.size() } Coincidencias Encontradas -"], class: "form-control select2", style:"width: 100%;" )
        }else{
            render g.field(id: 'usuario', name: 'usuario', required: 'required', class: 'form-control', value: "Sin coincidencias")
        }
    }

    @Secured(['ROLE_USER','ROLE_SUPERUSER'])
    def cancelarReserva(){}

//    def getHorariosDisponibles(){
//        Reserva reserva = Reserva.get(params?.reserva?.toLong())
//        List<Modulo> moduloList = []
//        List<Reserva> reservaList = []
//        String nombreDia
//        Calendar c = Calendar.getInstance()
//        List<Modulo> horarioList = []
//        List<EventoCalendario> eventoCalendarioList = new ArrayList<>()
//        if( reserva && params?.fecha ){
//            try{
//                def fechaNuevaReserva = sdf.parse(params?.fecha)
//                c.setTime(fechaNuevaReserva)
//                nombreDia = formatoFechaUtilService?.obtenerNombreDia( c.get(Calendar.DAY_OF_WEEK))
//
//                moduloList = Modulo.findAllByEspacio(reserva?.espacio)
//                reservaList = Reserva.findAllByFechaReservaAndEspacio(c.getTime(), reserva?.espacio)
//
//                for( modulo in moduloList ){
//                    if( modulo?.dias?.getProperty(nombreDia) ){
//                        if( !reservaList.find{ it?.horaInicio == modulo?.horaInicio } ){
//                            horarioList.add(modulo)
//                        }
//                    }
//                }
//                Long servicioId = params?.servicio?.toLong() ?: null
//                horarioList.each { it ->
//                    eventoCalendarioList.add(
//                            reservaUtilService?.moduloEventoConverter(it, params?.fecha, servicioId)
//                    )
//                }
//                if( servicioId != null ){
//                    eventoCalendarioList = reservaUtilService?.filtrarModulosPorServicio(eventoCalendarioList, servicioId)
//                }
//            }catch(e){}
//        }
//        render g.select(id: 'horario', name: 'horario',required: 'required', from: horarioList.sort{ it?.horaInicio }, optionKey: 'id', optionValue: 'horarioModulo' , noSelection: ['':'- Seleccione Horario -'], class: "form-control select2", style:"width: 100%;" )
//
//    }

    def getHorariosDisponibles(){
        List<EventoCalendario> eventoCalendarioList = new ArrayList<>();
        try{
            Reserva reserva = Reserva.get(params?.reserva?.toLong())
            eventoCalendarioList = reservaUtilService?.getEventosCalendario(reserva?.espacio?.id, params?.servicio?.toLong() ?: null)
            if( params?.servicio?.toLong() &&  params?.servicio != "0"){
                eventoCalendarioList = reservaUtilService?.filtrarModulosPorServicio(eventoCalendarioList, params?.servicio?.toLong())
            }
            eventoCalendarioList = eventoCalendarioList.findAll { it ->
                it?.fechaReserva == params?.fecha && it?.getTitle() == "Disponible" }
        }catch(Exception e){
            log.error("error get eventos")
        }
        render g.select(id: 'horario', name: 'horario',required: 'required', from: eventoCalendarioList.sort{ it?.horaInicio }, optionKey: "horaInicio" , optionValue: 'horaInicio' , noSelection: ['':'- Seleccione Horario -'], class: "form-control select2", style:"width: 100%;" )
    }

    def reagendarReserva(Long id){
        try{
            String nuevaHoraTermino
            Integer nuevoValor
            Servicio servicio = null
            Reserva reserva = Reserva.get(id)
            if( params?.servicio != null && params?.servicio != "" ){
                servicio = Servicio.get(params?.servicio?.toLong())
            }
            ConfiguracionEmpresa configuracionEmpresa = ConfiguracionEmpresa.findByEmpresa(reserva?.espacio?.empresa)
//            Modulo modulo = Modulo.get(params?.horario?.toLong())
            Modulo modulo = Modulo.findByEspacioAndHoraInicio(reserva?.espacio, params?.horario)
            if( servicio != null ){
                nuevaHoraTermino = reservaUtilService?.nuevaHoraInicio(params?.horario, servicio?.duracionAdicional) // el nombre de ese metodo no tiene ningun sentido
                nuevoValor = servicio?.valor
            }else{
                nuevaHoraTermino = modulo?.horaTermino
                nuevoValor = modulo?.valor
            }
            String templateEmpresa
            String templateUser
            if( reserva && modulo ){
                if( validadorPermisosUtilService?.userPuedeReagendarReserva(reserva,configuracionEmpresa)
                    && validadorPermisosUtilService?.validarRelacionReservaUser(reserva?.id)
                    && validadorPermisosUtilService?.validarRelacionEspacioModulo(modulo, reserva?.espacio)
                    && validadorPermisosUtilService?.validarRelacionModuloFecha(modulo, sdf.parse(params?.fechaReagendar))
                    && reservaUtilService?.reservaDisponible(
                        reservaUtilService?.convertModuloToDto(modulo, nuevaHoraTermino, nuevoValor),
                        params?.fechaReagendar
                )
                ){

                    reserva.horaInicio = modulo?.horaInicio
                    reserva.horaTermino = nuevaHoraTermino
                    reserva.fechaReserva = sdf.parse(params?.fechaReagendar)
                    reserva.valor =nuevoValor
                    reservaService.save(reserva)
                    flash.message = "Reserva Reagendada exitosamente!"

                    // ENVIO DE CORREO Y NOTIFICACION AL USUARIO
                    templateUser = groovyPageRenderer.render(template:  "/correos/reagendarUser", model: [reserva: reserva])
                    utilService.enviarCorreo(reserva?.usuario?.email, "noresponder@bookeame.cl", "Tu reserva ha sido reagendada.", templateUser )
                    notificationService.sendPushNotification(reserva?.usuario?.id, "AVISO IMPORTANTE.", "Tu reserva ha sido reagendada.")

                    // ENVIO DE CORREO Y NOTIFICACION A LA EMPRESA
                    templateEmpresa = groovyPageRenderer.render(template:  "/correos/reagendarEmpresa", model: [reserva: reserva])
                    utilService.enviarCorreo(reserva?.espacio?.empresa?.email, "noresponder@bookeame.cl", "Una reserva ha sido reagendada.", templateEmpresa)
                    notificationService.sendPushNotification(reserva?.espacio?.empresa?.usuario?.id, "AVISO IMPORTANTE.", "Una reserva ha sido reagendada.")

                }else{ flash.error = "Ups! Ha ocurrido un error" }
            }else{ flash.error = "Ups! Ha ocurrido un error" }
        }catch(e){ flash.error = "Ups! Ha ocurrido un error" }
        redirect(controller: 'reserva', action: 'show', id: id)
    }

    @Secured(['ROLE_ADMIN','ROLE_SUPERUSER'])
    def ingresarPago(Long id){
        try{
            if( !validadorPermisosUtilService?.validarRelacionReservaUser(id)){
                render view: '/notFound'
            }
            boolean exito = reservaUtilService.registrarPago(
                    id,
                    params?.valorFinal
            )
            if( exito ){
                flash.message = "Datos guardados con exito!"
            }else{
                flash.error = "No hemos podido guardar la información. Por favor intenta más tarde."
            }
            redirect(controller: 'reserva', action: 'show', id: id)
        }catch(e){
            flash.error = "No hemos podido guardar la información. Por favor intenta más tarde."
            redirect(controller: 'reserva', action: 'show', id: id)
        }
    }

    @Secured(['ROLE_ADMIN','ROLE_SUPERUSER'])
    def registrarEvaluacion(Long id){
        try{
            if( !validadorPermisosUtilService?.validarRelacionReservaUser(id)){
                render view: '/notFound'
            }
            boolean exito = reservaUtilService.registrarEvaluacion(
                    id,
                    params?.notaUser,
                    params?.comentarioUser,
            )
            if( exito ){
                flash.message = "Datos guardados con exito!"
            }else{
                flash.error = "No hemos podido guardar la información. Por favor intenta más tarde."
            }
            redirect(controller: 'reserva', action: 'show', id: id)
        }catch(e){
            flash.error = "No hemos podido guardar la información. Por favor intenta más tarde."
            redirect(controller: 'reserva', action: 'show', id: id)
        }
    }

    @Secured(['ROLE_ADMIN','ROLE_SUPERUSER'])
    def enviarComprobante(Long id){
        try{
            if( !validadorPermisosUtilService?.validarRelacionReservaUser(id)){
                render view: '/notFound'
            }
            Reserva reserva = Reserva.get(id)
            List<ServicioReserva> servicioReservaList = new ArrayList<>()
            servicioReservaList = ServicioReserva.findAllByReserva(reserva)
            String templateUser = groovyPageRenderer.render(template:  "/correos/comprobante",
                    model: [reserva: reserva, servicioReservaList: servicioReservaList])
            utilService.enviarCorreo(reserva?.usuario?.email, "noresponder@bookeame.cl",
                    "Comprobante de Pago", templateUser)
            reserva.envioComprobante = true
            reservaService.save(reserva)
            flash.message = 'Comprobante enviado con exito!'
        }catch(e){
            flash.error = 'Ups! Ha ocurrido un error. Por favor intenta más tarde.'
        }
        redirect(controller: 'reserva', action: 'show', id: id)
    }

}
