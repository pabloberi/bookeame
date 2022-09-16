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
    }

}


