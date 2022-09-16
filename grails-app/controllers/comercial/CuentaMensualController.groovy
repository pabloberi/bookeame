package comercial

import empresa.Empresa
import espacio.Espacio
import gestion.General
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import reserva.Reserva

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_SUPERUSER'])
class CuentaMensualController {

    CuentaMensualService cuentaMensualService
    def utilService

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond cuentaMensualService.list(params), model:[cuentaMensualCount: cuentaMensualService.count()]
    }

    def show(Long id) {
        respond cuentaMensualService.get(id)
    }

    def create() {
        respond new CuentaMensual(params)
    }

    def save(CuentaMensual cuentaMensual) {
        if (cuentaMensual == null) {
            notFound()
            return
        }

        try {
            cuentaMensualService.save(cuentaMensual)
        } catch (ValidationException e) {
            respond cuentaMensual.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cuentaMensual.label', default: 'CuentaMensual'), cuentaMensual.id])
                redirect cuentaMensual
            }
            '*' { respond cuentaMensual, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond cuentaMensualService.get(id)
    }

    def update(CuentaMensual cuentaMensual) {
        if (cuentaMensual == null) {
            notFound()
            return
        }

        try {
            cuentaMensualService.save(cuentaMensual)
        } catch (ValidationException e) {
            respond cuentaMensual.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'cuentaMensual.label', default: 'CuentaMensual'), cuentaMensual.id])
                redirect cuentaMensual
            }
            '*'{ respond cuentaMensual, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        cuentaMensualService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'cuentaMensual.label', default: 'CuentaMensual'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'cuentaMensual.label', default: 'CuentaMensual'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    def generarEstadosCuenta(){
        List<Empresa> empresaList = Empresa.findAllByEnabledAndExcentoPago(true, false)
        List<Reserva> reservaList = []
        List<Reserva> indiceList = []

        Calendar c = Calendar.getInstance()

        c.setTime(new Date())
        c.set(Calendar.DAY_OF_MONTH, 15)
        c.set(Calendar.HOUR_OF_DAY, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.SECOND, 0)

        Date thisMonth = c.getTime()
        c.add(Calendar.MONTH, -1)
        Date oneMonthAgo = c.getTime()

        for( emp in empresaList ){
            reservaList = Reserva.createCriteria().list {
                and{
                    espacio{
                        empresa{
                            eq('id', emp?.id)
                        }
                    }
                    estadoReserva{
                        eq('id', 2l)
                    }
                    between('fechaReserva', oneMonthAgo, thisMonth )
                }
            }

            indiceList = Reserva.createCriteria().list {
                and{
                    espacio{
                        empresa{
                            eq('id', emp?.id)
                        }
                    }
                    estadoReserva{
                        ne('id', 2l)
                    }
                    between('fechaReserva', oneMonthAgo, thisMonth )
                }
            }
            String codigo = crearCuentaMensual(reservaList, emp)
            def total = indiceList?.size() + reservaList?.size()
            def efectivo =  utilService.indiceEfectividad( total, reservaList?.size() )
            def pasivo =  + utilService.indiceEfectividad( total, indiceList?.size() )
            println("ESTADO de CUENTA: "+ codigo + " GENERADA... INDICE EFECTIVIDAD: ${efectivo} % ... INDICE PASIVOS: ${pasivo} %")
        }

        redirect(controller: 'CuentaMensual', action: 'create')
    }

    String crearCuentaMensual(def reservaList, Empresa empresa){
        CuentaMensual cuentaMensual = new CuentaMensual()
        String codigo
        Calendar c = Calendar.getInstance()

        c.setTime(new Date())
        c.set(Calendar.DAY_OF_MONTH, 5)
        c.set(Calendar.HOUR_OF_DAY, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.MILLISECOND, 0)

        c.add(Calendar.MONTH, 1)
        Date fechaVencimiento = c.getTime()

        try {
            Integer total = reservaList?.size() * General.findByNombre('valorUnitarioTrx')?.valor?.toInteger()
            def iva = total * 0.19
            codigo = utilService.codigoEstadoCuenta(empresa?.id) ?: "ERROR-${empresa?.id}"
            cuentaMensual.codigo = codigo
            cuentaMensual.empresa = empresa
            cuentaMensual.fechaVencimiento = fechaVencimiento
            cuentaMensual.pagado = false
            cuentaMensual.estadoCuentaMensual = EstadoCuentaMensual.get(1)
            cuentaMensual.total = total
            cuentaMensual.iva = iva?.toInteger()
            cuentaMensual.neto = total - iva?.toInteger()

            cuentaMensualService.save(cuentaMensual)

        }catch(e){
            codigo = "ERROR-${empresa?.id}"
        }
        return codigo
    }

    def atrasados(){
        List<CuentaMensual> cuentaMensualList = []
        try{
            cuentaMensualList = CuentaMensual.createCriteria().list {
                and{
                    eq('pagado', false)
                    le('fechaVencimiento', new Date() )
                }
            }
        }catch(e){}
        respond cuentaMensualList
    }

    def busquedaGeneralCuentas(){
        List<CuentaMensual> cuentaMensualList = []
        try{

            cuentaMensualList = CuentaMensual.createCriteria().list {
                and{
                    eq('fechaVencimiento', sdf.parse(params?.fechaVencimiento) )
                }
            }
        }catch(e){
            render 'Error'
        }
        render template: 'tablaCuentas', model:[ cuentaMensualList: cuentaMensualList ]
    }

    def busquedaCuentaEmpresa(){
        List<CuentaMensual> cuentaMensualList = []
        try{

            cuentaMensualList = CuentaMensual.createCriteria().list {
                and{
                    between('fechaVencimiento', sdf.parse(params?.desde), sdf.parse(params?.hasta) )
                    empresa{
                        eq('id', params?.empresaId?.toLong() )
                    }
                }
            }
        }catch(e){
            render 'Error'
        }
        render template: 'tablaCuentas', model:[ cuentaMensualList: cuentaMensualList ]
    }

}
