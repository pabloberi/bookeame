package espacio

import grails.gorm.services.Service

@Service(Espacio)
interface EspacioService {

    Espacio get(Serializable id)

    List<Espacio> list(Map args)

    Long count()

    void delete(Serializable id)

    Espacio save(Espacio espacio)

}