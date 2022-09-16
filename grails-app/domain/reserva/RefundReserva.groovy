package reserva

import espacio.Espacio

class RefundReserva {

    String numeroReembolso
    String numeroOrden
    String monto

    Espacio espacio
    Date inicio
    Date termino
    String token

    Boolean acepta

    static constraints = {
        numeroReembolso nullable: true
        numeroOrden nullable: true
        monto nullable: true
        espacio nullable: true
        inicio nullable: true
        termino nullable: true
        token nullable: true
        acepta nullable: true
    }
}
