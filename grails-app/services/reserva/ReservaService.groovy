package reserva

import grails.gorm.services.Service

@Service(Reserva)
interface ReservaService {

    Reserva get(Serializable id)

    List<Reserva> list(Map args)

    Long count()

    void delete(Serializable id)

    Reserva save(Reserva reserva)

}