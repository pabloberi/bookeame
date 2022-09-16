package espacio

import reserva.Modulo
import grails.gorm.services.Service

@Service(Modulo)
interface ModuloService {

    Modulo get(Serializable id)

    List<Modulo> list(Map args)

    Long count()

    void delete(Serializable id)

    Modulo save(Modulo modulo)

}