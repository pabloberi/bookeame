package reserva

import anotaciones.TrazaPrepago
import auth.User
import auth.UserService
import com.sun.org.apache.xpath.internal.operations.Bool
import configuracionEmpresa.ConfiguracionEmpresa
import dto.CrearReservaRs
import dto.EventoCalendario
import dto.ModuloDto
import empresa.Empresa
import espacio.Espacio
import evaluacion.Evaluacion
import evaluacion.EvaluacionService
import evaluacion.EvaluacionToUser
import feriados.Feriado
import flow.FlowEmpresa
import gestion.General
import gestion.NotificationService
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.annotation.Secured
import grails.web.mapping.LinkGenerator
import groovy.time.TimeCategory
import org.omg.PortableServer.SERVANT_RETENTION_POLICY_ID
import servicios.Servicio
import servicios.ServicioReserva
import servicios.ServicioUtilService

import javax.crypto.BadPaddingException
import javax.crypto.Cipher
import javax.crypto.IllegalBlockSizeException
import javax.crypto.NoSuchPaddingException
import javax.crypto.spec.SecretKeySpec
import java.security.InvalidKeyException
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.text.SimpleDateFormat

@Transactional
class ReservaUtilService {

    LinkGenerator grailsLinkGenerator
    ReservaService reservaService
    NotificationService notificationService

    def groovyPageRenderer
    def utilService
    def validadorPermisosUtilService
    def formatoFechaUtilService
    def springSecurityService

    UserService userService
    ReservaTempService reservaTempService
    PrepagoUtilService prepagoUtilService
    EvaluacionService evaluacionService
    ServicioUtilService servicioUtilService

    Boolean eliminarReserva(Long id) {
        Boolean responseEliminar = false
        try{
            Reserva reserva = Reserva.get(id)
            String template
            String email

            if( validadorPermisosUtilService?.validarRelacionReservaUser(id) ){
                Reserva reservaTemp = reserva

                if( validadorPermisosUtilService.esRoleAdmin() && reserva?.inicioExacto > new Date() ){
                    reservaService.delete(reserva?.id)
                    responseEliminar = true
                    template = groovyPageRenderer.render(template:  "/correos/cancelReservaByAdmin", model: [reserva: reservaTemp])
                    email = reservaTemp?.usuario?.email
                }
                if( validadorPermisosUtilService?.esRoleUser()
                        && validadorPermisosUtilService?.userPuedeCancelarReserva(reserva, ConfiguracionEmpresa.findByEmpresa(reserva?.espacio?.empresa)) ){
                    reservaService.delete(reserva?.id)
                    responseEliminar = true
                    template = groovyPageRenderer.render(template:  "/correos/cancelReservaByUser", model: [reserva: reservaTemp])
                    email = reservaTemp?.espacio?.empresa?.usuario?.email
                }
                if( responseEliminar ){
                    utilService.enviarCorreo(email, "noresponder@bookeame.cl", "Reserva Cancelada", template  )
                }
            }
        }catch(e){
            throw new Exception("Ha ocurrido un error")
        }
        return responseEliminar
    }

    List<EventoCalendario> getEventosCalendario(Long id, Long servicioId){ //ESPACIOID
        List<EventoCalendario> eventoList = []
        Espacio espacio = Espacio.findById(id)
        ConfiguracionEmpresa conf = ConfiguracionEmpresa.findByEmpresa(espacio?.empresa)
        String rol = validadorPermisosUtilService?.esRoleAdmin() ? "ADMIN" : "USER"
        try{
            List<Feriado> feriadoList = Feriado.findAllByEmpresaAndHabilitado(espacio?.empresa, true)
            if( validadorPermisosUtilService?.validarRelacionEspacioUser(id) || rol == "USER" ) {
                List<Modulo> moduloList
                List<Reserva> reservaList
                def dateList

                if( espacio ){
                    moduloList = Modulo.findAllByEspacio(espacio)
                    dateList = obteneFechaList(conf?.diasAMostrar ?: 7)
                    reservaList = obtenerReservas(espacio, rol)

                    eventoList.addAll(
                            obtenerModulosDisponibles(reservaList, moduloList, dateList,servicioId)
                    )

                    if( rol == "ADMIN" || ( rol == "USER" && Servicio.get(servicioId)) ){
                        for (reserva in reservaList ){
                            eventoList.add( reservaEventoConverter(reserva) )
                        }
                    }
                }

                if( feriadoList?.size() > 0 ){
                    def listaEliminar = eventoList.findAll { it ->
                        feriadoList.find { f -> it?.fechaReserva == f?.fecha }
                    }
                    if( listaEliminar?.size() > 0 ){
                        eventoList.removeAll(listaEliminar)
                    }
                }

            }
        }catch(e){
            log.error(e)
        }

        return eventoList
    }

