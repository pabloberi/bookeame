package reserva

import auth.User
import auth.UserService
import flow.FlowEmpresa
import gestion.General
import gestion.NotificationService
import grails.gorm.transactions.Transactional
import grails.web.mapping.LinkGenerator

@Transactional
class PrepagoUtilService {

    ReservaTempService reservaTempService
    def flowService
    def springSecurityService
    def formatoFechaUtilService
    String pagarReserva(ReservaTemp reserva){
        User user = springSecurityService.getCurrentUser()
        String urlConfirm = "reserva/confirmFlow"
        String urlReturn = "reserva/reservasVigentesUser"
        try{
            if( user && reserva){
                FlowEmpresa flowEmpresa = FlowEmpresa.findByEmpresa(reserva?.espacio?.empresa)
                if( flowEmpresa ){
                    def params = [
                            "amount"         : costoTransaccion(reserva?.valor, flowEmpresa?.comision?.valor ?: 3.19 ),
                            "apiKey"         : flowEmpresa?.apiKey,
                            "commerceOrder"  : flowService.correlativoFlow(),
                            "email"          : user?.email ?: "pablo@bericul.com",
                            "subject"        : "Pago de reserva ${reserva?.espacio?.nombre} ${formatoFechaUtilService?.formatFecha(reserva?.fechaReserva, 'dd-MM-yyyy')} ${reserva?.horaInicio}",
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
        }catch(e){
            return "error"
        }

    }

    void registroToken(String token, ReservaTemp reserva){
        try{
            reserva.token = token
            reservaTempService.save(reserva)
        }catch(e){}
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
}
