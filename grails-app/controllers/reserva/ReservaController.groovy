package reserva

import auth.Role
import auth.User
import auth.UserRole
import auth.UserService
import configuracionEmpresa.ConfiguracionEmpresa
import espacio.DiaService
import flow.Comision
import gestion.General
import empresa.Empresa
import espacio.Espacio
import espacio.EspacioService
import evaluacion.Evaluacion
import evaluacion.EvaluacionService
import evaluacion.EvaluacionToEspacio
import evaluacion.EvaluacionToUser
import flow.FlowEmpresa
import gestion.NotificationService
import grails.plugin.springsecurity.annotation.Secured

import grails.validation.ValidationException

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class ReservaController {

    ReservaService reservaService
    UserService userService
    EvaluacionService evaluacionService
    EspacioService espacioService
    ReservaTempService reservaTempService
    NotificationService notificationService

    ReservaPlanificadaService reservaPlanificadaService
    ReservaUtilService reservaUtilService

    DiaService diaService
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")
    def springSecurityService
    def flowService
    def tempService
    def groovyPageRenderer
    def utilService
    def validadorPermisosUtilService
    def validaPermisosReservaUtilService
    def formatoFechaUtilService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_SUPERUSER'])
    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond reservaService.list(params), model:[reservaCount: reservaService.count()]
    }

    def show(Long id) {
        if(validadorPermisosUtilService?.validarRelacionReservaUser(id)){
            User user = springSecurityService.getCurrentUser()
            Reserva reserva = reservaService.get(id)
            try{
                if(validadorPermisosUtilService.esRoleAdmin(user)){
                    ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa)?.fono
                    respond reserva, model: [
                            esReservaVigente: validaPermisosReservaUtilService?.esReservaVigente(reserva),
                            esReservaPosPagoPendiente: validaPermisosReservaUtilService?.esReservaPosPagoPendiente(reserva),
                            esReservaHistorica: validaPermisosReservaUtilService?.esReservaHistorica(reserva),
                            configuracion: ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa)
                    ]
                }
                if(validadorPermisosUtilService.esRoleUser(user)){
                    ConfiguracionEmpresa configuracion = ConfiguracionEmpresa?.findByEmpresa(reserva?.espacio?.empresa)
                    respond reserva, model: [
                            hoy: new Date(),
                            configuracion: configuracion,
                            puedeCancelar: validadorPermisosUtilService.userPuedeCancelarReserva(reserva,configuracion),
                            puedeReagendar: validadorPermisosUtilService.userPuedeReagendarReserva(reserva, configuracion)
                    ]
                }
            }catch(e){
                render view: '/error'
            }
        }else{
            render view: '/notFound'
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def create() {
        respond new Reserva(params)
    }

    @Secured(['ROLE_SUPERUSER'])
    def save(Reserva reserva) {
        if (reserva == null) {
            notFound()
            return
        }

        try {
            reservaService.save(reserva)
        } catch (ValidationException e) {
            respond reserva.errors, view:'crearReservaManual'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'reserva.label', default: 'Reserva'), reserva.id])
                redirect reserva
            }
            '*' { respond reserva, [status: CREATED] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def edit(Long id) {
        respond reservaService.get(id)
    }

    @Secured(['ROLE_SUPERUSER'])
    def update(Reserva reserva) {
        if (reserva == null) {
            notFound()
            return
        }

        try {
            reservaService.save(reserva)
        } catch (ValidationException e) {
            respond reserva.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'reserva.label', default: 'Reserva'), reserva.id])
                redirect reserva
            }
            '*'{ respond reserva, [status: OK] }
        }
    }

    @Secured(['ROLE_SUPERUSER'])
    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        reservaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'reserva.label', default: 'Reserva'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
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
    def crearReservaManual(Long id){
        Espacio espacio = Espacio.findById(id)
        ConfiguracionEmpresa conf = ConfiguracionEmpresa.findByEmpresa(espacio?.empresa)

        if(validarRelacionEspacioUser(id)) {
            List<Modulo> moduloList
            List<Reserva> reservaList
            def dateList

            if( espacio ){
                moduloList = Modulo.findAllByEspacio(espacio)
                dateList = obteneFechaList(conf?.diasAMostrar ?: 7)
                reservaList = obtenerReservas(espacio, "ADMIN")
            }

            respond espacio, model: [moduloList: moduloList, dateList: dateList, reservaList: reservaList]
        }else{
            render view: '/notFound'
        }
    }

    def obtenerReservas(Espacio esp, String role){
        ConfiguracionEmpresa conf = ConfiguracionEmpresa.findByEmpresa(esp?.empresa)
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        c.set(Calendar.MILLISECOND, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.HOUR_OF_DAY, 0)
        def inicio = c.getTime()
        Integer diasAMostrar = conf?.diasAMostrar ?: 7
        c.add(Calendar.DAY_OF_YEAR, diasAMostrar + 1) //sumale uno a la variable
        def fin = c.getTime()
        List<Reserva> reservaList = Reserva.createCriteria().list {
            and{
                espacio{
                    eq('id', esp?.id)
                }
                if( role == "ADMIN"){
                    ge('fechaReserva', inicio)
                }
                if( role == "USER"){
                    between('fechaReserva', inicio, fin)
                }
            }
        }
        return reservaList
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def obteneFechaList(Integer dias){
        SimpleDateFormat frm= new SimpleDateFormat("yyyy-MM-dd")
        Date hoy = new Date()

        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        def dateList = []
        for(int i=1;i<= dias ;i++){
            Formatter dia = new Formatter()
            Formatter mes = new Formatter()
            def year
            def month
            def day
            String diaFrm
            String mesFrm

            year = c.get(Calendar.YEAR).toString()
            month = c.get(Calendar.MONTH) + 1
            day = c.get(Calendar.DAY_OF_MONTH)

            mes.format("%02d", month)
            dia.format("%02d", day)
            diaFrm = dia
            mesFrm = mes
            String nombreDia = formatoFechaUtilService?.obtenerNombreDia( c.get(Calendar.DAY_OF_WEEK))

            String fecha=  year + "-" + mesFrm + "-" + diaFrm
            Date fechaDate = frm.parse(fecha)

            String fechaInvertida = diaFrm + "-" + mesFrm + "-" + year

            dateList.add([ fecha, nombreDia, fechaDate, fechaInvertida])
            c.add(Calendar.DAY_OF_YEAR, 1)
        }
//        println(dateList)
        return  dateList
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

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def guardarReservaManual(Long userId, Long moduloId, String fechaReserva){
        boolean exito = true
        User user = User.findById(userId)
        Modulo modulo = Modulo.findById(moduloId)
        Reserva reserva = new Reserva()
        if( fechaReserva != null) {
            def pattern = "dd-MM-yyyy"
            def date = new SimpleDateFormat(pattern).parse(fechaReserva)
            if (user != null && modulo != null && date != null) {
                if (reservaDisponible(modulo, fechaReserva)) {
                    reserva.usuario = user
                    reserva.fechaReserva = date
                    reserva.horaInicio = modulo?.horaInicio
                    reserva.horaTermino = modulo?.horaTermino
                    reserva.valor = modulo?.valor
                    reserva.espacio = modulo?.espacio
                    reserva.tipoReserva = TipoReserva.findById(3)
                    reserva.estadoReserva = EstadoReserva.findById(2)
                    try {
                        reservaService.save(reserva)
                        correoConfirmacionReserva(reserva?.id)
                    } catch (e) {
                        exito = false
                        flash.error = "Ups! un error ha ocurrido. No hemos podido registrar la información."
                    }
                } else {
                    exito = false
                    flash.error = "Módulo no disponible."
                }
            } else {
                exito = false
                flash.error = "Ups! un error ha ocurrido. No hemos podido registrar la información."
            }
        } else {
            exito = false
            flash.error = "Ups! un error ha ocurrido. No hemos podido registrar la información."
        }
        if( exito ){
            flash.message = "Reserva registrada exitosamente!"
        }
        redirect( controller: 'reserva', action: 'crearReservaManual', id: modulo?.espacio?.id)
    }

    def reservaDisponible(Modulo modulo, String fecha){
        Date hoy = new Date()
        def pattern = "dd-MM-yyyy"
        def fechaReserva = new SimpleDateFormat(pattern).parse(fecha)
        Calendar c = Calendar.getInstance()
        c.setTime(fechaReserva)
        c.set(Calendar.MINUTE, modulo?.horaInicio.substring(3,5).toInteger())
        c.set(Calendar.HOUR_OF_DAY, modulo?.horaInicio.substring(0,2).toInteger())
//        println(modulo?.horaInicio.substring(3,5).toInteger())
        if( c.getTime() >= hoy ){
            c.set(Calendar.MILLISECOND, 0)
            c.set(Calendar.SECOND, 0)
            c.set(Calendar.MINUTE, 0)
            c.set(Calendar.HOUR_OF_DAY, 0)

            List<Reserva> reservaList = Reserva.createCriteria().list {
                and{
                    eq('fechaReserva', c.getTime())
                    estadoReserva {
                        ne('id', 3l)
                    }
                    espacio{
                        eq('id', modulo?.espacio?.id)
                    }
                    eq('horaInicio', modulo?.horaInicio)
                    eq('horaTermino', modulo?.horaTermino)
                }
            }
            List<ReservaTemp> reservaTempList = ReservaTemp.createCriteria().list {
                and{
                    eq('fechaReserva', c.getTime())
                    estadoReserva {
                        ne('id', 3l)
                    }
                    espacio{
                        eq('id', modulo?.espacio?.id)
                    }
                    eq('horaInicio', modulo?.horaInicio)
                    eq('horaTermino', modulo?.horaTermino)
                }
            }

            if( reservaList.size() == 0 && reservaTempList.size() == 0 ){
                return true
            }else{
                return false
            }
        }else{
            return false
        }

    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def crearReservaUser(Long id) {
        Espacio espacio = Espacio.findById(id)
        ConfiguracionEmpresa conf = ConfiguracionEmpresa.findByEmpresa(espacio?.empresa)

        List<Modulo> moduloList
        List<Reserva> reservaList
        def dateList

        if (espacio) {
            moduloList = Modulo.findAllByEspacio(espacio)
            dateList = obteneFechaList(conf?.diasAMostrar ?: 7)
            reservaList = obtenerReservas(espacio, "USER")
        }

        respond espacio, model: [moduloList: moduloList, dateList: dateList, reservaList: reservaList, configuracion: conf]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def reservaPospago(Long moduloId, String fechaReserva, Long espacioId){
        boolean exito = true
        if( moduloId != null && fechaReserva != null ){
            Modulo modulo = Modulo.findById(moduloId)
            User user = springSecurityService.getCurrentUser()

            if( modulo != null && user != null && fechaReserva != null ){
                def pattern = "dd-MM-yyyy"
                def date = new SimpleDateFormat(pattern).parse(fechaReserva)
                if( reservaDisponible(modulo, fechaReserva) ) {
                    if( reservaPosPagoValidar(user) ){
                        try {
                            Reserva reserva = new Reserva()
                            reserva.usuario = user
                            reserva.fechaReserva = date
                            reserva.horaInicio = modulo?.horaInicio
                            reserva.horaTermino = modulo?.horaTermino
                            reserva.valor = modulo?.valor
                            reserva.espacio = modulo?.espacio
                            reserva.tipoReserva = TipoReserva.findById(1)
                            reserva.estadoReserva = EstadoReserva.findById(1)
                            reservaService.save(reserva)
                            notificationService.sendPushNotification(reserva?.espacio?.empresa?.usuarioId, "Solicitud de reserva", "Tienes una solicitud de reserva pospago.")
                        } catch (e) {
                            exito = false
                            flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
                        }
                    }else{
                        exito = false
                        flash.error = "Has excedido el limite de reservas Pospago vigentes."
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
        if( exito ){ flash.message = "Reserva creada exitosamente."}

        render(controller: 'reserva', action: 'crearReservaUser', id: espacioId )

    }

    def reservaPosPagoValidar(User user){
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        c.set(Calendar.MILLISECOND, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.HOUR_OF_DAY, 0)

        List<Reserva> reservaList = Reserva.createCriteria().list {
            and{
                ge('fechaReserva', c.getTime())
                tipoReserva {
                    eq('id', 1l)
                }
                usuario{
                    eq('id', user?.id)
                }
            }
        }
        if( reservaList.size() < General.findByNombre('maximoPosPago')?.valor?.toInteger() ){
            return true
        }else{
            return false
        }
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

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def evaluacionUser(Long id){
        boolean exito = true
        Reserva reserva = Reserva.findById(id)
        if(reserva){
            try{
                Evaluacion evaluacion = reserva?.evaluacion ?: new Evaluacion()
                if( reserva?.tipoReservaId == 2 ){
                    evaluacion.evaluacionToUser = params?.notaUser?.toInteger() == 1 ? EvaluacionToUser.findById( 2 ) : EvaluacionToUser.findById( params?.notaUser?.toInteger() )
                }else{
                    evaluacion.evaluacionToUser = EvaluacionToUser.findById(params?.notaUser.toInteger())
                }
                evaluacion.comentarioToUser = params?.comentarioUser ? params?.comentarioUser : "No Registra"

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
            actualizarNotaUser(reserva?.usuario, reserva?.evaluacion?.evaluacionToUser?.nota)
        }
        redirect(controller: 'reserva', action: 'show', id: id)
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    void actualizarNotaUser(User user, Integer nota){
        try{
            if(user != null && nota != null){
                user.indiceAcumulado = nota + user?.indiceAcumulado
                user.indiceContador = user?.indiceContador + 1
                if(user?.indiceConfianza == 0){
                    user.indiceConfianza = nota
                }else{
                    def promedio = user?.indiceAcumulado / user?.indiceContador
                    user.indiceConfianza = promedio.round(1)
                }
                userService.save(user)
            }
        }catch(e){}
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

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def reservaPrepago(){
        boolean exito = true
        Long moduloId = params?.moduloId?.toLong()
        String fechaReserva = params?.fechaReservaHidden
        Long espacioId = params?.espacioId?.toLong()
        String responsePago
        ReservaTemp reserva = new ReservaTemp()
        if( moduloId != null && fechaReserva != null ){
            Modulo modulo = Modulo.findById(moduloId)
            User user = springSecurityService.getCurrentUser()

            if( modulo != null && user != null && fechaReserva != null ){
                if( modulo?.valor > General.findByNombre('valorMinFlow')?.valor?.toInteger() ?: 0 ){
                    def pattern = "dd-MM-yyyy"
                    def date = new SimpleDateFormat(pattern).parse(fechaReserva)
                    if( reservaDisponible(modulo, fechaReserva) ) {
                        try {
                            reserva.usuario = user
                            reserva.fechaReserva = date
                            reserva.horaInicio = modulo?.horaInicio
                            reserva.horaTermino = modulo?.horaTermino
                            reserva.valor = modulo?.valor
                            reserva.espacio = modulo?.espacio
                            reserva.tipoReserva = TipoReserva.findById(2)
                            reserva.estadoReserva = EstadoReserva.findById(2)
                            reservaTempService.save(reserva)

                        } catch (e) {
                            exito = false
                            flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
                        }
                        responsePago = pagarReserva(reserva)
                        println(responsePago)
                        int tiempoTrigger = 15
                        tempService.triggerReservaTemp(reserva?.id, tiempoTrigger)
                    }else{
                        exito = false
                        flash.error = "Módulo momentaneamente no disponible."
                    }
                }else{
                    exito = false
                    flash.error = "Valor de la reserva no permite pagos en línea."
                }
            }else{
                exito = false
                flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
            }
        }else{
            exito = false
            flash.error = "Ups! Ha ocurrido un error. Por favor intenta más tarde."
        }

        if( responsePago == "error" ){
            println (responsePago)
            exito = false
            flash.error = "Ups! un error ha ocurrido"
        }

        if( exito ){
//            flash.message = "Reserva creada exitosamente."
            session['link'] = responsePago
            session['temp'] = reserva
            redirect(url: responsePago)
        }else{
            if( reserva ){
                try{
                    reservaTempService.delete(reserva?.id)
                }catch(e){}
            }
            redirect (controller: "reserva", action: 'crearReservaUser', id: espacioId)
        }
//        redirect responsePago
    }

    String pagarReserva(ReservaTemp reserva){
        User user = springSecurityService.getCurrentUser()
        String urlConfirm = "reserva/confirmFlow"
        String urlReturn = "reserva/reservasVigentesUser"
        if( user && reserva){
                FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa(reserva?.espacio?.empresa)
                if( flowEmpresa ){
                    def params = [
                            "amount"         : costoTransaccion(reserva?.valor, flowEmpresa?.comision?.valor ?: 3.19 ),
                            "apiKey"         : flowEmpresa?.apiKey,
                            "commerceOrder"  : flowService.correlativoFlow(),
//                            "currency"       : "CLP",
                            "email"          : user?.email ?: "pablo@bericul.com",
//                            "paymentMethod"  : 9,
                            "subject"        : "Pago de reserva ${reserva?.espacio?.nombre} ${ g.formatDate(format: 'dd-MM-yyyy', date: reserva?.fechaReserva) } ${reserva?.horaInicio}" ,
                            "timeout"        : 240,
                            "urlConfirmation": "${General.findByNombre('baseUrl').valor}/" + urlConfirm,
                            "urlReturn"      : "${General.findByNombre('baseUrl').valor}/" + urlReturn
                    ]
                    def array = flowService.createPayment(params, flowEmpresa?.secretKey)
                    flowService.avanceCorrelativo()
                    if( array[0] ){
                        String token = array[0]
                        registroToken(token, reserva)

                        return "${array[1] + "?token=" + array[0]}"
                    }else{
                        return "error"
                    }
                }else{
                    return "error"
                }
        }else{
            return "error"
        }
    }

    void registroToken(String token, ReservaTemp reserva){
        try{
            reserva.token = token
            reservaTempService.save(reserva)
        }catch(e){}
    }

    @Secured(['permitAll()'])
    def confirmFlow(String token){
        boolean exito = true
        println(token)
        ReservaTemp reserva = ReservaTemp.findByToken(token)
        if( reserva ){
            FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa( reserva?.espacio?.empresa)
            if(flowEmpresa){
                def response = flowService.paymentStatus(token,flowEmpresa?.apiKey, flowEmpresa?.secretKey)

                if( response == 2 ){
                    try{
                        Reserva res = new Reserva()
                        res.usuario = reserva?.usuario
                        res.fechaReserva = reserva?.fechaReserva
                        res.horaInicio = reserva?.horaInicio
                        res.horaTermino = reserva?.horaTermino
                        res.valor = costoTransaccion(reserva?.valor, flowEmpresa?.comision?.valor ?: 3.19 ) ?: reserva?.valor
                        res.valorComisionFlow = costoTransaccion(reserva?.valor, flowEmpresa?.comision?.valor ?: 3.19 ) - reserva?.valor
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

    Integer costoTransaccion(Integer precioNeto, def comision ){
        try{
            Integer precioFinal
            Integer diferencial
            def valorComision = 0
            def valorIva = 0
            def total = 0
            if( comision != 0 ){
                valorComision = precioNeto * ((comision/100) + 0.0001)
                valorIva = valorComision * 0.19
                total = precioNeto + valorIva + valorComision
                precioFinal = Math?.round(total)?.toInteger()
                diferencial = diferenciaComision( precioFinal, comision,  valorComision , valorIva )
                return precioFinal + diferencial
            }else{
                total = precioNeto
                precioFinal = Math?.round(total)?.toInteger()
                return precioFinal
            }
        }catch(e){}
    }

    Integer diferenciaComision(Integer total, def comision, def valorComision, def valorIva){
        try{
            def aux = valorComision + valorIva
            def old = Math?.round(aux)?.toInteger()
            def nuevaComision = total * ((comision/100) + 0.00005)
            def nuevoIva = nuevaComision * 0.19
            def totalComisionNueva = Math?.round(nuevaComision + nuevoIva)?.toInteger()
            return totalComisionNueva > old ? totalComisionNueva - old : 0
        }catch(e){}
    }

    def testMetodo(Long id){
        render costoTransaccion( 18000, Comision.get(id).valor)
    }

    Integer valorModulo(Long id){
        Integer monto = 0
        try{
            Modulo modulo = Modulo.get(id)
            monto = modulo?.valor
        }catch(e){}
        render monto
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
                if( reservaDisponible(modulo, params?.fechaReserva) ) {

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
        User user = springSecurityService.getCurrentUser()
        Reserva reserva = Reserva.get(id)
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
        if( validadorPermisosUtilService.esRoleUser(user)){
            redirect(controller: 'reserva', action: 'reservasVigentesUser')
        }
        if( validadorPermisosUtilService.esRoleAdmin(user)){
            redirect(controller: 'reserva', action: 'crearReservaManual', id: reserva?.espacio?.id)
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

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def reservaPlanificada(Long id){
        try{
            Espacio espacio = Espacio.get(id)
            User user = springSecurityService.getCurrentUser()

            if ( espacio?.empresa?.usuarioId == user?.id ){
                List<ReservaPlanificada> reservaPlanificadaList = ReservaPlanificada.findAllByEspacioAndFechaTerminoGreaterThanEquals(espacio, new Date() )
                respond espacio, model: [ reservaPlanificadaList: reservaPlanificadaList ]
            }else{
                render view: '/notFound'
            }
        }catch(e){}
    }

    @Secured(['ROLE_ADMIN', 'ROLE_SUPERUSER'])
    def eliminarReservaPlanificada(Long id){
        ReservaPlanificada reservaPlanificada = ReservaPlanificada.get(id)
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

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def crearPlanificada(Long id){
        List<Reserva> reservaList = []
        String hini = "${params?.horaInicio}:${params?.minInicio}"
        String hter = "${params?.horaTermino}:${params?.minTermino}"
        Espacio espacio = new Espacio()
        if( (utilService?.validarHorario(hini) < utilService?.validarHorario(hter)) && ( params?.fechaInicio != null && params?.fechaInicio?.length() > 0 ) &&  ( params?.fechaTermino != null && params?.fechaTermino?.length() > 0 )){
            try{
                ReservaPlanificada reservaPlanificada = new ReservaPlanificada()
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

    List<Reserva> crearReservasPlanificadas( ReservaPlanificada reservaPlanificada ){
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

    Boolean esHorarioLibre( def fecha, Long espacioId, String horaInicio, String horaTermino ){
        List<Reserva> reservaList = Reserva.createCriteria().list {
            and{
                eq('fechaReserva', fecha)
                estadoReserva {
                    ne('id', 3l)
                }
                espacio{
                    eq('id', espacioId)
                }
                eq('horaInicio', horaInicio)
                eq('horaTermino', horaTermino)
            }
        }
        return reservaList?.size() <= 0
    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def setValorFinal(Long id){
        try{
            Reserva reserva = Reserva.get(id)
            if( validadorPermisosUtilService?.validarRelacionReservaUser(reserva?.id) ){
                Integer aux = params?.valorFinal.toInteger()
                reserva.valorFinal = reserva?.valor
                reserva.valor = aux
                reservaService.save(reserva)
                flash.message = "Valor Final guardado correctamente."
            }
        }catch(e){ flash.error = "Ups! Ha ocurrido un error" }
        redirect(controller: 'reserva', action: 'show', id: id)
    }

    @Secured(['ROLE_USER','ROLE_SUPERUSER'])
    def cancelarReserva(){

    }

    def getHorariosDisponibles(){
        Reserva reserva = Reserva.get(params?.reserva?.toLong())
        List<Modulo> moduloList = []
        List<Reserva> reservaList = []
        String nombreDia
        Calendar c = Calendar.getInstance()
        List<Modulo> horarioList = []

        if( reserva && params?.fecha ){
            try{
                def fechaNuevaReserva = sdf.parse(params?.fecha)
                c.setTime(fechaNuevaReserva)
                nombreDia = formatoFechaUtilService?.obtenerNombreDia( c.get(Calendar.DAY_OF_WEEK))

                moduloList = Modulo.findAllByEspacio(reserva?.espacio)
                reservaList = Reserva.findAllByFechaReservaAndEspacio(c.getTime(), reserva?.espacio)

                for( modulo in moduloList ){
                    if( modulo?.dias?.getProperty(nombreDia) ){
                        if( !reservaList.find{ it?.horaInicio == modulo?.horaInicio } ){
                            horarioList.add(modulo)
                        }
                    }
                }
            }catch(e){}
        }
        render g.select(id: 'horario', name: 'horario',required: 'required', from: horarioList.sort{ it?.horaInicio }, optionKey: 'id', optionValue: 'horarioModulo' , noSelection: ['':'- Seleccione Horario -'], class: "form-control select2", style:"width: 100%;" )
    }

    def reagendarReserva(Long id){
        try{
            Reserva reserva = Reserva.get(id)
            ConfiguracionEmpresa configuracionEmpresa = ConfiguracionEmpresa.findByEmpresa(reserva?.espacio?.empresa)
            Modulo modulo = Modulo.get(params?.horario?.toLong())
            String templateEmpresa
            String templateUser
            if( reserva && modulo ){
                if( validadorPermisosUtilService?.userPuedeReagendarReserva(reserva,configuracionEmpresa)
                    && validadorPermisosUtilService?.validarRelacionReservaUser(reserva?.id)
                    && validadorPermisosUtilService?.validarRelacionEspacioModulo(modulo, reserva?.espacio)
                    && validadorPermisosUtilService?.validarRelacionModuloFecha(modulo, sdf.parse(params?.fechaReagendar)) ){

                    reserva.horaInicio = modulo?.horaInicio
                    reserva.horaTermino = modulo?.horaTermino
                    reserva.fechaReserva = sdf.parse(params?.fechaReagendar)
                    reserva.valor = modulo?.valor
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
}
