package reserva
import auth.User
import auth.UserService
import com.sun.org.apache.xpath.internal.operations.Bool
import configuracionEmpresa.ConfiguracionEmpresa
import dto.CrearReservaRs
import dto.EventoCalendario
import empresa.Empresa
import espacio.Espacio
import flow.FlowEmpresa
import gestion.General
import gestion.NotificationService
import grails.gorm.transactions.Transactional
import grails.web.mapping.LinkGenerator

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
    def tempService
    UserService userService
    ReservaTempService reservaTempService
    PrepagoUtilService prepagoUtilService

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

    List<EventoCalendario> getEventosCalendario(Long id){ //ESPACIOID
        List<EventoCalendario> eventoList = []
        Espacio espacio = Espacio.findById(id)
        ConfiguracionEmpresa conf = ConfiguracionEmpresa.findByEmpresa(espacio?.empresa)
        String rol = validadorPermisosUtilService?.esRoleAdmin() ? "ADMIN" : "USER"
        try{
            if( validadorPermisosUtilService?.validarRelacionEspacioUser(id) || rol == "USER" ) {
                List<Modulo> moduloList
                List<Reserva> reservaList
                def dateList

                if( espacio ){
                    moduloList = Modulo.findAllByEspacio(espacio)
                    dateList = obteneFechaList(conf?.diasAMostrar ?: 7)
                    reservaList = obtenerReservas(espacio, rol)

                    eventoList.addAll(
                            obtenerModulosDispónibles(reservaList, moduloList, dateList)
                    )

                    if( rol == "ADMIN"){
                        for (reserva in reservaList ){
                            eventoList.add( reservaEventoConverter(reserva) )
                        }
                    }
                }
            }
        }catch(e){
            log.error(e)
        }

        return eventoList
    }

    def obtenerModulosDispónibles(List<Reserva> reservaList, List<Modulo> moduloList, def dateList){
        List<EventoCalendario> eventoList = []
        for( int i = 0; i < moduloList?.size(); i++){
            for( int j = 0; j < dateList?.size(); j++){
                if( moduloList[i]?.dias.getProperty(dateList[j][1]) ){
                    if(!reservaList.find{ it ->
                        it?.horaInicio == moduloList[i]?.horaInicio
                                && it?.horaTermino == moduloList[i]?.horaTermino
                                && it?.fechaReserva == dateList[j][2] } && esFechaValida( moduloList[i], dateList[j][0] )
                    ){
                        eventoList.add( moduloEventoConverter(moduloList[i], dateList[j]) )
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

    EventoCalendario moduloEventoConverter(Modulo modulo, def fecha){
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
            def fecha = formatoFechaUtilService?.stringToDateConverter(params?.fechaReserva, "dd-MM-yyyy")
            def fechaString = formatoFechaUtilService.formatFecha(fecha,"dd-MM-yyyy")

            if( validarDatosParaReserva( modulo?.horaInicio, modulo?.horaTermino, modulo?.valor,
                    espacio?.id, fechaString, params?.code ) && reservaDisponible(modulo, fechaString)  ){
                if( validadorPermisosUtilService.esRoleUser() ){
                    return crearReservaUsuario( conf, modulo, espacio, fecha, tipoReservaId )
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
                    return crearReservaEmpresa( modulo, espacio, fecha, tipoReservaId, user )
                }
            }else{
                crearReservaRs.setCodigo("01")
                crearReservaRs.setMensaje("Modulo no disponible")
                log.error("Ha ocurrido un error inesperado")
            }

        }catch(e){
            crearReservaRs.setCodigo("01")
            crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
            log.error("Ha ocurrido un error inesperado")
        }
        return crearReservaRs
    }

    def crearReservaUsuario(ConfiguracionEmpresa conf, Modulo modulo, Espacio espacio, Date fecha, Long tipoReservaId){
        CrearReservaRs crearReservaRs = new CrearReservaRs()
        crearReservaRs.setCodigo("01")
        crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
        User user = springSecurityService.getCurrentUser()
        String responsePago
        if( tipoReservaId == 1 && conf?.tipoPago?.pospago ){
            if( reservaPosPagoValidar(user) ){
                Reserva reserva = new Reserva(
                        horaInicio: modulo?.horaInicio,
                        horaTermino: modulo?.horaTermino,
                        fechaReserva: fecha,
                        valor: modulo?.valor,
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
            if( modulo?.valor > General.findByNombre('valorMinFlow')?.valor?.toInteger() ?: 0 ){
                try {
                    reservaTemp.usuario = user
                    reservaTemp.fechaReserva = fecha
                    reservaTemp.horaInicio = modulo?.horaInicio
                    reservaTemp.horaTermino = modulo?.horaTermino
                    reservaTemp.valor = modulo?.valor
                    reservaTemp.espacio = modulo?.espacio
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
                int tiempoTrigger = 15
                tempService.triggerReservaTemp(reservaTemp?.id, tiempoTrigger)

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


    def crearReservaEmpresa( Modulo modulo, Espacio espacio, Date fecha, Long tipoReservaId,User user){
        CrearReservaRs crearReservaRs = new CrearReservaRs()
        crearReservaRs.setCodigo("01")
        crearReservaRs.setMensaje("Ha ocurrido un error inesperado")
        if( tipoReservaId == 3 ){
            Reserva reserva = new Reserva(
                    horaInicio: modulo?.horaInicio,
                    horaTermino: modulo?.horaTermino,
                    fechaReserva: fecha,
                    valor: modulo?.valor,
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

    def reservaDisponible(Modulo modulo, String fecha){
        Date hoy = new Date()
        def pattern = "dd-MM-yyyy"
        def fechaReserva = new SimpleDateFormat(pattern).parse(fecha)
        Calendar c = Calendar.getInstance()
        c.setTime(fechaReserva)
        c.set(Calendar.MINUTE, modulo?.horaInicio.substring(3,5).toInteger())
        c.set(Calendar.HOUR_OF_DAY, modulo?.horaInicio.substring(0,2).toInteger())
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

    String encriptarDatosReserva(Modulo modulo, Espacio espacio, String fecha){
        try{
            String  datos = datosToJsonConverter(modulo?.horaInicio, modulo?.horaTermino, modulo?.valor, espacio?.id, fecha)
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


}
