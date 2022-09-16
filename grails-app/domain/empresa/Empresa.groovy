package empresa

import auth.User

class Empresa {

    String giro
    String razonSocial
    String rut
    String dv
    String direccion
    String email
    Boolean enabled = true
    Boolean excentoPago = false
    User usuario

    Date dateCreated
    Date lastUpdated

    static constraints = {
        usuario nullable: true
        giro nullable: true
        razonSocial nullable: true
        rut nullable: true, unique: true
        dv nullable: true
        direccion nullable: true
        email nullable: true, unique: true
        excentoPago nullable: true
    }

    @Override
    String toString() {
        return razonSocial
    }
}