    def obtenerModulosDisponibles(List<Reserva> reservaList, List<Modulo> moduloList, def dateList, Long servicioId){
        List<EventoCalendario> eventoList = []
        for( int i = 0; i < moduloList?.size(); i++){
            for( int j = 0; j < dateList?.size(); j++){
                if( moduloList[i]?.dias.getProperty(dateList[j][1]) ){
                    if(!reservaList.find{ it ->
                            (
                                it?.horaInicio == moduloList[i]?.horaInicio
                                && it?.horaTermino == moduloList[i]?.horaTermino
                                && it?.fechaReserva == dateList[j][2]
                            )
                            ||
                            (
                                    convertHoraToInteger(moduloList[i]?.horaInicio) >= convertHoraToInteger(it?.horaInicio)
                                    && convertHoraToInteger(moduloList[i]?.horaInicio) < convertHoraToInteger(it?.horaTermino)
                                    && it?.fechaReserva == dateList[j][2]
                            )
                        }
                        && esFechaValida( moduloList[i], dateList[j][0] )
                    ){
                        eventoList.add( moduloEventoConverter(moduloList[i], dateList[j], servicioId) )
                    }
                }
            }
        }
        return eventoList
    }

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
        return  dateList
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

    EventoCalendario reservaEventoConverter(Reserva reserva){
        EventoCalendario evento = new EventoCalendario()
        try{
            evento.setReservaId(reserva?.id)
            evento.setStart(reserva?.fechaReserva?.toString()?.substring(0,10) + 'T' + reserva?.horaInicio +':00')
            evento.setEnd(reserva?.fechaReserva?.toString()?.substring(0,10) + 'T' + reserva?.horaTermino +':00')
            evento.setDescription("Reserva")
            evento.setHoraInicio(reserva?.horaInicio)
            evento.setHoraTermino(reserva?.horaTermino)
            evento.setFechaReserva(  formatoFechaUtilService?.formatFecha(reserva?.fechaReserva, "dd-MM-yyyy") )
            if( reserva?.disponible ){
                evento.setTitle("Reservado" )
                evento.setClassName("bg-secondary border-info text-white")
                evento.setUsuario(reserva?.usuario?.nombre ? reserva?.usuario?.nombre ?: '' + " " + reserva?.usuario?.apellidoPaterno  ?: '' : reserva?.usuario?.username)
                evento.setValor('$ ' + reserva?.valor +' .-')
                evento.setUrlDelete(grailsLinkGenerator.link(controller: 'reserva', action: reserva?.tipoReserva?.id != 2 ? 'eliminarReserva' : 'declaracionEliminacionPrepago', id: reserva?.id))
                evento.setUrlFicha(grailsLinkGenerator.link(controller: 'reserva', action: 'show', id: reserva?.id))
            }else{
                evento.setTitle("No Disponible")
                evento.setClassName("bg-orange border-info text-white")
                evento.setUsuario("No aplica")
                evento.setValor("No aplica")
            }
        }catch(e){
            log.error(e)
        }
        return evento
    }

