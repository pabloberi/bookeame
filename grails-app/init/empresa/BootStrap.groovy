package empresa

import auth.Role
import auth.User
import auth.UserRole
import comercial.EstadoCuentaMensual
import comercial.PeriodosPlan
import espacio.Categoria
import espacio.TipoEspacio
import flow.Comision
import gestion.General
import evaluacion.EvaluacionToEspacio
import evaluacion.EvaluacionToUser
import reserva.EstadoReserva
import reserva.TipoReserva

class BootStrap {

    def init = { servletContext ->

        println "### Empezando carga de datos..."

        println("### Creando Roles")

        def superUserRole = Role.findByAuthority('ROLE_SUPERUSER') ?: new Role(authority: 'ROLE_SUPERUSER').save(failOnError: true)
        def staffRole = Role.findByAuthority('ROLE_STAFF') ?: new Role(authority: 'ROLE_STAFF').save(failOnError: true)
        def usuarioRole = Role.findByAuthority('ROLE_USER') ?: new Role(authority: 'ROLE_USER').save(failOnError: true)
        def adminRole = Role.findByAuthority('ROLE_ADMIN') ?: new Role(authority: 'ROLE_ADMIN').save(failOnError: true)
        println("### OK")

        println("### Creando Usuarios")
//        def adminUser = User.findByUsername('admin') ?: new User(
//                username: 'admin',
//                password: 'ad220022',
//                enabled: true).save(failOnError: true)
//
//        if (!adminUser.authorities.contains(adminRole)) {
//            UserRole.create adminUser, adminRole
//        }
//        println("### ADMIN OK")

        def superUser = User.findByUsername('root') ?: new User(
                username: 'root',
                password: 'ro220022',
                enabled: true).save(failOnError: true)

        if (!superUser.authorities.contains(superUserRole)) {
            UserRole.create superUser, superUserRole
        }
        println("### SUPERUSER OK")

//        def usuarioUser = User.findByUsername('user') ?: new User(
//                username: 'user',
//                password: 'us220022',
//                enabled: true).save(failOnError: true)
//
//        if (!usuarioUser.authorities.contains(usuarioRole)) {
//            UserRole.create usuarioUser, usuarioRole
//        }
//        println("### USER OK")

        println("### Creando EstadoReserva")

        def pendiente = EstadoReserva.findById(1)?: new EstadoReserva(
                nombre: 'Pendiente',
                descripcion: 'Estado Pendiente'
        ).save(failOnError: true)

        def aprobado = EstadoReserva.findById(2)?: new EstadoReserva(
                nombre: 'Aprobada',
                descripcion: 'Estado Aprobada'
        ).save(failOnError: true)

        def cancelado = EstadoReserva.findById(3)?: new EstadoReserva(
                nombre: 'Cancelada',
                descripcion: 'Estado Cancelada'
        ).save(failOnError: true)

        println("### Estado Reserva OK")

        println("### Creando Tipo Reserva")

        def post = TipoReserva.findById(1)?: new TipoReserva(
                nombre: "Pos Pago",
                descripcion: "Pagar el dia de arriendo"
        ).save(failOnError: true)

        def pre = TipoReserva.findById(2)?: new TipoReserva(
                nombre: "Pre Pago",
                descripcion: "Pagar al momento de reservar"
        ).save(failOnError: true)

        def manual = TipoReserva.findById(3)?: new TipoReserva(
                nombre: "Manual",
                descripcion: "Registro manual desde la Empresa"
        ).save(failOnError: true)

        println("### OK")

        println("### Creando Evaluacion User")
        def uno = EvaluacionToUser.findByNota(1)?: new EvaluacionToUser(
                descripcion: "El usuario NO se presentó",
                nota: 1
        ).save(failOnError: true)
        def dos = EvaluacionToUser.findByNota(2)?: new EvaluacionToUser(
                descripcion: "El usuario llegó IMPUNTUAL y tuvo un comportamiento INADECUADO",
                nota: 2
        ).save(failOnError: true)
        def tres = EvaluacionToUser.findByNota(3)?: new EvaluacionToUser(
                descripcion: "El usuario llegó PUNTUAL y tuvo un comportamiento INADECUADO",
                nota: 3
        ).save(failOnError: true)
        def cuatro = EvaluacionToUser.findByNota(4)?: new EvaluacionToUser(
                descripcion: "El usuario llegó IMPUNTUAL y tuvo un comportamiento ADECUADO",
                nota: 4
        ).save(failOnError: true)
        def cinco = EvaluacionToUser.findByNota(5)?: new EvaluacionToUser(
                descripcion: "El usuario llegó PUNTUAL y tuvo un comportamiento ADECUADO",
                nota: 5
        ).save(failOnError: true)

        println("### OK")

        println("### Creando Evaluacion Espacio")
        def unoEsp = EvaluacionToEspacio.findByNota(1)?: new EvaluacionToEspacio(
                descripcion: "Muy inconforme",
                nota: 1
        ).save(failOnError: true)
        def dosEsp = EvaluacionToEspacio.findByNota(2)?: new EvaluacionToEspacio(
                descripcion: "Inconforme",
                nota: 2
        ).save(failOnError: true)
        def tresEsp = EvaluacionToEspacio.findByNota(3)?: new EvaluacionToEspacio(
                descripcion: "Regular",
                nota: 3
        ).save(failOnError: true)
        def cuatroEsp = EvaluacionToEspacio.findByNota(4)?: new EvaluacionToEspacio(
                descripcion: "Conforme",
                nota: 4
        ).save(failOnError: true)
        def cincoEsp = EvaluacionToEspacio.findByNota(5)?: new EvaluacionToEspacio(
                descripcion: "Muy Conforme",
                nota: 5
        ).save(failOnError: true)
        println("### OK")

        println("### Creando Configuraciones")

        def baseUrl = General.findByNombre('baseUrl') ?: new General(
                nombre: 'baseUrl',
                valor: 'link',
                descripcion: 'baseUrl'
        ).save(failOnError: true)

        def serverFlow = General.findByNombre('serverFlow') ?: new General(
                nombre: 'serverFlow',
                valor: 'https://sandbox.flow.cl/api', // 'https://www.flow.cl/api' -> Producción
                descripcion: 'serverFlow'
        ).save(failOnError: true)

        def correlativoFlow = General.findByNombre('correlativoFlow') ?: new General(
                nombre: 'correlativoFlow',
                valor: '1',
                descripcion: 'correlativoFlow'
        ).save(failOnError: true)

        println("### OK")

        def keyGoogleMaps = General.findByNombre('keyGoogleMaps') ?: new General(
                nombre: 'keyGoogleMaps',
                valor: 'AIzaSyCvWSWWBOdx14sLyCNCEEyZ9qpYryEe6MM',
                descripcion: 'keyGoogleMaps'
        ).save(failOnError: true)

        def publicKeyCaptcha = General.findByNombre('publicKeyCaptcha') ?: new General(
                nombre: 'publicKeyCaptcha',
                valor: '6LdEZQUaAAAAABNDonfY-tBaU_5ykmZmJ9M5iT9B',
                descripcion: 'publicKeyCaptcha'
        ).save(failOnError: true)

        def secretKeyCaptcha = General.findByNombre('secretKeyCaptcha') ?: new General(
                nombre: 'secretKeyCaptcha',
                valor: '6LdEZQUaAAAAAJaY0XxHf92h1yaLX-4fUjkIqYCZ',
                descripcion: 'secretKeyCaptcha'
        ).save(failOnError: true)

        def maximoPosPago = General.findByNombre('maximoPosPago') ?: new General(
                nombre: 'maximoPosPago',
                valor: '3',
                descripcion: 'maximoPosPago'
        ).save(failOnError: true)

        def clientLoginGoogle = General.findByNombre('keyLoginGoogle') ?: new General(
                nombre: 'keyLoginGoogle',
                valor: '134397099253-mnol68m0h1brb475t052v0tsqqhjsvjv.apps.googleusercontent.com',
                descripcion: 'keyLoginGoogle'
        ).save(failOnError: true)

        //  /opt/tomcat/apache-tomcat-8.5.61/webapps/gestion/assets/imagenes/
        def pathImg = General.findByNombre('pathImg') ?: new General(
                nombre: 'pathImg',
                valor: 'C:/Proyectos/gestion/grails-app/assets/img/imagenes/',
                descripcion: 'pathImg'
        ).save(failOnError: true)

        def keyFirebase = General.findByNombre("keyFirebase") ?: new General(
                nombre: 'keyFirebase',
                valor: 'AAAAH0qw_PU:APA91bEaMoN7NXaP7kKBlzDwFIYAbGexrLGC7xnGoUKtgLXmwSkw5IVOgEcVRADCj499C1O0g12qq4IYceeMLn1KtqXEYh8dqIgOkViplrfZ7SO_8RkHDkvNdVRALyfrEwZfxvSBQLJk',
                descripcion: 'keyFirebase'
        ).save(failOnError: true)

        def valorUnitarioTrx = General.findByNombre("valorUnitarioTrx") ?: new General(
                nombre: 'valorUnitarioTrx',
                valor: '50',
                descripcion: 'valorUnitarioTrx'
        ).save(failOnError: true)

        def valorMinFlow = General.findByNombre("valorMinFlow") ?: new General(
                nombre: 'valorMinFlow',
                valor: '0',
                descripcion: '0'
        ).save(failOnError: true)

        if(!Categoria.count()){
            new Categoria(
                    nombre: 'Deportes',
                    descripcion: 'Actividades fisicas',
                    color: '#31C027',
                    icono: '',
            ).save(failOnError: true)

            new Categoria(
                    nombre: 'Belleza y Salud',
                    descripcion: 'Salud y Belleza',
                    color: '#C05050',
                    icono: '',
            ).save(failOnError: true)

            new Categoria(
                    nombre: 'Mascotas',
                    descripcion: 'Salud y Belleza para nuestas amadas mascotas',
                    color: '#ECB8E9',
                    icono: '',
            ).save(failOnError: true)

            new Categoria(
                    nombre: 'Recreación',
                    descripcion: 'Para tu salud fisica y mental',
                    color: '#2D5DD09',
                    icono: '',
            ).save(failOnError: true)

            new Categoria(
                    nombre: 'Alojamiento',
                    descripcion: 'Lugar para hospedar temporalmente',
                    color: '#AF602A',
                    icono: '',
            ).save(failOnError: true)

            new Categoria(
                    nombre: 'Arte corporal',
                    descripcion: 'Estilo de arte conceptual, el cual utiliza el cuerpo como expresión artistica',
                    color: '#EBCAE9',
                    icono: '',
            ).save(failOnError: true)

            new Categoria(
                    nombre: 'Gastronomía',
                    descripcion: 'Para degustar con exquisitas comidas',
                    color: '#FFE200',
                    icono: '',
            ).save(failOnError: true)
        }

        if( !TipoEspacio.count() ){
            def deportes = Categoria.findByNombre('Deportes')
            def belleza = Categoria.findByNombre('Salud y Belleza')
            def mascotas = Categoria.findByNombre('Mascotas')
            def recreación = Categoria.findByNombre('Recreación')
            def alojamiento = Categoria.findByNombre('Alojamiento')
            def arteCorporal = Categoria.findByNombre('Arte corporal')
            def gastronomia = Categoria.findByNombre('Gastronomia')

            new TipoEspacio(
                    nombre: "Fútbol",
                    descripcion: "futbol",
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Tenis',
                    descripcion: 'Tenis',
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Pádel',
                    descripcion: 'Pádel',
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Bowling',
                    descripcion: 'Bowling',
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Pool',
                    descripcion: 'Pool',
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Tenis de mesa',
                    descripcion: 'Tenis de mesa',
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Escalada en muro',
                    descripcion: 'Escalada en muro',
                    categoria: deportes
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Peluquería - Barbería',
                    descripcion: 'Define el look que tu quieras',
                    categoria: belleza
            ).save(failOnError: true)

//            new TipoEspacio(
//                    nombre: 'Barbería',
//                    descripcion: 'Podras acondicionar tu barba a tu gusto',
//                    categoria: Belleza
//            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Salón de Belleza',
                    descripcion: 'Para que resaltar tus hermosas manos áun más',
                    categoria: belleza
            ).save(failOnError: true)

//            new TipoEspacio(
//                    nombre: 'Manicure',
//                    descripcion: 'Para que resaltar tus hermosas manos áun más',
//                    categoria: Belleza
//            ).save(failOnError: true)
//
//            new TipoEspacio(
//                    nombre: 'Depilación',
//                    descripcion: 'Podras eliminar esos vellos que no desees',
//                    categoria: Belleza
//            ).save(failOnError: true)
//
//            new TipoEspacio(
//                    nombre: 'Maquillaje',
//                    descripcion: 'Podras decorar tu piel como mas lo quieras',
//                    categoria: Belleza
//            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: "Peluquería para mascotas",
                    descripcion: "Belleza para nuestas amadas mascotas",
                    categoria: mascotas
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: "Veterinaria",
                    descripcion: "Salud para tu mascota",
                    categoria: mascotas
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Paintball',
                    descripcion: 'Para pasar un momento lleno de adrenalina con este juego de pistolas con bolitas de pintura',
                    categoria: recreación
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Bares y Pubs',
                    descripcion: 'Discfruta un una buena conversación con una bebida',
                    categoria: recreación
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Hotel',
                    descripcion: 'Alquiler de habitacioes',
                    categoria: alojamiento
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Hostal',
                    descripcion: 'Alquiler de habitacioes',
                    categoria: alojamiento
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Motel',
                    descripcion: 'Alquiler de habitacioes para un momento intimo con tu pareja',
                    categoria: alojamiento
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Tatuajes',
                    descripcion: 'Dibujo grabado en la piel',
                    categoria: arteCorporal
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Piercing',
                    descripcion: 'Pieza de joyeria para tu cuerpo',
                    categoria: arteCorporal
            ).save(failOnError: true)

