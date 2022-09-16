package reserva

import grails.gorm.services.Service

@Service(ReservaPlanificada)
interface ReservaPlanificadaService {

    ReservaPlanificada get(Serializable id)

    List<ReservaPlanificada> list(Map args)

    Long count()

    void delete(Serializable id)

    ReservaPlanificada save(ReservaPlanificada reservaPlanificada)

}