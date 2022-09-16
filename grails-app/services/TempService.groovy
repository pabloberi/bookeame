
import gestion.ReservaTempJobService
import groovy.time.TimeCategory
import groovy.transform.CompileDynamic
import groovy.transform.CompileStatic
import groovy.util.logging.Slf4j
import org.quartz.JobDataMap
import org.quartz.JobDetail
import org.quartz.JobKey
import org.quartz.Trigger
import org.quartz.TriggerBuilder

import java.text.SimpleDateFormat

/**
 * UserService
 * A service class encapsulates the core business logic of a Grails application
 */


@Slf4j
//@CompileStatic
class TempService {
//    ReservaTempService reservaTempService
//    def flowService
//    def springSecurityService = Holders.applicationContext.getBean('springSecurityService')
    def quartzService

    @CompileDynamic
    Date startAtDate( Integer min ) {
        Date startAt = new Date()
        use(TimeCategory) {
            if( min == 15 ){
                startAt = startAt + 15.minute
            }else if ( min == 4 ){
                startAt = startAt + 4.minute
            }
        }
        startAt
    }

    void triggerReservaTemp(Long id, int min){
        JobDataMap jobDataMap = new JobDataMap()
        jobDataMap.put('id', id)
        Trigger trigger = TriggerBuilder.newTrigger()
                .forJob( JobKey.jobKey(ReservaTempJobService.simpleName) )
                .startAt( startAtDate(min) )
                .usingJobData(jobDataMap)
                .build()
        quartzService.scheduleTrigger(trigger)
    }

}
