package reserva

import auth.User
import empresa.Empresa
import espacio.Espacio

class ReservaPeriodica {

    Dia dias
    User usuario
    String horaInicio
    String horaTermino
    Integer valorPorReserva

    Date fechaInicio
    Date fechaTermino

    Espacio espacio
    Empresa empresa

    static hasMany = [reservas: Reserva]

    static constraints = {
        dias nullable: true
        usuario nullable: true
        horaInicio nullable: true
        horaTermino nullable: true
        espacio nullable: true
//        reservas nullable: true
        fechaTermino nullable: true
        fechaInicio nullable: true
        valorPorReserva nullable: true
    }

}
