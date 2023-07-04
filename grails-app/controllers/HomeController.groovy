

import auth.User
import configuracionEmpresa.ConfiguracionEmpresa
import empresa.Empresa
import espacio.Espacio
import evaluacion.EvaluacionToUser
import grails.converters.JSON
import groovy.json.JsonSlurper
import reserva.Reserva
import ubicacion.Comuna
import ubicacion.Provincia
import ubicacion.Region
import ubicacion.UbicacionUser
import grails.plugin.springsecurity.annotation.Secured

import java.lang.reflect.Array
import java.text.SimpleDateFormat

@Secured(['isAuthenticated()'])
class HomeController {

    def springSecurityService
    def utilService
    def groovyPageRenderer

    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")

//    def dataSource
    def dashboard(){
        List<Espacio> espacioList = []
        List<Comuna> comunaList = []
        List<Provincia> provinciaList = []
        List<Comuna> comunaSelectLIst = []
        Region region
        User user = springSecurityService.getCurrentUser() //where "User" is is user domain class or you can "def" also
        if(user.authorities.findAll().find { it -> it.authority == "ROLE_ADMIN" } ){
            Empresa emp = Empresa.findByUsuario(user)
            espacioList = Espacio.createCriteria().list{
                and{
                    empresa {
                        eq('id', emp?.id)
                    }
                }
            }
            render( view: 'dashboard', model: [ espacioList: espacioList, empresaId: emp?.id ])
        }
    }

    def cargarComuna(Long regionId){
        List<Comuna> comunaList = []
        if( regionId ){
            try{
                Region region =  Region.findById(regionId)
                List<Provincia> provinciaList =  Provincia.findAllByRegion(region)
                for( provincia in  provinciaList ){
                    comunaList.addAll( Comuna.findAllByProvincia(provincia) )
                }
            }catch(e){}
        }
        render g.select(id: 'comuna', name: 'comuna',required: 'required', multiple: "", from: comunaList.sort { it?.comuna } , optionKey: 'id', noSelection: ['':'- Seleccione Comuna -'], class: "form-control select2", style:"width: 100%;" )
    }

    def cargarEspacios( String comunaStr, String categoria){
        List<Espacio> espacioList = []
        def parser = new JsonSlurper()
        def comunaJson = parser.parseText(comunaStr)
//        def categoriaJson = parser.parseText(categoriaStr)

        try{
            espacioList = Espacio.createCriteria().list {
                and{
                    or{
                        for( comunaAux in comunaJson) {
                            comuna {
                                eq('id', comunaAux?.toLong())
                            }
                        }
                    }
                    tipoEspacio{
                        eq('id',categoria?.toLong() )
                    }
                    eq('enabled', true)
                }
            }
//            espacioList.removeAll{it -> it?.tipoEspacioId != categoria.toLong() }
        }catch(e){}

        espacioList.removeAll{it -> !it?.empresa?.enabled }

        def empresaList = espacioList.groupBy ({ it -> it?.empresa })
        Integer pages = empresaList.size() / 8
        pages = empresaList.size()%8 == 0 ? pages : pages + 1

        def empresaPackage = empaquetarLista(empresaList)

        render template: '/espacio/cardEmpresaList', model: [empresaPackage: empresaPackage, pages: pages ]
    }

