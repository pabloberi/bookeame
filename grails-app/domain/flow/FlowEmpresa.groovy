package flow

import empresa.Empresa

class FlowEmpresa {

    String apiKey
    String secretKey
    Comision comision
    Empresa empresa

    static constraints = {
        empresa nullable: true, unique: true
        apiKey nullable: true
        secretKey nullable: true
        comision nullable: true
    }
}
