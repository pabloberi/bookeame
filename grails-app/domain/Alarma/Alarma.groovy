package Alarma

import auth.User
import espacio.Espacio

class Alarma {

    User        usuario
    Date        horario
    Long        reservaId
    Espacio     espacio

    static constraints = {
        usuario nullable: true
        horario nullable: true
        reservaId nullable: true
        espacio nullable: true
    }

}