    def empaquetarLista(def empresaList){
        def empresaPackage = []
        def auxPackage = []
        int i = 0
//        for (int i = 0; i < empresaList.size(); i++) {
//            auxPackage.add(empresaList[i])
//            if( i%7 == 0 && i != 0){
//                empresaPackage.add(auxPackage)
//                auxPackage = []
//            }
//        }
        for( empresa in empresaList ){
            auxPackage.add(empresa)
            if( (i%7 == 0 && i != 0) || i == empresaList.size()-1 ){
                empresaPackage.add(auxPackage)
                auxPackage = []
            }
            i++
        }
        return empresaPackage
    }
//    def espaciosCerca(float lat, float lng){
//
//        User user = springSecurityService.getCurrentUser()
//        def espacioList = []
//        int slides = 0
//
//        if( lat != null && lng != null && user != null ) {
//            espacioList = Espacio.findAll("from Espacio as e where e.enabled = true " +
//                    "and ( 6371 * ACOS(COS(RADIANS(${lat})) * COS(RADIANS(latitud)) * COS(RADIANS(longitud) - RADIANS(${lng})) + SIN(RADIANS(${lat})) * SIN(RADIANS(latitud)))) < " + user?.distance )
//        }
//
//        espacioList.removeAll{it -> !it?.empresa?.enabled } // para no mostrar los espacios de cuyas empresas tengan sus cuentas bloqueadas
//        render template: '/home/homeUser', model: [espacioList: espacioList]
//    }

    @Secured(['ROLE_SUPERUSER','ROLE_ADMIN'])
    def dashboardKpi(){
        User user = springSecurityService.getCurrentUser()
        def ingresoTotal = []
        def ingresoOnline = []
        def ingresoOtros = []
        def topUser = []
        def topSpace = []
        def topFlujo =[]
        if(user){
            ingresoTotal = ingresoMensual(user, "")
            ingresoOnline = ingresoMensual(user, "online")
            ingresoOtros = ingresoMensual(user, "otros")
            topUser = topList(user, "user")
            topSpace = topList(user, "espacio")
            topFlujo = formatFlujo(topList(user, "flujo"))

        }
        render view: '/kpi/dashboardKpi',
                model:[
                    ingresoTotal: ingresoTotal,
                    ingresoOnline: ingresoOnline,
                    ingresoOtros: ingresoOtros,
                    topUser: topUser,
                    topSpace: topSpace,
                    topFlujo: topFlujo,
                    configuracion: ConfiguracionEmpresa.findByEmpresa(Empresa.findByUsuario(user)),
                    espacioList: Espacio.findAllByEmpresa( Empresa.findByUsuario(user) )
                ]
    }

    def ingresoMensual(User user, String tipo){
        Empresa empresaInstance = Empresa.findByUsuario(user)
        List<Reserva> reservaList
        def ingresoTotal = []
        def oneYearAgo = oneYearAgo()

        Calendar c = Calendar.getInstance()
        c.setTime(oneYearAgo)
        c.set(Calendar.MILLISECOND, 0)
        c.set(Calendar.SECOND, 0)
        c.set(Calendar.MINUTE, 0)
        c.set(Calendar.HOUR_OF_DAY, 0)

        Calendar d = Calendar.getInstance()
        d.setTime(oneYearAgo)
        d.set(Calendar.MILLISECOND, 59)
        d.set(Calendar.SECOND, 59)
        d.set(Calendar.MINUTE, 59)
        d.set(Calendar.HOUR_OF_DAY, 23)
        if( empresaInstance && oneYearAgo ){
            for( int i = 0 ; i <= 12 ; i++ ){
                int valor = 0
//                d.add(Calendar.MONTH, 1)
                d.set(Calendar.DAY_OF_MONTH, d.getActualMaximum(Calendar.DAY_OF_MONTH))

                reservaList = Reserva.createCriteria().list {
                    and{
                        espacio{
                            empresa{
                                eq('id', empresaInstance?.id)
                            }
                        }
                        between('fechaReserva', c.getTime(), d.getTime() )
                        estadoReserva{
                            eq('id', 2l)
                        }
                        evaluacion{
                            evaluacionToUser{
                                isNotNull('id')
                            }
                        }
//                        evaluacion{
//                            evaluacionToUser{
//                                ne('nota', 1)
//                            }
//                        }
                        if( tipo == 'online'){
                            tipoReserva{
                                eq('id', 2l)
                            }
                        }
                        if ( tipo == 'otros' ){
                            tipoReserva{
                                ne('id', 2l)
                            }
                        }

                    }
                }

                for( reserva in reservaList){
                    if(reserva?.valor){
                        valor = valor + reserva?.valor
                    }
                }
//                if( tipo == 'online'  ){
//                    def aux =  valor * 1.04
//                    valor = aux?.toInteger()
//                }

                ingresoTotal.add([c.getTimeInMillis(), valor ])
                c.add(Calendar.MONTH, 1)
                d.add(Calendar.MONTH, 1)
            }

        }
        return ingresoTotal
    }

