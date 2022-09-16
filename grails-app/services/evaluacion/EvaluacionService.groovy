package evaluacion

import grails.gorm.services.Service

@Service(Evaluacion)
interface EvaluacionService {

    Evaluacion get(Serializable id)

    List<Evaluacion> list(Map args)

    Long count()

    void delete(Serializable id)

    Evaluacion save(Evaluacion evaluacion)

}