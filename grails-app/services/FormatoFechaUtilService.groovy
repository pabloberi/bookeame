

import grails.gorm.transactions.Transactional

import java.text.SimpleDateFormat

@Transactional
class FormatoFechaUtilService {

    Integer convertMilisegundosToHoras(Long mili){
        Integer horas = (((mili/1000)/60)/60).toInteger()
        return horas
    }

    String obtenerNombreDia(Integer id){
        switch(id){
            case 1:
                return "domingo"
            case 2:
                return "lunes"
            case 3:
                return "martes"
            case 4:
                return "miercoles"
            case 5:
                return "jueves"
            case 6:
                return "viernes"
            case 7:
                return "sabado"
        }
    }

    String formatFecha(Date fecha, String patron){
        try{
            SimpleDateFormat sdf = new SimpleDateFormat(patron)
            def aux = sdf.format(fecha)
            return aux
        }catch(e){
            log.error(e)
        }
    }

    Date stringToDateConverter(String fecha, String patron){
        try{
            SimpleDateFormat sdf = new SimpleDateFormat(patron)
            def aux = sdf.parse(fecha)
            return aux
        }catch(e){
            log.error(e)
        }
    }
}
