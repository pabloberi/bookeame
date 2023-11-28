package reserva

class ReservaPeriodicaReserva {

    Reserva             reserva
    ReservaPeriodica    reservaPeriodica

    static constraints = {
        reservaPeriodica nullable: false
        reserva unique: ['reservaPeriodica']
    }
}
