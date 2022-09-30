package reserva

import auth.User
import configuracionEmpresa.ConfiguracionEmpresa
import grails.gorm.transactions.Transactional

@Transactional
class ReservaUtilService {

    def springSecurityService
    ReservaService reservaService
    def groovyPageRenderer
    def utilService
    def validadorPermisosUtilService

    Boolean eliminarReserva(Long id) {
        Boolean responseEliminar = false
        try{
            User user = springSecurityService.getCurrentUser()
            Reserva reserva = Reserva.get(id)
            String template
            String email

            if( validadorPermisosUtilService?.validarRelacionReservaUser(id) ){
                Reserva reservaTemp = reserva

                if( validadorPermisosUtilService.esRoleAdmin(user) && reserva?.inicioExacto > new Date() ){
                    reservaService.delete(reserva?.id)
                    responseEliminar = true
                    template = groovyPageRenderer.render(template:  "/correos/cancelReservaByAdmin", model: [reserva: reservaTemp])
                    email = reservaTemp?.usuario?.email
                }
                if( validadorPermisosUtilService?.esRoleUser(user)
                        && validadorPermisosUtilService?.userPuedeCancelarReserva(reserva, ConfiguracionEmpresa.findByEmpresa(reserva?.espacio?.empresa)) ){
                    reservaService.delete(reserva?.id)
                    responseEliminar = true
                    template = groovyPageRenderer.render(template:  "/correos/cancelReservaByUser", model: [reserva: reservaTemp])
                    email = reservaTemp?.espacio?.empresa?.usuario?.email
                }
                if( responseEliminar ){
                    utilService.enviarCorreo(email, "noresponder@bookeame.cl", "Reserva Cancelada", template  )
                }
            }
        }catch(e){
            throw new Exception("Ha ocurrido un error")
        }
        return responseEliminar
    }

}
