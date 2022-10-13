package ubicacion

import auth.User
import ubicacion.Comuna
import ubicacion.Region

class UbicacionUser {

    //float latitud
    //float longitud
    User usuario
    Boolean enUso = false
    String direccion
    Region region
    Comuna comuna



    static constraints = {
        //latitud nullable: true
        //longitud nullable: true
        usuario nullable: true
        direccion nullable: true
        region nullable: true
        comuna nullable: true

    }
}