    def oneYearAgo(){
        Date hoy = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(hoy)
        c.add(Calendar.YEAR, -1)
        c.set(Calendar.DAY_OF_MONTH, 1)
        return c.getTime()
    }

    def topList(User user, String tipo){
        Empresa empresaInstance = Empresa.findByUsuario(user)
        List<Reserva> reservaList
        def result = []
        def oneYearAgo = oneYearAgo()
        if( empresaInstance && oneYearAgo ){

            reservaList = Reserva.createCriteria().list {
                and{
                     espacio{
                        empresa{
                            eq('id', empresaInstance?.id)
                        }
                    }
                    ge('fechaReserva', oneYearAgo )
                    estadoReserva{
                        eq('id', 2l)
                    }
//                    evaluacion{
//                        evaluacionToUser{
//                            isNotNull('id')
//                        }
//                    }
                    evaluacion{
                        evaluacionToUser{
                             ne('nota', 1)
                        }
                    }
                }
            }

            if( tipo == "user" ){
                result = reservaList?.groupBy({ reserva -> reserva?.usuario})?.sort{ it?.value?.size() }
            }
            if( tipo == "espacio" ){
                result = reservaList?.groupBy({ reserva -> reserva?.espacio})
            }
            if( tipo == "flujo" ){
                result = reservaList?.groupBy({ reserva -> reserva?.horaInicio})
            }
        }
        return result
    }

    def formatFlujo(def lista){
        def listaRetorno = []
        def listaAux = []
        def cont
//        listaRetorno.add( [15, 3] )
        if( lista ){
            for( list in lista ){
                listaRetorno.add( [list?.key?.substring(0,2).toInteger() , list?.value?.size() ] )
            }
        }

        for (int i = 0; i < 24 ; i++) {
            cont = 0
            for( var in listaRetorno ){
                if( var[0] == i ){
                    cont = cont + var[1]
                }
            }
            listaAux.add( [i, cont] )
        }

        return listaAux
    }

    def welcomeApp(Long id ){
        respond User.get(id), model: [name: params?.name, username: params?.username]
    }

    def espaciosPorEmpresa(Long id){
        List<Espacio> espacioList = []
        Empresa empresa = new Empresa()
        try{
            empresa = Empresa.get(id)
            if( params?.espacio.getClass().getSimpleName() == "String[]" ){
                for (int i = 0; i < params?.espacio.size() ; i++) {
                    Espacio espacio = Espacio.get( params?.espacio[i].toInteger() )
                    espacioList.add(espacio)
                }
            }else{
                Espacio espacio = Espacio.get( params?.espacio.toInteger() )
                espacioList.add(espacio)
            }
        }catch(e){}

        render view: 'espaciosPorEmpresa', model: [espacioList: espacioList, empresa: empresa]
    }

    @Secured(['ROLE_SUPERUSER','ROLE_USER'])
    def espaciosPorEmpresaOut(Long id){
        List<Espacio> espacioList = []
        Empresa empresa = new Empresa()
        try{
            empresa = Empresa.get(id)
            espacioList = Espacio.findAllByEnabledAndEmpresa(true, empresa)
        }catch(e){}

        render view: 'espaciosPorEmpresa', model: [espacioList: espacioList, empresa: empresa]
    }

    def comisionFlow(){
        List<Reserva> reservaList = []
        User user = springSecurityService.getCurrentUser()
        Empresa emp = Empresa.findByUsuario(user)

        try{
            if( params?.desde && params?.hasta ){
                reservaList = Reserva.createCriteria().list {
                    and{
                        between('fechaReserva', sdf.parse(params?.desde), sdf.parse(params?.hasta) )
                        tipoReserva{
                            eq('id', 2l)
                        }
                        espacio{
                            empresa{
                                eq('id', emp?.id)
                            }
                        }
                    }
                }
            }
        }catch(e){}
        render template: '/kpi/tablaComision', model:[reservaList: reservaList]
    }

