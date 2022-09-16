package reserva

class TipoReserva {

    String nombre
    String descripcion

    Date dateCreated
    Date lastUpdated

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
    }

    @Override
    String toString() {
        return nombre
    }
}
