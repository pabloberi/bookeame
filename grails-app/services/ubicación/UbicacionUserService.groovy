package ubicación

import grails.gorm.services.Service

@Service(UbicacionUser)
interface UbicacionUserService {

    UbicacionUser get(Serializable id)

    List<UbicacionUser> list(Map args)

    Long count()

    void delete(Serializable id)

    UbicacionUser save(UbicacionUser ubicacionUser)

}