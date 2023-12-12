package feriados

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class FeriadosServiceSpec extends Specification {

    FeriadosService feriadosService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Feriados(...).save(flush: true, failOnError: true)
        //new Feriados(...).save(flush: true, failOnError: true)
        //Feriados feriados = new Feriados(...).save(flush: true, failOnError: true)
        //new Feriados(...).save(flush: true, failOnError: true)
        //new Feriados(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //feriados.id
    }

    void "test get"() {
        setupData()

        expect:
        feriadosService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Feriados> feriadosList = feriadosService.list(max: 2, offset: 2)

        then:
        feriadosList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        feriadosService.count() == 5
    }

    void "test delete"() {
        Long feriadosId = setupData()

        expect:
        feriadosService.count() == 5

        when:
        feriadosService.delete(feriadosId)
        sessionFactory.currentSession.flush()

        then:
        feriadosService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Feriados feriados = new Feriados()
        feriadosService.save(feriados)

        then:
        feriados.id != null
    }
}