    EventoCalendario moduloEventoConverter(Modulo modulo, def fecha, Long servicioId){
        EventoCalendario evento = new EventoCalendario()
        try{
            evento.setTitle("Disponible")
            evento.setClassName("bg-info border-info text-white")
            evento.setStart(fecha[0] + 'T' + modulo?.horaInicio +':00')
            evento.setEnd(fecha[0] + 'T' + modulo?.horaTermino +':00')
            evento.setModulo(modulo?.id)
            evento.setDescription("Reserva")
            evento.setHoraInicio(modulo?.horaInicio)
            evento.setHoraTermino(modulo?.horaTermino)
            evento.setFechaReserva(fecha[3])
            evento.setValor('$ ' + modulo?.valor +' .-')
            evento.setUrlSave(
                    grailsLinkGenerator.link(controller: 'reserva', action: 'create', id: modulo?.espacio?.id) +
                            "?fecha=${fecha[3]}" + URLEncoder.encode("&", "UTF-8") + "moduloId=${modulo?.id}"
            )
            if( servicioId != null ){
                String url = evento.getUrlSave() + URLEncoder.encode("&", "UTF-8") + "servicioId=${servicioId}"
                evento.setUrlSave(url)
            }
        }catch(e){
            log.error(e)
        }
        return evento
    }

    Boolean puedeCrearReserva(Long moduloId, Long espacioId, String fecha){ //USUARIO PUEDE ACCEDER A LA VISTA CREAR RESERVA
        Boolean response = false
        Modulo modulo = Modulo.get(moduloId)
        Espacio espacio = Espacio.get(espacioId)
        if( validadorPermisosUtilService?.validarRelacionEspacioModulo(modulo,espacio)
                && validadorPermisosUtilService?.validarRelacionModuloFecha(
                    modulo, formatoFechaUtilService?.stringToDateConverter( fecha, "dd-MM-yyyy" )
        ) ){
            if( validadorPermisosUtilService?.esRoleUser() ){
                response = true
            }
            if( validadorPermisosUtilService?.esRoleAdmin()
                    && validadorPermisosUtilService?.validarRelacionEspacioUser(espacio?.id)){
                response = true
            }
        }
        return response
    }

