package feriados

import grails.gorm.services.Service

@Service(Feriado)
interface FeriadosService {

    Feriado get(Serializable id)

    List<Feriado> list(Map args)

    Long count()

    void delete(Serializable id)

    Feriado save(Feriado feriados)

}
