package reserva

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class RegistroPagoReservaServiceSpec extends Specification {

    RegistroPagoReservaService registroPagoReservaService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new RegistroPagoReserva(...).save(flush: true, failOnError: true)
        //new RegistroPagoReserva(...).save(flush: true, failOnError: true)
        //RegistroPagoReserva registroPagoReserva = new RegistroPagoReserva(...).save(flush: true, failOnError: true)
        //new RegistroPagoReserva(...).save(flush: true, failOnError: true)
        //new RegistroPagoReserva(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //registroPagoReserva.id
    }

    void "test get"() {
        setupData()

        expect:
        registroPagoReservaService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<RegistroPagoReserva> registroPagoReservaList = registroPagoReservaService.list(max: 2, offset: 2)

        then:
        registroPagoReservaList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        registroPagoReservaService.count() == 5
    }

    void "test delete"() {
        Long registroPagoReservaId = setupData()

        expect:
        registroPagoReservaService.count() == 5

        when:
        registroPagoReservaService.delete(registroPagoReservaId)
        sessionFactory.currentSession.flush()

        then:
        registroPagoReservaService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        RegistroPagoReserva registroPagoReserva = new RegistroPagoReserva()
        registroPagoReservaService.save(registroPagoReserva)

        then:
        registroPagoReserva.id != null
    }
}
