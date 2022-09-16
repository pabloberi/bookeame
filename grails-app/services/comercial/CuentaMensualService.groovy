package comercial

import grails.gorm.services.Service

@Service(CuentaMensual)
interface CuentaMensualService {

    CuentaMensual get(Serializable id)

    List<CuentaMensual> list(Map args)

    Long count()

    void delete(Serializable id)

    CuentaMensual save(CuentaMensual cuentaMensual)

}