package empresa

import grails.gorm.services.Service

@Service(CambioDatos)
interface CambioDatosService {

    CambioDatos get(Serializable id)

    List<CambioDatos> list(Map args)

    Long count()

    void delete(Serializable id)

    CambioDatos save(CambioDatos cambioDatos)

}