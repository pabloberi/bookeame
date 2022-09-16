package ubicación

import auth.User

class UbicacionUser {

    float latitud
    float longitud
    User usuario
    Boolean enUso = false
    String direccion

    static constraints = {
        latitud nullable: true
        longitud nullable: true
        usuario nullable: true
        direccion nullable: true
    }
}
