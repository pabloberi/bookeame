package reporteria

import auth.User
import comercial.PeriodosPlan
import empresa.Empresa
import espacio.Espacio
import grails.gorm.transactions.Transactional
import reserva.Reserva

import java.text.DecimalFormat

@Transactional
class ReporteriaUtilService {

    def ingresoMensual(User user, String tipo, PeriodosPlan periodo, Espacio espacioInstance){
        Empresa empresaInstance = Empresa.findByUsuario(user)

        if( empresaInstance?.id != espacioInstance?.empresa?.id ){
            return null
        }

        List<Reserva> reservaList
        def ingresoTotal = []

        def inicioPeriodo = fechaPasada(periodo)

        Calendar c = Calendar.getInstance()
        c.setTime(inicioPeriodo)
        c.set(Calendar.MILLISECOND, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.HOUR_OF_DAY, 0)

        Calendar d = Calendar.getInstance()
        d.setTime(inicioPeriodo)
        d.set(Calendar.MILLISECOND, 59)
        d.set(Calendar.SECOND, 59)
        d.set(Calendar.MINUTE, 59)
        d.set(Calendar.HOUR_OF_DAY, 23)
        if( espacioInstance && inicioPeriodo ){
            for( int i = 0 ; i <= periodo?.ultimosMeses - 1 ; i++ ){
                int valor = 0
                d.set(Calendar.DAY_OF_MONTH, d.getActualMaximum(Calendar.DAY_OF_MONTH))

                reservaList = Reserva.createCriteria().list {
                    and{
                        espacio{
                            eq('id', espacioInstance?.id)
                        }
                        between('fechaReserva', c.getTime(), d.getTime() )
                        estadoReserva{
                            eq('id', 2l)
                        }
                        if( tipo == 'pospago'){
                            tipoReserva{
                                eq('id', 1l)
                            }
                        }
                        if( tipo == 'online'){
                            tipoReserva{
                                eq('id', 2l)
                            }
                        }
                        if ( tipo == 'manual' ){
                            tipoReserva{
                                eq('id', 3l)
                            }
                        }

                    }
                }

                for( reserva in reservaList){
                    if(reserva?.valor){
                        valor = valor + reserva?.valor
                    }
                }

                ingresoTotal.add([c.getTimeInMillis(), valor ])
                c.add(Calendar.MONTH, 1)
                d.add(Calendar.MONTH, 1)
            }

        }
        return ingresoTotal
    }

    def fechaPasada(PeriodosPlan periodo){
        try{
            Date hoy = new Date()
            Calendar c = Calendar.getInstance()
            c.setTime(hoy)
            c.add(Calendar.MONTH, - periodo?.ultimosMeses)
//            c.set(Calendar.DAY_OF_MONTH, 1)
        return c.getTime()
        }catch(Exception e){
            return null
        }
    }
}
