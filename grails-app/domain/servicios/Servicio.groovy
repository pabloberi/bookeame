package servicios

import empresa.Empresa
import espacio.Espacio

class Servicio {

    String nombre
    String descripcion
    Integer valor
    Integer duracionAdicional // EN REALIDAD ES EL TIEMPO TOTAL DEL SERVICIO
    Empresa empresa
    Boolean habilitado

    // si es nulo se asume que el servicio es para todos los espacios de la empresa
    static hasMany = [ espacios : Espacio ]

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
        valor nullable: true
        duracionAdicional nullable: true
        empresa nullable: true
        habilitado nullable: true
        espacios nullable: true
    }

    @Override
    String toString() {
        return nombre
    }
}
