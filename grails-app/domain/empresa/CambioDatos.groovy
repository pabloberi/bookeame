package empresa

class CambioDatos {
    //DATOS EMPRESA
    String giro
    String razonSocial
    String rut
    String dv
    String direccion

    //DATOS REPRESENTANTE LEGAL
    String nombre
    String apellidoPaterno
    String apellidoMaterno
    String celular
    Date fechaNac
    String rutUser
    String dvUser

    //RELACION EMPRESA
    Empresa empresa
    Date dateCreated
    Date lastUpdated

    static constraints = {
        giro nullable: true
        razonSocial nullable: true
        rut nullable: true, unique: true
        dv nullable: true
        direccion nullable: true
        nombre nullable: true
        apellidoPaterno nullable: true
        apellidoMaterno nullable: true
        celular nullable: true
        fechaNac nullable: true
        rutUser nullable: true, unique: true
        dvUser nullable: true
        empresa nullable: true
    }
}
