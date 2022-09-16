package configuracionEmpresa

import grails.gorm.services.Service

@Service(ConfiguracionEmpresa)
interface ConfiguracionEmpresaService {

    ConfiguracionEmpresa get(Serializable id)

    List<ConfiguracionEmpresa> list(Map args)

    Long count()

    void delete(Serializable id)

    ConfiguracionEmpresa save(ConfiguracionEmpresa configuracionEmpresa)

}