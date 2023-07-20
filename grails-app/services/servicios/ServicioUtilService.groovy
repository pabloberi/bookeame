package servicios

import empresa.Empresa
import grails.gorm.transactions.Transactional
import reserva.Reserva

@Transactional
class ServicioUtilService {

    def ServicioReservaService servicioReservaService

    def getServiciosEmpresa(Long id) {
        List<Servicio> servicioList = new ArrayList<>()
        servicioList = Servicio.findAllByEmpresaAndHabilitado(Empresa.get(id),true)
        return servicioList
    }

    void guardarServicioEnReserva(Long servicioId, Long reservaId){
        try{
            Servicio servicio = Servicio.get(servicioId)
            Reserva reserva = Reserva.get(reservaId)

            ServicioReserva servicioReserva = new ServicioReserva()
            servicioReserva.servicio = servicio
            servicioReserva.reserva = reserva
            servicioReserva.valor = servicio?.valor

            servicioReservaService.save(servicioReserva)
        }catch(e){}
    }

    def getServiciosPorReserva(Long reservaId){
        List<ServicioReserva> servicioReservaList = new ArrayList<>()
        servicioReservaList = ServicioReserva.findAllByReserva(Reserva.get(reservaId))
        return servicioReservaList
    }
}
