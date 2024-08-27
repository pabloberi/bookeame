package reserva

import grails.gorm.services.Service

@Service(RegistroPagoReserva)
interface RegistroPagoReservaService {

    RegistroPagoReserva get(Serializable id)

    List<RegistroPagoReserva> list(Map args)

    Long count()

    void delete(Serializable id)

    RegistroPagoReserva save(RegistroPagoReserva registroPagoReserva)

}