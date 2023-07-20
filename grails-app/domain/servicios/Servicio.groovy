package servicios

import empresa.Empresa

class Servicio {

    String nombre
    String descripcion
    Integer valor
//    Integer duracion
    Empresa empresa
    Boolean habilitado

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
        valor nullable: true
//        duracion nullable: true
        empresa nullable: true
        habilitado nullable: true
    }

    @Override
    String toString() {
        return nombre + ' - $ ' + valor + ".-"
    }
}