            new TipoEspacio(
                    nombre: 'Restaurantes',
                    descripcion: 'Para que puedas darte un gusto gastronomico',
                    categoria: gastronomia
            ).save(failOnError: true)

        }

        println("### Creando Estados de Cuentas")
        if( !EstadoCuentaMensual.count() ){
            new EstadoCuentaMensual(nombre: 'Pendiente', descripcion: 'Pago Pendiente').save()
            new EstadoCuentaMensual(nombre: 'Realizado', descripcion: 'Pago Realizado').save()
            new EstadoCuentaMensual(nombre: 'Atrasado', descripcion: 'Pago Atrasado').save()
            new EstadoCuentaMensual(nombre: 'Anulado', descripcion: 'Pago Anulado').save()
        }
        println("### OK")

        println("### Creando Comision Flow")
        if( !Comision.count() ){
            new Comision( valor: 3.19 ).save()
            new Comision( valor: 2.89 ).save()
            new Comision( valor: 1.99 ).save()
            new Comision( valor: 0 ).save()
        }
        println("### OK")


        println("### Creando Periodos")
        if( !PeriodosPlan.count() ){
            new PeriodosPlan(ultimosMeses: 6, nombre:  "Últimos 6 Meses").save()
            new PeriodosPlan(ultimosMeses: 12, nombre:"Últimos 12 Meses").save()
            new PeriodosPlan(ultimosMeses: 24, nombre:"Últimos 24 Meses").save()
            new PeriodosPlan(ultimosMeses: 36, nombre:"Últimos 36 Meses").save()
        }
        println("### OK")


    }
    def destroy = {
        println "### Finalizando carga de datos..."
    }
}
