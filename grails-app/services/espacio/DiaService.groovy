package espacio

import reserva.Dia
import grails.gorm.services.Service

@Service(Dia)
interface DiaService {

    Dia get(Serializable id)

    List<Dia> list(Map args)

    Long count()

    void delete(Serializable id)

    Dia save(Dia dia)

}