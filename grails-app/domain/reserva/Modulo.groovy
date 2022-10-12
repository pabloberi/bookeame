package reserva

import empresa.Empresa
import espacio.Espacio
import flow.FlowEmpresa

class Modulo {

    Espacio espacio
    String horaInicio
    String horaTermino
    Integer valor
    Dia dias

    static constraints = {
        espacio nullable: true
        horaInicio nullable: true
        horaTermino nullable: true
        dias nullable: true
        valor nullable: true
    }

    def getCostoComision(){
        return costoTransaccion(valor, FlowEmpresa.findByEmpresa(Empresa.get(espacio?.empresaId))?.comision?.valor ?: 3.19 ) - valor ?: 0
    }

    Integer costoTransaccion(Integer precioNeto, def comision ){
        try{
            Integer precioFinal
            Integer diferencial
            def valorComision = 0
            def valorIva = 0
            def total = 0
            if( comision != 0 ){
                valorComision = precioNeto * ((comision/100) + 0.0001)
                valorIva = valorComision * 0.19
                total = precioNeto + valorIva + valorComision
                precioFinal = Math?.round(total)?.toInteger()
                diferencial = diferenciaComision( precioFinal, comision,  valorComision , valorIva )
                return precioFinal + diferencial
            }else{
                total = precioNeto
                precioFinal = Math?.round(total)?.toInteger()
                return precioFinal
            }
        }catch(e){}
    }

    Integer diferenciaComision(Integer total, def comision, def valorComision, def valorIva){
        try{
            def aux = valorComision + valorIva
            def old = Math?.round(aux)?.toInteger()
            def nuevaComision = total * ((comision/100) + 0.00005)
            def nuevoIva = nuevaComision * 0.19
            def totalComisionNueva = Math?.round(nuevaComision + nuevoIva)?.toInteger()
            return totalComisionNueva > old ? totalComisionNueva - old : 0
        }catch(e){}
    }

    String getHorarioModulo(){
        return horaInicio + " a " + horaTermino
    }
}