    def crearReserva(def params, Long tipoReservaId){
        CrearReservaRs crearReservaRs = new CrearReservaRs()
        crearReservaRs.setCodigo("01")
        crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
        try{
            Espacio espacio = Espacio.get( params?.espacioId?.toLong() )
            ConfiguracionEmpresa conf = ConfiguracionEmpresa.findByEmpresa(espacio?.empresa)
            Modulo modulo = Modulo.get( params?.moduloId?.toLong() )
            ModuloDto moduloDto = convertModuloToDto( modulo, params?.horaTermino, params?.valor?.toInteger() )
            def fecha = formatoFechaUtilService?.stringToDateConverter(params?.fechaReserva, "dd-MM-yyyy")
            def fechaString = formatoFechaUtilService.formatFecha(fecha,"dd-MM-yyyy")

            if( validarDatosParaReserva( moduloDto.getHoraInicio(), moduloDto.getHoraTermino(), moduloDto.getValor(),
                    espacio?.id, fechaString, params?.code ) ){
                if( validadorPermisosUtilService.esRoleUser() ){

                    if( !reservaDisponible(moduloDto, fechaString) ){
                        crearReservaRs.setCodigo("01")
                        crearReservaRs.setMensaje("Modulo no disponible")
                        log.error("Ha ocurrido un error inesperado")
                        return crearReservaRs
                    }
                    crearReservaRs = crearReservaUsuario( conf, moduloDto, espacio, fecha, tipoReservaId )
                }
                if( validadorPermisosUtilService.esRoleAdmin() ){
                    User user = new User()
                    if( params?.userId ){
                        user =  User.get( params?.userId?.toLong() )
                    }else{
                        if( User.findByEmail(params?.correoUser)){
                            user = User.findByEmail(params?.correoUser)
                        }else{
                            user.nombre = params?.nombreUser
                            user.email = params?.correoUser
                            user.celular = params?.celularUser
                            user.username = params?.correoUser
                            user.password = params?.correoUser
                            user.invitado = true
                            user.accountLocked = true
                            userService.save(user)
                            String link = createLink( base:  General.findByNombre("baseUrl")?.valor, controller: 'user', action: 'registroInvitado', id: user?.id)
                            String template = groovyPageRenderer.render(template:  "/correos/invitarUser", model: [user: user, link: link])
                            utilService?.enviarCorreo(user?.email, "noresponder@bookeame.cl", "Termina tu registro y reserva fácil", template)
                        }
                    }
                    crearReservaRs = crearReservaEmpresa( moduloDto, espacio, fecha, tipoReservaId, user )
                }
            }else{
                crearReservaRs.setCodigo("01")
                crearReservaRs.setMensaje("Modulo no disponible")
                log.error("Ha ocurrido un error inesperado")
                return crearReservaRs
            }

        }catch(e){
            crearReservaRs.setCodigo("01")
            crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
            log.error("Ha ocurrido un error inesperado")
            return crearReservaRs
        }
        if( params?.servicio != null && params?.servicio != "" ){
            if( crearReservaRs.getReservaId() && params?.servicio?.toLong()){
                servicioUtilService.guardarServicioEnReserva(params?.servicio?.toLong(), crearReservaRs.getReservaId() )
            }
        }

        return crearReservaRs
    }

//    @TrazaPrepago
    def crearReservaUsuario(ConfiguracionEmpresa conf, ModuloDto modulo, Espacio espacio, Date fecha, Long tipoReservaId){
        CrearReservaRs crearReservaRs = new CrearReservaRs()
        crearReservaRs.setCodigo("01")
        crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
        User user = springSecurityService.getCurrentUser()
        String responsePago
        if( tipoReservaId == 1 && conf?.tipoPago?.pospago ){
            if( reservaPosPagoValidar(user) ){
                Reserva reserva = new Reserva(
                        horaInicio: modulo?.getHoraInicio(),
                        horaTermino: modulo?.getHoraTermino(),
                        fechaReserva: fecha,
                        valor: modulo?.getValor(),
                        espacio: espacio,
                        tipoReserva: TipoReserva.findById(1),
                        estadoReserva: EstadoReserva.findById(1),
                        usuario: user
                )
                reservaService.save(reserva)
                notificationService.sendPushNotification(reserva?.espacio?.empresa?.usuarioId, "Solicitud de reserva", "Tienes una solicitud de reserva pospago.")
                String template = groovyPageRenderer.render(template:  "/correos/solicitudReservaUsuario", model: [reserva: reserva])
                utilService?.enviarCorreo(reserva?.usuario?.email, "noresponder@bookeame.cl", "Solicitud de Reserva", template)
                crearReservaRs.setCodigo("0")
                crearReservaRs.setMensaje("Reserva Creada Exitosamente!")
                crearReservaRs.setReservaId(reserva?.id)
                return crearReservaRs
            }else{
                crearReservaRs.setCodigo("01")
                crearReservaRs.setMensaje("Has superado la cantidad máxima de reservas Pos Pago vigentes.")
                log.error("Usuario superó la cantidad máxima de reservas Pos Pago vigentes")
            }
        }
        if( tipoReservaId == 2 && conf?.tipoPago?.prepago ){
            ReservaTemp reservaTemp = new ReservaTemp()
            if( modulo?.getValor() > General.findByNombre('valorMinFlow')?.valor?.toInteger() ?: 0 ){
                try {
                    reservaTemp.usuario = user
                    reservaTemp.fechaReserva = fecha
                    reservaTemp.horaInicio = modulo?.getHoraInicio()
                    reservaTemp.horaTermino = modulo?.getHoraTermino()
                    reservaTemp.valor = modulo?.getValor()
                    reservaTemp.espacio = modulo?.getEspacio()
                    reservaTemp.tipoReserva = TipoReserva.findById(2)
                    reservaTemp.estadoReserva = EstadoReserva.findById(2)
                    reservaTempService.save(reservaTemp)
                } catch (e) {
                    crearReservaRs.setCodigo("01")
                    crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
                    return crearReservaRs
                }
                responsePago = prepagoUtilService?.pagarReserva(reservaTemp)
                println(responsePago)

                if( responsePago == "error" ){
                    crearReservaRs.setCodigo("01")
                    crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
                    reservaTempService.delete(reservaTemp?.id)
                    return crearReservaRs
                }

                crearReservaRs.codigo = "0"
                crearReservaRs.mensaje = responsePago
                crearReservaRs.reservaId = reservaTemp?.id
                return crearReservaRs

            }else{
                crearReservaRs.setCodigo("01")
                crearReservaRs.setMensaje("Valor de la reserva no permite pagos en línea.")
                return crearReservaRs
            }
        }
        return crearReservaRs
    }

