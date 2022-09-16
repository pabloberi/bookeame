package espacio

import auth.User
import empresa.Empresa
import flow.FlowEmpresa
import gestion.General
import reserva.Reserva
import reserva.ReservaService
import reserva.ReservaTemp
import reserva.ReservaTempService
import grails.gorm.transactions.Transactional
import grails.util.Holders

/**
 * UserService
 * A service class encapsulates the core business logic of a Grails application
 */

@Transactional
class UtilService {
    ReservaTempService reservaTempService
    ReservaService reservaService
    def flowService
    def springSecurityService = Holders.applicationContext.getBean('springSecurityService')
    def quartzService
    def mailService
    def tempService
//    private MessageSource messageSource;
    String uploadFile(byte[] bytes, String fileName, String destinationDirectory) {

        String filePath = destinationDirectory
        File dir = new File(filePath)
        if (!dir.exists()) {
            dir.mkdirs()
        }
        File actualFile = new File(filePath, fileName)

        actualFile.withOutputStream { out ->
            out.write bytes
        }
        return true
    }

    def obtenerExtension(String nombreArchivo) {
//            doc.filename.lastIndexOf('.')  retorna el largo del string desde el ultimo punto hasta el primer caracter
//            doc.filename.length() retorna el largo del string
        List nombreArchivoList = nombreArchivo as List
        List extensionList = []
        int j = 0
        for (int i = nombreArchivo.lastIndexOf('.'); i <= nombreArchivo.length(); i++) {
            extensionList[j] = nombreArchivoList[i]
            j++
        }
        extensionList.removeAll { value -> value == null }
        StringBuilder sb = new StringBuilder()
        for (String item : extensionList) {
            sb.append(item)
        }
        String extensionString = sb.toString()
        return extensionString
    }

    Integer cantSolicitudes(){
        List<Reserva> solicitudList = []
        try{
            User user = springSecurityService.getCurrentUser()
            if( user ){
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
                    solicitudList = Reserva.createCriteria().list{
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
                }
            }
        }catch(e){}

        return solicitudList.size()
    }

    void eliminarReservaTemp(Long id){
        try{
            if( ReservaTemp.findById(id) ) {
                reservaTempService.delete(id)
                println('reserva temporal eliminada por el trigger.')
//                ReservaTemp reservaTemp = ReservaTemp.findById(id)
//                FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa( reservaTemp?.espacio?.empresa)
//                if( flowEmpresa ){
//                    def response = flowService.paymentStatus(reservaTemp?.token, flowEmpresa?.apiKey, flowEmpresa?.secretKey)
//                    switch (response){
//                        case 1:
////                                int tiempoTrigger = 11
////                                tempService.triggerReservaTemp(reservaTemp?.id, tiempoTrigger)
//                                println ( 'PASARON 15 MINUTOS Y SIGUE PENDIENTE ')
//                            break
//                        case 2:
//                            println( 'El estado es : ' + response )
//                            break
//                        case 3:
//                            println( 'El estado es : ' + response )
//                            break
//                        case 4:
//                            reservaTempService.delete(id)
//                            println('reserva temporal eliminada por el trigger. Estado : Anulada.')
//                            break
//                    }
//                }
            }else{
                println('reserva temporal eliminada por el controlador')
            }
        }catch(e){
            println('error al eliminar reserva temporal')
        }
    }

    void enviarCorreo( String para, String desde, String asunto, String template){
        mailService.sendMail {
                async true
                to para
                from desde
                subject asunto
                html template
        }
    }

    Integer validarHorario( String hora ){
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
            def aux =  hour + minutes
            return aux.toInteger()
        }
    }

    String codigoEstadoCuenta(Long empresaId){
        Calendar c = Calendar.getInstance()
        c.setTime(new Date())
//        Formatter diaFrm = new Formatter()
        Formatter mesFrm = new Formatter()

        Integer year = c.get(Calendar.YEAR) // obtengo el año actual
        Integer month = c.get(Calendar.MONTH) + 1 // obtengo el mes actual
//        Integer day = c.get(Calendar.DAY_OF_MONTH)

        mesFrm.format("%02d", month)
//        diaFrm.format("%02d", day)

        return year.toString() + mesFrm + "-" + empresaId?.toString()
    }

    def indiceEfectividad(def total, def fraccion){
        if( total > 0 ){
            return (fraccion * 100) / total
        }else{
            return 0
        }
    }

//    void codigoReserva(Reserva reserva){ // reserva?.id
//        Calendar c = Calendar.getInstance()
//        c.setTime(new Date())
//        Formatter diaFrm = new Formatter()
//        Formatter mesFrm = new Formatter()
//
//        Integer year = c.get(Calendar.YEAR) // obtengo el año actual
//        Integer month = c.get(Calendar.MONTH) + 1 // obtengo el mes actual
//        Integer day = c.get(Calendar.DAY_OF_MONTH)
//
//        mesFrm.format("%02d", month)
//        diaFrm.format("%02d", day)
//        String aux =  reserva?.id?.toString()
//        String aux2 = year?.toString()
//        reserva.codigo = "${diaFrm}${mesFrm}${aux2}-${aux}"
//        reserva.save()
//    }

}
