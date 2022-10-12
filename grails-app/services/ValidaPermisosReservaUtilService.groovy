

import grails.gorm.transactions.Transactional
import reserva.Reserva

@Transactional
class ValidaPermisosReservaUtilService {

    Boolean esReservaVigente(Reserva reserva){
        Boolean permiso = false
        if( reserva?.terminoExacto >= new Date() ){
            permiso = true
        }
        return permiso
    }

    Boolean esReservaHistorica(Reserva reserva){
        Boolean permiso = false
        if( reserva?.terminoExacto < new Date() && reserva?.estadoReserva?.id == 2  ){
            permiso = true
        }
        return permiso
    }

    Boolean esReservaPosPagoPendiente(Reserva reserva){
        Boolean permiso = false
        if( reserva?.estadoReserva?.id == 1 && reserva?.tipoReserva?.id == 1 ){
            permiso = true
        }
        return permiso
    }
}
