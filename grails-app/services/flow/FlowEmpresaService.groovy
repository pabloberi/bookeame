package flow

import grails.gorm.services.Service

@Service(FlowEmpresa)
interface FlowEmpresaService {

    FlowEmpresa get(Serializable id)

    List<FlowEmpresa> list(Map args)

    Long count()

    void delete(Serializable id)

    FlowEmpresa save(FlowEmpresa flowEmpresa)

}