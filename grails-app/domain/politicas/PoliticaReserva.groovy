package politicas

import empresa.Empresa
import espacio.Espacio
import servicios.Servicio

class PoliticaReserva {

    String descripcion
    Empresa empresa

//    Boolean todosLosEspacios
//    Boolean todosLosServicios

//    static hasMany = [espacios: Espacio, servicios: Servicio]

    static constraints = {
        descripcion nullable: true
        empresa nullable: true
//        espacios nullable: true
//        servicios nullable: true
//        todosLosEspacios nullable: true
//        todosLosServicios nullable: true
    }

}
