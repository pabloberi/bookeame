package Alarma

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class AlarmaServiceSpec extends Specification {

    AlarmaService alarmaService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Alarma(...).save(flush: true, failOnError: true)
        //new Alarma(...).save(flush: true, failOnError: true)
        //Alarma alarma = new Alarma(...).save(flush: true, failOnError: true)
        //new Alarma(...).save(flush: true, failOnError: true)
        //new Alarma(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //alarma.id
    }

    void "test get"() {
        setupData()

        expect:
        alarmaService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Alarma> alarmaList = alarmaService.list(max: 2, offset: 2)

        then:
        alarmaList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        alarmaService.count() == 5
    }

    void "test delete"() {
        Long alarmaId = setupData()

        expect:
        alarmaService.count() == 5

        when:
        alarmaService.delete(alarmaId)
        sessionFactory.currentSession.flush()

        then:
        alarmaService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Alarma alarma = new Alarma()
        alarmaService.save(alarma)

        then:
        alarma.id != null
    }
}
