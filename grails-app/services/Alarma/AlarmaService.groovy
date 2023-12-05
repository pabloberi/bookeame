package Alarma

import grails.gorm.services.Service

@Service(Alarma)
interface AlarmaService {

    Alarma get(Serializable id)

    List<Alarma> list(Map args)

    Long count()

    void delete(Serializable id)

    Alarma save(Alarma alarma)

}