package gestion

import grails.gorm.services.Service

@Service(General)
interface GeneralService {

    General get(Serializable id)

    List<General> list(Map args)

    Long count()

    void delete(Serializable id)

    General save(General general)

}