package auth

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import grails.compiler.GrailsCompileStatic

@GrailsCompileStatic
@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

    private static final long serialVersionUID = 1

    String username
    String password

    String nombre  // cuando es admin este dato esta asociado al representante legal
    String apellidoPaterno // cuando es admin este dato esta asociado al representante legal
    String apellidoMaterno // cuando es admin este dato esta asociado al representante legal
    String email
//    String direccion
    String celular
    Date fechaNac // cuando es admin este dato esta asociado al representante legal
    String rut
    String dv

    String rutRepresentante // cuando es admin este dato esta asociado al representante legal
    String dvRepresentante // cuando es admin este dato esta asociado al representante legal

    String extension
//    TipoCuenta tipoCuenta
    float indiceConfianza = 0
    String foto

    Integer indiceAcumulado = 0
    Integer indiceContador = 0

    String tokenFirebase
    String tokenPassword

    boolean enabled = true
    boolean accountExpired
    boolean accountLocked
    boolean passwordExpired
    boolean invitado = false
    String provider

    static hasMany = [oAuthIDs: OAuthID]

    Set<Role> getAuthorities() {
        (UserRole.findAllByUser(this) as List<UserRole>)*.role as Set<Role>
    }

    static constraints = {
        password nullable: false, blank: false, password: true
        username nullable: false, blank: false, unique: true
        indiceConfianza nullable: true
        foto blank: true, nullable: true
        nombre nullable: true
        apellidoMaterno nullable: true
        apellidoPaterno nullable: true
        email nullable: true, unique: true
//        direccion nullable: true
        celular nullable: true
        fechaNac nullable: true
        rut nullable: true, unique: true
        dv nullable: true
        extension nullable: true
//        tipoCuenta nullable: true
        indiceAcumulado nullable: true
        indiceContador nullable: true
        tokenFirebase nullable: true
        rutRepresentante nullable: true
        dvRepresentante nullable: true
        invitado nullable: true
        tokenPassword nullable: true
        oAuthIDs nullable: true
        provider nullable: true
    }

    static mapping = {
	    password column: '`password`'
    }

    @Override
    String toString() {
        return username
    }

    def beforeInsert(){
        try{
            email = email?.toLowerCase()
            username = username?.toLowerCase()
        }catch(e){}
    }

    def getNombreCompleto(){
        return nombre ?: "" + " " + apellidoPaterno ?: ""  + " " + apellidoMaterno ?: ""
    }

}