    def crearReservaEmpresa( ModuloDto modulo, Espacio espacio, Date fecha, Long tipoReservaId,User user){
        CrearReservaRs crearReservaRs = new CrearReservaRs()
        crearReservaRs.setCodigo("01")
        crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
        if( tipoReservaId == 3 ){
            Reserva reserva = new Reserva(
                    horaInicio: modulo?.getHoraInicio(),
                    horaTermino: modulo?.getHoraTermino(),
                    fechaReserva: fecha,
                    valor: modulo?.getValor(),
                    espacio: espacio,
                    tipoReserva: TipoReserva.findById(3),
                    estadoReserva: EstadoReserva.findById(2),
                    usuario: user
            )
            reservaService.save(reserva)
            notificationService.sendPushNotification(reserva?.usuarioId, "Reserva Creada", "Se ha creado una reserva a tu nombre.")
            String template = groovyPageRenderer.render(template:  "/correos/confirmacionReservaUser", model: [reserva: reserva])
            utilService?.enviarCorreo(reserva?.usuario?.email, "noresponder@bookeame.cl", "Confirmación de Reserva", template)
            crearReservaRs.setCodigo("0")
            crearReservaRs.setMensaje("Reserva Creada Exitosamente!")
            crearReservaRs.setReservaId(reserva?.id)
        }
        return crearReservaRs
    }

