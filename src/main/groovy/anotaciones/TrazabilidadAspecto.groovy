package anotaciones

import dto.CrearReservaRs
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.SpringSecurityService
import grails.util.Holders
import org.aspectj.lang.ProceedingJoinPoint
import org.aspectj.lang.annotation.Around
import org.aspectj.lang.annotation.Aspect
import org.springframework.transaction.support.TransactionTemplate
import reserva.ReservaUtilService
import traza.TrazabilidadPrepago
import traza.TrazabilidadPrepagoService


@Aspect
class TrazabilidadAspecto {


    @Around("execution(* reserva.ReservaUtilService.crearReserva(..))")
    def interceptCrearReserva(ProceedingJoinPoint joinPoint) throws Throwable {
        // Lógica antes de la ejecución del método
        println("Interceptando Flujo CrearRerserva ...")
        def args = joinPoint?.args[0]
        def result = joinPoint.proceed()

        if( args.tipoReservaId == "2" ){
            trazarTransaccion(
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
        String args = joinPoint?.args
        def result = joinPoint.proceed()
        return result
    }

    TrazabilidadPrepago setTrazaPrepago(def args){
        try{
            TrazabilidadPrepago trazaPrepago = new TrazabilidadPrepago()
            trazaPrepago.espacioId = args?.espacioId?.toLong() ?: null
//            trazaPrepago.usuarioId = new SpringSecurityService()?.getCurrentUser()?.id ?: null
            trazaPrepago.fechaTrx = new Date().toString()
            trazaPrepago.fechaReserva = args?.fechaReserva ?: null
            trazaPrepago.horaInicio = args?.horaInicio
            trazaPrepago.horaTermino = args?.horaTermino
            trazaPrepago.valor = args?.valor?.toString()
            return trazaPrepago
        }catch(Exception e){
            return null
        }
    }

    def trazabilidadPrepagoService

    @Transactional
    void trazarTransaccion(TrazabilidadPrepago trx, def result){
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

            TrazabilidadPrepago.withNewTransaction {
                if(trazabilidadPrepagoService == null ){
                    trazabilidadPrepagoService = Holders.applicationContext.getBean("trazabilidadPrepagoService")
                }
                trazabilidadPrepagoService.save(trx)
            }


        }catch(Exception e){
           println("Error al trazar reserva prepago " + e.getMessage() )
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
