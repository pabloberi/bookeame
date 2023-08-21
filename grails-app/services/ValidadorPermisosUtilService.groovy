import auth.User
import configuracionEmpresa.ConfiguracionEmpresa
import empresa.Empresa
import espacio.Espacio
import grails.gorm.transactions.Transactional
import reserva.Modulo
import reserva.Reserva

@Transactional
class ValidadorPermisosUtilService {

    FormatoFechaUtilService formatoFechaUtilService
    def springSecurityService

    // INICIA PERMISOS DE USUARIOS
    Boolean userPuedeCancelarReserva(Reserva reserva, ConfiguracionEmpresa configuracion){
        boolean permiso = false
        if( reserva && configuracion ){
            // VALIDA SI ES POSPAGO, SI TIENE PERMISO PARA CANCELAR Y SI ESTA DENTRO DEL PLAZO
            if( reserva?.tipoReserva?.id != 2 && configuracion?.permitirCancelar
                    && cumpleConPeriodoAnticpacion(reserva?.inicioExacto, configuracion?.periodoCambioReserva ) ){
                permiso = true
            }
        }
        return permiso
    }

    Boolean userPuedeReagendarReserva(Reserva reserva, ConfiguracionEmpresa configuracion){
        boolean permiso = false
        if( reserva && configuracion ){
            if( esRoleAdmin() ){ return true }
            // VALIDA SI TIENE PERMISO PARA CANCELAR Y SI ESTA DENTRO DEL PLAZO
            if( configuracion?.permitirReagendar && cumpleConPeriodoAnticpacion(reserva?.inicioExacto, configuracion?.periodoCambioReserva ) ){
                permiso = true
            }
        }
        return permiso
    }

    Boolean cumpleConPeriodoAnticpacion(Date fechaInicioReserva, Integer horas){
        boolean permiso = false
        def hoy = new Date()
        try{
            Calendar c = Calendar.getInstance()
            Calendar d = Calendar.getInstance()
            c.setTime(hoy)
            d.setTime(fechaInicioReserva)
            def dif = d.getTimeInMillis() - c.getTimeInMillis()
            if( formatoFechaUtilService.convertMilisegundosToHoras(dif) > horas ){
                permiso = true
            }
        }catch(e){
            return false
        }
        return permiso
    }
    // FIN PERMISOS DE USUARIOS

    Boolean esRoleUser(){
        User user = springSecurityService.getCurrentUser()
        return user.authorities.findAll().find { it -> it.authority == "ROLE_USER" }
    }

    Boolean esRoleAdmin(){
        User user = springSecurityService.getCurrentUser()
        return user.authorities.findAll().find { it -> it.authority == "ROLE_ADMIN" }
    }

    // INICIA VALIDACION DE RELACIONES
    Boolean validarRelacionReservaUser(Long reservaId){
        Reserva reserva = Reserva.findById(reservaId)
        User user = springSecurityService.getCurrentUser()

        if( reserva && user ){
            if( reserva?.espacio?.empresa?.usuario == user || reserva?.usuario == user ){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }

    Boolean validarRelacionEmpresaUser(Long empresaId){
        User user = springSecurityService.getCurrentUser()
        return Empresa.findByUsuario(user).id == empresaId
    }

    Boolean validarRelacionEspacioModulo(Modulo modulo, Espacio espacio){
        if( modulo && espacio){
            if( modulo?.espacio?.id == espacio?.id ){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }

    Boolean validarRelacionModuloFecha(Modulo modulo, Date fecha){
        try{
            Calendar c = Calendar.getInstance()
            c.setTime(fecha)
            String nombreDia = formatoFechaUtilService.obtenerNombreDia(c.get(Calendar.DAY_OF_WEEK))
            if( modulo.dias.getProperty(nombreDia) ){
                return true
            }else{
                return false
            }
        }catch(e){ return false }
    }

    Boolean validarRelacionEspacioUser(Long espacioId){
        Espacio espacio = Espacio.findById(espacioId)
        User user = springSecurityService.getCurrentUser()

        if( espacio && user ){
            Empresa empresa = Empresa.findByUsuario(user)
            if( empresa?.id == espacio?.empresaId ){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    // FIN VALIDACION DE RELACIONES


}
