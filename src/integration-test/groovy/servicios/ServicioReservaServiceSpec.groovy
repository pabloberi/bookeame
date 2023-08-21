package servicios

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class ServicioReservaServiceSpec extends Specification {

    ServicioReservaService servicioReservaService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new ServicioReserva(...).save(flush: true, failOnError: true)
        //new ServicioReserva(...).save(flush: true, failOnError: true)
        //ServicioReserva servicioReserva = new ServicioReserva(...).save(flush: true, failOnError: true)
        //new ServicioReserva(...).save(flush: true, failOnError: true)
        //new ServicioReserva(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //servicioReserva.id
    }

    void "test get"() {
        setupData()

        expect:
        servicioReservaService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<ServicioReserva> servicioReservaList = servicioReservaService.list(max: 2, offset: 2)

        then:
        servicioReservaList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        servicioReservaService.count() == 5
    }

    void "test delete"() {
        Long servicioReservaId = setupData()

        expect:
        servicioReservaService.count() == 5

        when:
        servicioReservaService.delete(servicioReservaId)
        sessionFactory.currentSession.flush()

        then:
        servicioReservaService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        ServicioReserva servicioReserva = new ServicioReserva()
        servicioReservaService.save(servicioReserva)

        then:
        servicioReserva.id != null
    }
}
