package configuracionEmpresa

import empresa.Empresa

class ConfiguracionEmpresa {

    Empresa empresa
    Integer diasAMostrar = 7
    TipoPago tipoPago
    String fono

    static constraints = {
        empresa nullable: true, unique: true
        diasAMostrar nullable: true
        tipoPago nullable: true
        fono nullable: true
    }
}
