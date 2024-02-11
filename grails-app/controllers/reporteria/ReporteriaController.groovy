package reporteria

import auth.User
import comercial.PeriodosPlan
import configuracionEmpresa.ConfiguracionEmpresa
import empresa.Empresa
import espacio.Espacio
import grails.plugin.springsecurity.annotation.Secured
import reserva.Reserva

@Secured('isAuthenticated()')
class ReporteriaController {

    def springSecurityService
    def espacioUtilService
    def reporteriaUtilService

    def home(){
        User user = springSecurityService.getCurrentUser()
        List<Espacio> espacioList = espacioUtilService?.getEspaciosByUser(user)
        List<PeriodosPlan> periodoList = PeriodosPlan.list()
        respond true, model: [
                espacioList: espacioList,
                periodoList: periodoList
        ]
    }

    def graficoIngresos(Long espacioId, Long periodoId){
        def ingresoTotal = []
        def ingresoOnline = []
        def ingresoPospago = []
        def ingresoManual = []
        try{
            PeriodosPlan periodo = PeriodosPlan.get(periodoId)
            Espacio espacio = Espacio.get(espacioId)
            User user = springSecurityService.getCurrentUser()
            ingresoTotal = reporteriaUtilService?.ingresoMensual(user, "", periodo, espacio )
            ingresoOnline = reporteriaUtilService?.ingresoMensual(user, "online", periodo, espacio )
            ingresoPospago = reporteriaUtilService?.ingresoMensual(user, "pospago", periodo, espacio )
            ingresoManual = reporteriaUtilService?.ingresoMensual(user, "manual", periodo, espacio )
            render template: 'ingresoMensual', model: [
                    ingresoTotal: ingresoTotal,
                    ingresoOnline: ingresoOnline,
                    ingresoManual: ingresoManual,
                    ingresoPospago: ingresoPospago,
            ]

        }catch(Exception e){
            println("Error, cargando en cero el grafico")
            render template: 'ingresoMensual', model: [
                    ingresoTotal: ingresoTotal,
                    ingresoOnline: ingresoOnline,
                    ingresoManual: ingresoManual,
                    ingresoPospago: ingresoPospago,
            ]
        }
    }

}