    def recaudacionEspacio(){
        List<Reserva> reservaList = []
        User user = springSecurityService.getCurrentUser()
        try{
            def espacioId = params?.espacioId?.toLong()
            Espacio esp = Espacio.get( espacioId )
            if( params?.desde && params?.hasta ){
                reservaList = Reserva.createCriteria().list {
                    and{
                        between('fechaReserva', sdf.parse(params?.desde), sdf.parse(params?.hasta) )
                        estadoReserva{
                            ne('id', 3l)
                        }
                        espacio{
                            eq('id', esp?.id)
                        }
                        evaluacion{
                            evaluacionToUser{
                                isNotNull('id')
                            }
                        }
//                        evaluacion{
//                            evaluacionToUser{
//                                ne('id', 1l)
//                            }
//                        }
                    }
                }
            }
        }catch(e){}
        render template: '/kpi/tablaRecaudacion', model:[reservaList: reservaList]
    }

    @Secured('permitAll')
    def showPreview(Long id){
        List<Espacio> espacioList = []
        Empresa empresa = new Empresa()
        try{
            empresa = Empresa.get(id)
            espacioList = Espacio.findAllByEnabledAndEmpresa(true, empresa)
        }catch(e){}

        respond empresa, model: [espacioList: espacioList]
    }

    def contactoSoporte(){
        respond springSecurityService.getCurrentUser()
    }

    def enviarCorreoSoporte(){
        try{
            User user = springSecurityService.getCurrentUser()
            String template = groovyPageRenderer.render(template:  "/correos/supportMail", model: [ nombre: user?.nombre, correo: user?.email, mensaje: params?.mensaje, userId: user?.id ])
            utilService.enviarCorreo("soporte@bookeame.cl", "noresponder@bookeame.cl", "SOPORTE TÉCNICO", template )
            flash.message = "Mensaje enviado exitosamente!."
        }catch(e){
            flash.error = "Ups! Ha ocurrido un error."
        }

        redirect( controller: 'home', action: 'contactoSoporte')
    }

    def testqr(){}

    @Secured(['ROLE_USER'])
    def cargarDireccion(boolean valor){
        boolean exito = false
        User user  = springSecurityService.getCurrentUser()
        UbicacionUser ubicacionUser = UbicacionUser.findByUsuarioAndEnUso(user, true)
        exito = ubicacionUser ? true : false
        if (valor){
            if (exito){
                render g.select(id:'region', name: 'region', required: 'required', multiple: "", from: Region.list() , optionKey: 'id', class: "form-control select2", style:"width: 100%;",value: ubicacionUser?.region?.id )
            }else{
                render g.select(id:'region',name:'region', required:'required',style:"width: 100%;",optionKey:'id',from:Region.list(), noSelection:['':'- Seleccione Región-'] )
            }
        }else{
            List<Comuna> comunaList = []
            Region region =  Region.findById(ubicacionUser?.region?.id)
            List<Provincia> provinciaList =  Provincia.findAllByRegion(region)

            for( provincia in  provinciaList ){
                comunaList.addAll( Comuna.findAllByProvincia(provincia) )
            }
            if (exito){
                render g.select(id: 'comuna', name: 'comuna',required: 'required', multiple: "", from: comunaList , optionKey: 'id', class: "form-control select2", style:"width: 100%; ", value: ubicacionUser?.comuna?.id)
            }else{
                render g.select(id: 'comuna', name: 'comuna',required: 'required', multiple: "", from: comunaList.sort { it?.comuna } , optionKey: 'id', noSelection: ['':'--'], class: "form-control select2", style:"width: 100%;" )

            }
        }
    }

}
