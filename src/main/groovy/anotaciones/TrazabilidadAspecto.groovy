package anotaciones

import dto.CrearReservaRs
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.SpringSecurityService
import grails.util.Holders
import org.aspectj.lang.ProceedingJoinPoint
import org.aspectj.lang.annotation.Around
import org.aspectj.lang.annotation.Aspect
import org.springframework.transaction.support.TransactionTemplate
import org.springframework.web.context.request.RequestContextHolder
import reserva.ReservaUtilService
import traza.TrazabilidadPrepago
import traza.TrazabilidadPrepagoService

import javax.servlet.http.HttpServletRequest


@Aspect
class TrazabilidadAspecto {

    def springSecurityService

    @Around("execution(* reserva.ReservaUtilService.crearReserva(..))")
    def interceptCrearReserva(ProceedingJoinPoint joinPoint) throws Throwable {
        // Lógica antes de la ejecución del método
        println("Interceptando Flujo CrearRerserva ...")
        def args = joinPoint?.args[0]
        def result = joinPoint.proceed()

        if( args.tipoReservaId == "2" ){
            trazarCreacionUrl(
                    setTrazaPrepago(args),
                    result
            )
        }
        // Lógica después de la ejecución del método
        return result
    }

    @Around("execution(* reserva.ReservaController.confirmFlow(..))")
    def interceptConfirmFlow(ProceedingJoinPoint joinPoint) throws Throwable {
        println("Interceptando Flujo ConfirmFlow ...")
        def request = RequestContextHolder.currentRequestAttributes()?.getRequest() as HttpServletRequest
        def params = request?.getParameterMap()
        String token = params?.token[0]
        def result = joinPoint.proceed()
        trazarConfirmFlow(token, result)
        return result
    }

    TrazabilidadPrepago setTrazaPrepago(def args){
        try{
            TrazabilidadPrepago trazaPrepago = new TrazabilidadPrepago()
            trazaPrepago.espacioId = args?.espacioId?.toLong() ?: null

            if( springSecurityService == null ){
                springSecurityService = Holders.applicationContext.getBean("springSecurityService")
            }
            trazaPrepago.usuarioId = springSecurityService?.getCurrentUser()?.id ?: null

            trazaPrepago.fechaTrx = new Date()
            trazaPrepago.fechaReserva = args?.fechaReserva ?: null
            trazaPrepago.horaInicio = args?.horaInicio
            trazaPrepago.horaTermino = args?.horaTermino
            trazaPrepago.valor = args?.valor?.toString()
            if( args?.servicio != null && args?.servicio != "" ){
                trazaPrepago.servicioId = args?.servicio?.toLong()
            }
            return trazaPrepago
        }catch(Exception e){
            return null
        }
    }

    def trazabilidadPrepagoService

    @Transactional
    void trazarCreacionUrl(TrazabilidadPrepago trx, def result){
        try{
            if (result instanceof CrearReservaRs) {
                trx.token = "desde el result"
                trx.codigo = result?.codigo
                trx.mensaje = result?.mensaje
                trx.reservaTempId = result?.reservaId
                if( trx?.codigo == "0" ){
                    trx.token = obtenerValorToken(trx?.mensaje)
                }
            }
            if(trazabilidadPrepagoService == null ){
                trazabilidadPrepagoService = Holders.applicationContext.getBean("trazabilidadPrepagoService")
            }
            trazabilidadPrepagoService.save(trx)

        }catch(Exception e){
           println("Error al trazarCreacionUrl reserva prepago " + e.getMessage() )
        }
    }

    @Transactional
    void trazarConfirmFlow(String token, def result){
        try{
            TrazabilidadPrepago trx = new TrazabilidadPrepago()
            trx.token = token
            trx.mensaje = result?.toString()
            trx.fechaTrx = new Date()
            if(trazabilidadPrepagoService == null ){
                trazabilidadPrepagoService = Holders.applicationContext.getBean("trazabilidadPrepagoService")
            }
            trazabilidadPrepagoService.save(trx)
        }catch(Exception e){
            println("Error al trazarConfirmFlow reserva prepago " + e.getMessage() )
        }
    }


    def obtenerValorToken(String cadena) {
        // Definir una expresión regular para encontrar el valor del token
        def patron = /(?:\?|&)token=([^&]+)/
        // Encontrar el valor del token en la cadena
        def matcher = (cadena =~ patron)
        // Verificar si se encontró el token y devolver su valor
        if (matcher.find()) {
            return matcher.group(1)
        } else {
            return null
        }
    }
}