    def reservaDisponible(ModuloDto modulo, String fecha){
        Date hoy = new Date()
        def pattern = "dd-MM-yyyy"
        def fechaReserva = new SimpleDateFormat(pattern).parse(fecha)
        Calendar c = Calendar.getInstance()
        c.setTime(fechaReserva)
        c.set(Calendar.MINUTE, modulo.getHoraInicio().substring(3,5).toInteger())
        c.set(Calendar.HOUR_OF_DAY, modulo.getHoraInicio().substring(0,2).toInteger())
        Calendar d = Calendar.getInstance()
        d.setTime(fechaReserva)
        d.set(Calendar.MINUTE, modulo.getHoraTermino().substring(3,5).toInteger())
        d.set(Calendar.HOUR_OF_DAY, modulo.getHoraTermino().substring(0,2).toInteger())
        if( c.getTime() >= hoy ){
            List<Reserva> reservaList = Reserva.createCriteria().list {
                and{
                    or{
                        and{
                            le('inicioExacto', c.getTime())
                            gt('terminoExacto', c.getTime())
                        }
                        and{
                            lt('inicioExacto', d.getTime())
                            ge('terminoExacto', d.getTime())
                        }
                    }
                    estadoReserva {
                        ne('id', 3l)
                    }
                    espacio{
                        eq('id', modulo.getEspacio().id)
                    }
                }
            }

            List<ReservaTemp> reservaTempList = ReservaTemp.createCriteria().list {
                and{
                    or{
                        and{
                            le('inicioExacto', c.getTime())
                            gt('terminoExacto', c.getTime())
                        }
                        and{
                            lt('inicioExacto', d.getTime())
                            ge('terminoExacto', d.getTime())
                        }
                    }
                    estadoReserva {
                        ne('id', 3l)
                    }
                    espacio{
                        eq('id', modulo.getEspacio().id)
                    }
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
        if( validadorPermisosUtilService?.esRoleAdmin() ){ return true }
        if( reservaList.size() < General.findByNombre('maximoPosPago')?.valor?.toInteger() ){
            return true
        }else{
            return false
        }
    }

    Boolean esFechaValida(Modulo modulo, String date){
        try{
            Date fechaModulo = formatoFechaUtilService?.stringToDateConverter(date + " ${modulo?.horaInicio}:00", "yyyy-MM-dd HH:mm:ss")
            if( fechaModulo > new Date() ){
                return true
            }
            return false
        }catch(e){
            throw new Exception()
        }
        return false
    }

    //ENCRIPTACION
    Boolean validarDatosParaReserva(String horaInicio, String horaTermino, Long valor, Long espacio,
                                    String fecha, String token){
        try{
            String datos = datosToJsonConverter( horaInicio, horaTermino, valor, espacio, fecha )
            if( desencriptarDatosReserva(token, "Gol220022@") == datos ){
                return true
            }
            return false
        }catch(e){
            throw new Exception(e)
        }
    }

    String encriptarDatosReserva(ModuloDto modulo, Espacio espacio, String fecha){
        try{
            String  datos = datosToJsonConverter(modulo.getHoraInicio(), modulo.getHoraTermino(), modulo.getValor(), espacio?.id, fecha)
            SecretKeySpec secretKey = crearClave("Gol220022@")

            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding")
            cipher.init(Cipher.ENCRYPT_MODE, secretKey)

            byte[] datosEncriptar = datos.getBytes("UTF-8")
            byte[] bytesEncriptados = cipher.doFinal(datosEncriptar)
            String token = Base64.getEncoder().encodeToString(bytesEncriptados)
            return token
        }catch(e){
            throw new Exception(e)
        }
    }

    String desencriptarDatosReserva(String datosEncriptados, String claveSecreta) throws UnsupportedEncodingException, NoSuchAlgorithmException, InvalidKeyException, NoSuchPaddingException,
            IllegalBlockSizeException, BadPaddingException {
        try{
            SecretKeySpec secretKey = this.crearClave(claveSecreta);

            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);

            byte[] bytesEncriptados = Base64.getDecoder().decode(datosEncriptados);
            byte[] datosDesencriptados = cipher.doFinal(bytesEncriptados);
            String datos = new String(datosDesencriptados);

            return datos
        }catch(e){
            throw new Exception(e)
        }
    }

    String datosToJsonConverter(String horaInicio, String horaTermino, Long valor, Long espacio, String fecha){
        def json = [:]
        json.fechaReserva = fecha
        json.horaInicio = horaInicio
        json.horaTermino = horaTermino
        json.valor = valor
        json.espacio = espacio
        return json
    }

    private SecretKeySpec crearClave(String clave) throws UnsupportedEncodingException, NoSuchAlgorithmException {
        try{
            byte[] claveEncriptacion = clave.getBytes("UTF-8");

            MessageDigest sha = MessageDigest.getInstance("SHA-1");

            claveEncriptacion = sha.digest(claveEncriptacion);
            claveEncriptacion = Arrays.copyOf(claveEncriptacion, 16);

            SecretKeySpec secretKey = new SecretKeySpec(claveEncriptacion, "AES");

            return secretKey;
        }catch(e){
            throw new Exception(e)
        }
    }

    def registrarPago(Long id, String pago){
        boolean exito = false
        Reserva reserva = Reserva.findById(id)
        if(reserva){
            try{
                if( pago != null && pago.length() > 0){
                    reserva.valor = pago?.toInteger()
                    reservaService.save(reserva)
                    exito = true
                }
            }catch(e){ exito = false }
        }else{ exito = false }

        return exito
    }

    def registrarEvaluacion(Long id, String nota, String comentario){
        boolean exito = true
        Reserva reserva = Reserva.findById(id)
        if(reserva){
            try{
                Evaluacion evaluacion = reserva?.evaluacion ?: new Evaluacion()

                if( nota != null && nota.length() > 0){evaluacion.evaluacionToUser = EvaluacionToUser.findById( nota?.toLong() )}
                if( comentario != null && comentario.length() > 0){evaluacion.comentarioToUser = comentario}

                evaluacionService.save(evaluacion)
                reserva.evaluacion = evaluacion
                reservaService.save(reserva)
            }catch(e){ exito = false }
        }else{ exito = false }

        if( exito ){
            actualizarNotaUser(reserva?.usuario, reserva?.evaluacion?.evaluacionToUser?.nota)
        }
        return exito
    }

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

    def getValorReserva(Long reservaId){
        try{
            List<ServicioReserva> servicioReservaList = servicioUtilService.getServiciosPorReserva(reservaId)
            if(servicioReservaList?.size() > 0 ){
                int contador = 0
                for( srv in servicioReservaList ){
                    contador = contador + srv?.valor
                }
                return contador
            }else{
                return Reserva.get(reservaId)?.valor
            }
        }catch(e){
            return 0
        }

    }

    String textoValorPrepago(float comision){
        if( comision == 0 ){
            return "Pago en Linea"
        }else{
            return "Pago en Linea + ${comision} % + IVA"
        }
    }

    def nuevaHoraInicio( String horaInicio, Integer minutosAdicionales ){
        try{
            // Dividir la cadena de hora en partes
            def partesHora = horaInicio.split(':')

            // Extraer la hora y los minutos como enteros
            Integer horaInt = partesHora[0].toInteger()
            Integer minutosInt = partesHora[1].toInteger()

            // Sumar los minutos adicionales
            minutosInt += minutosAdicionales

            // Realizar ajustes si los minutos superan 60
            if (minutosInt >= 60) {
                horaInt += minutosInt / 60
                minutosInt = minutosInt % 60
            }
            // Realizar ajustes si las horas superan 24
            if (horaInt >= 24) {
                horaInt = horaInt % 24
            }
            // Formatear el resultado
            def nuevaHoraString = "${horaInt.toString().padLeft(2, '0')}:${minutosInt.toString().padLeft(2, '0')}"

            return nuevaHoraString
        }catch(Exception e){
            throw new Exception("Error al setear nueva hora termino")
        }
    }

    def getServiciosPorEspacio(Long id){
        List<Servicio> servicioList = new ArrayList<>()
        try{
            Espacio espacio = Espacio.get(id)
            servicioList = Servicio.createCriteria().list {
                and{
                    espacios {
                        eq('id', espacio?.id)
                    }
                    eq('habilitado', true)
                }

            }
            return servicioList
        }catch(Exception e){
            return servicioList
        }
    }

    def filtrarModulosPorServicio(List<EventoCalendario> eventoList, Long servicioId){
        List<EventoCalendario> eventoListAux = eventoList
        List<EventoCalendario> eliminados = new ArrayList<>()

        try{
            Servicio servicio = Servicio.get(servicioId)

            Set<String> fechasUnicas = eventoList.collect { it.fechaReserva }.toSet()
            String[] arregloFechas = fechasUnicas.toArray(new String[fechasUnicas.size()])

            arregloFechas.each {
                List<EventoCalendario> mismoDiaList = eventoListAux.findAll { aux ->
                    aux?.fechaReserva ==  it
                }
                def horaCierredelDia = convertHoraToInteger(mismoDiaList?.max{ hc -> convertHoraToInteger(hc?.horaTermino) }?.horaTermino)

                mismoDiaList.each { ev ->
                    if( ev?.getTitle() == "Disponible" ){
                        def horaInicioModuloInt = convertHoraToInteger(ev?.getHoraInicio())
                        def nuevoTermino = nuevaHoraInicio(ev?.getHoraInicio(), servicio?.duracionAdicional)
                        def nuevoTerminoInt = convertHoraToInteger(nuevoTermino)

                        def reservasDelDia = mismoDiaList.findAll { rdd -> rdd?.getTitle() == "Reservado" }

                        if(  reservasDelDia?.findAll { std ->
                            (convertHoraToInteger(std?.horaInicio) >= horaInicioModuloInt &&
                                    convertHoraToInteger(std?.horaInicio) < nuevoTerminoInt ) ||
                            ( convertHoraToInteger(std?.horaTermino) > horaInicioModuloInt &&
                                    convertHoraToInteger(std?.horaTermino) <= nuevoTerminoInt )
                        } ){
                            eliminados.add(ev)
                        }
                        if( nuevoTerminoInt >  horaCierredelDia){
                            eliminados.add(ev)
                        }
                    }
                }
            }
            eventoListAux.removeAll(eliminados)
            return eventoListAux
        }catch(Exception e){
            return eventoList
        }
    }

    def convertHoraToInteger(String hora){
        Integer tiempoNumerico = Integer.parseInt(hora.replaceAll(":", ""))
        return tiempoNumerico
    }

    ModuloDto convertModuloToDto(Modulo modulo, String horaTermino, Integer valor){
        ModuloDto moduloDto = new ModuloDto()
        moduloDto.setEspacio(modulo?.espacio)
        moduloDto.setHoraInicio(modulo?.horaInicio)
        moduloDto.setHoraTermino( horaTermino )
        moduloDto.setValor( valor )
        moduloDto.setDias(modulo?.dias)
        return moduloDto
    }
}
