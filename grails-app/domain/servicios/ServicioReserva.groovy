package servicios

import reserva.Reserva

class ServicioReserva {

    Servicio servicio
    Integer   valor
    static belongsTo = [reserva : Reserva]

    static constraints = {
        servicio nullable: true
        reserva nullable: true
        valor nullable: true
    }
}
