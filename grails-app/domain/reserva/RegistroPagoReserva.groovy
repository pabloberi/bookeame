package reserva

class RegistroPagoReserva {

    Integer    monto
    String concepto

    Date dateCreated
    Date lastUpdated

    static constraints = {
        monto nullable: false
        concepto nullable: true
    }

}
