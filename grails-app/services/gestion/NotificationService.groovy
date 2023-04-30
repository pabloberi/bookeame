package gestion

import auth.User

import grails.gorm.transactions.Transactional
import grails.plugins.rest.client.RestBuilder

@Transactional
class NotificationService {

    def serviceMethod() {}

    def sendPushNotification(Long userId, String tiuloMsj, String cuerpoMsj) {
        User user = User.findById(userId)
        def regid = user?.tokenFirebase

        if (user && regid) {
            def rest = new RestBuilder(connectTimeout: 1000, readTimeout: 20000)
            def resp = rest.post("https://fcm.googleapis.com/fcm/send") {
                header 'Content-Type', 'application/json'
                header 'Authorization', "key=${General.findByNombre('keyFirebase')?.valor}"
                json {
                    notification = {
                        title = tiuloMsj
                        body = cuerpoMsj
                        sound = "default"
                    }
                    data = {
                        titulo = tiuloMsj
                        cuerpo = cuerpoMsj
                    }
                    to = regid
                }
            }
//            println(resp.responseEntity)
        }
    }

}






