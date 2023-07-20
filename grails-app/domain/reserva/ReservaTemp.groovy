package reserva

import auth.User
import espacio.Espacio
import evaluacion.Evaluacion

class ReservaTemp {

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
    Date inicioExacto
    Date terminoExacto

    Date dateCreated

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
        inicioExacto nullable: true
        terminoExacto nullable: true
    }

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
        }catch(e){}
    }
}


