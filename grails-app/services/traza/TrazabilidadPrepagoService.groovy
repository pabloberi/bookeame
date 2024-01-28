package traza

import grails.gorm.services.Service

@Service(TrazabilidadPrepago)
interface TrazabilidadPrepagoService {

    TrazabilidadPrepago get(Serializable id)

    List<TrazabilidadPrepago> list(Map args)

    Long count()

    void delete(Serializable id)

    TrazabilidadPrepago save(TrazabilidadPrepago trazabilidadPrepago)

}