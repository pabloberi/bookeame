package reserva

import auth.User
import empresa.Empresa
import espacio.Espacio
import evaluacion.Evaluacion
import flow.FlowEmpresa
import gestion.NotificationService
import grails.util.Holders

class Reserva {

    User usuario
    Date fechaReserva
    String horaInicio
    String horaTermino
    Integer valor
    Espacio espacio
    TipoReserva tipoReserva
    EstadoReserva estadoReserva
    Evaluacion evaluacion
    String token
    Integer valorComisionFlow = 0
    Boolean disponible = true

    Integer valorFinal
    String codigo

    Date inicioExacto
    Date terminoExacto

    Date dateCreated

//    static belongsTo = [reservaPlinificada: ReservaPlanificada]
    static constraints = {
        usuario nullable: true
        fechaReserva nullable: true
        tipoReserva nullable: true
        estadoReserva nullable: true
        espacio nullable: true
        horaInicio nullable: true
        horaTermino nullable: true
        valor nullable: true
        evaluacion nullable: true
        token nullable: true
        disponible nullable: true
        inicioExacto nullable: true
        terminoExacto nullable: true
        valorFinal nullable: true
        codigo nullable: true
        valorComisionFlow nullable: true
//        reservaPlinificada nullable: true
    }

    def utilService

    def beforeInsert(){
        try{
            Calendar c = Calendar.getInstance()
            c.setTime(this?.fechaReserva)
            c.set(Calendar.SECOND, 0)
            c.set(Calendar.MINUTE, this?.horaInicio?.substring(3,5)?.toInteger())
            c.set(Calendar.HOUR_OF_DAY, this?.horaInicio?.substring(0,2)?.toInteger())
            this.inicioExacto = c.getTime()
            c.set(Calendar.MINUTE, this?.horaTermino?.substring(3,5)?.toInteger())
            c.set(Calendar.HOUR_OF_DAY, this?.horaTermino?.substring(0,2)?.toInteger())
            this.terminoExacto = c.getTime()
            codigo = UUID.randomUUID()?.toString()?.replace("-","")?.substring(0,10) + "-${espacioId}"
        }catch(e){}
    }

}

