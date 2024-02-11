package espacio

import auth.User
import empresa.Empresa
import grails.gorm.transactions.Transactional

@Transactional
class EspacioUtilService {

    def getEspaciosByUser(User user) {

        List<Espacio> espacioList = new ArrayList<>()
        try{
            Empresa empresa = Empresa.findByUsuario(user)
            espacioList = Espacio.findAllByEmpresa(empresa)
            return espacioList
        }catch(Exception e){
            return espacioList
        }

    }
}
