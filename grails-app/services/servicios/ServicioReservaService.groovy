package servicios

import grails.gorm.services.Service

@Service(ServicioReserva)
interface ServicioReservaService {

    ServicioReserva get(Serializable id)

    List<ServicioReserva> list(Map args)

    Long count()

    void delete(Serializable id)

    ServicioReserva save(ServicioReserva servicioReserva)

}