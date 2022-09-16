package configuracionEmpresa

class TipoPago {

    Boolean manual = true
    Boolean prepago = false
    Boolean pospago = false

    static constraints = {
        manual nullable: true
        prepago nullable: true
        pospago nullable: true
    }
}
