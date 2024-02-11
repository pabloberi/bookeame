package servicios

import reserva.Reserva
import reserva.ReservaTemp

class ServicioReserva {

    Servicio servicio
    Integer   valor
    static belongsTo = [reserva : Reserva, reservaTemp: ReservaTemp]

    static constraints = {
        servicio nullable: true
        reserva nullable: true
        valor nullable: true
        reservaTemp nullable: true
    }
}
