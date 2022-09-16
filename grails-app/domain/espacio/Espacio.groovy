package espacio

import empresa.Empresa
import reserva.Modulo
import ubicación.Comuna

class Espacio {

    String nombre
    String descripcion
//    Integer valor
    Integer capacidad
    Empresa empresa
    TipoEspacio tipoEspacio

    float notaUsuarios = 0
    Integer notaAcumulada = 0
    Integer notaContador = 0


    Boolean enabled = true
    String foto
    Integer tiempoArriendo // expresado en minutos
    String extension

    float latitud
    float longitud
    Comuna comuna
    String direccion

    Date dateCreated
    Date lastUpdated

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
//        valor nullable: true
        capacidad nullable: true
        empresa nullable: true
        tipoEspacio nullable: true
        notaUsuarios nullable: true
        enabled nullable: true
        foto nullable: true
        tiempoArriendo nullable:true
        extension nullable: true
        latitud nullable: true
        longitud nullable: true
        notaAcumulada nullable: true
        notaContador nullable: true
        comuna nullable: true
        direccion nullable: true
    }

    @Override
    String toString() {
        return nombre
    }

    boolean getTieneModulos(){
        if( Modulo.findAllByEspacio(this).size() > 0 ){
            return true
        }else{
            return false
        }
    }
}
