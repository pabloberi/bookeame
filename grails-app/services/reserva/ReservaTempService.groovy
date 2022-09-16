package reserva

import grails.gorm.services.Service

@Service(ReservaTemp)
interface ReservaTempService {

    ReservaTemp get(Serializable id)

    List<ReservaTemp> list(Map args)

    Long count()

    void delete(Serializable id)

    ReservaTemp save(ReservaTemp reservaTemp)

}