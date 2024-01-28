package traza

class TrazabilidadPrepago {

    String token
    Long espacioId
    Long usuarioId
    String fechaTrx
    String fechaReserva
    String horaInicio
    String horaTermino
    String valor
    Long reservaTempId

    String codigo
    String mensaje

    static constraints = {
        token nullable: true
        espacioId nullable: true
        usuarioId nullable: true
        fechaTrx nullable: true
        fechaReserva nullable: true
        horaInicio nullable: true
        horaTermino nullable: true
        valor nullable: true
        reservaTempId nullable: true
        codigo nullable: true
        mensaje nullable: true
    }
}
