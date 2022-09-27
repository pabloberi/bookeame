package configuracionEmpresa

import empresa.Empresa

class ConfiguracionEmpresa {

    Empresa     empresa
    Integer     diasAMostrar = 7
    TipoPago    tipoPago
    String      fono

    Boolean     permitirCancelar
    Boolean     permitirReagendar
    Integer     periodoCambioReserva // periodo maximo para cancelar o reagendar en horas

    static constraints = {
        empresa                 nullable: true, unique: true
        diasAMostrar            nullable: true
        tipoPago                nullable: true
        fono                    nullable: true
        permitirCancelar        nullable: true
        permitirReagendar       nullable: true
        periodoCambioReserva    nullable: true
    }
}
