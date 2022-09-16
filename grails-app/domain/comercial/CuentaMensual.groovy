package comercial

import empresa.Empresa

class CuentaMensual {

    String codigo
    Empresa empresa

    Date fechaVencimiento
    Date fechaPago
    Boolean pagado = false

    EstadoCuentaMensual estadoCuentaMensual

    Integer neto
    Integer iva
    Integer total

    Date dateCreated

    static constraints = {
        codigo nullable: true, unique: true
        empresa nullable: true
        fechaVencimiento nullable: true
        fechaPago nullable: true
        estadoCuentaMensual nullable: true
        neto nullable: true
        iva nullable: true
        total nullable: true
        pagado nullable: true
    }

    @Override
    String toString() {
        return empresa?.razonSocial
    }
}
