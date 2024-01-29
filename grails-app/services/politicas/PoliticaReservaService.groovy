package politicas

import grails.gorm.services.Service

@Service(PoliticaReserva)
interface PoliticaReservaService {

    PoliticaReserva get(Serializable id)

    List<PoliticaReserva> list(Map args)

    Long count()

    void delete(Serializable id)

    PoliticaReserva save(PoliticaReserva politicaReserva)

}