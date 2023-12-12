package reserva

import grails.gorm.services.Service

@Service(ReservaPeriodica)
interface ReservaPlanificadaService {

    ReservaPeriodica get(Serializable id)

    List<ReservaPeriodica> list(Map args)

    Long count()

    void delete(Serializable id)

    ReservaPeriodica save(ReservaPeriodica reservaPlanificada)

}
