package flow

import empresa.Empresa
import grails.util.Holders
import gestion.EncryptionUtilsService
import org.springframework.web.server.adapter.WebHttpHandlerBuilder

class FlowEmpresa {

    String apiKey
    String secretKey
    Comision comision
    Empresa empresa

    static constraints = {
        empresa nullable: true, unique: true
        apiKey nullable: true
        secretKey nullable: true
        comision nullable: true
    }

    def encryptionUtilsService

    String getApiKey(){
        if(encryptionUtilsService == null) {
            encryptionUtilsService = Holders.grailsApplication.mainContext.getBean("encryptionUtilsService")
        }
        return encryptionUtilsService.decrypt(this.apiKey)
    }

    String getSecretKey(){
        if(encryptionUtilsService == null){
            encryptionUtilsService = Holders.grailsApplication.mainContext.getBean("encryptionUtilsService")
        }
        return encryptionUtilsService.decrypt(this.secretKey)
    }

}
