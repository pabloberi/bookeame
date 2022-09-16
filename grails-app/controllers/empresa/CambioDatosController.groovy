package empresa

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException

import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['isAuthenticated()'])
class CambioDatosController {

    CambioDatosService cambioDatosService
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy")

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond cambioDatosService.list(params), model: [cambioDatosCount: cambioDatosService.count()]
    }

    def show(Long id) {
        respond cambioDatosService.get(id)
    }

    def create() {
        respond new CambioDatos(params)
    }

    def save(CambioDatos cambioDatos) {
        if (cambioDatos == null) {
            notFound()
            return
        }

        try {
            cambioDatosService.save(cambioDatos)
        } catch (ValidationException e) {
            respond cambioDatos.errors, view: 'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cambioDatos.label', default: 'CambioDatos'), cambioDatos.id])
                redirect cambioDatos
            }
            '*' { respond cambioDatos, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond cambioDatosService.get(id)
    }

    def update(CambioDatos cambioDatos) {
        if (cambioDatos == null) {
            notFound()
            return
        }

        try {
            cambioDatosService.save(cambioDatos)
        } catch (ValidationException e) {
            respond cambioDatos.errors, view: 'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'cambioDatos.label', default: 'CambioDatos'), cambioDatos.id])
                redirect cambioDatos
            }
            '*' { respond cambioDatos, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        cambioDatosService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'cambioDatos.label', default: 'CambioDatos'), id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'cambioDatos.label', default: 'CambioDatos'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }

    def cambioDatosEmpresa(Long id) {
        Empresa empresa = Empresa.findById(id)
        boolean exito = true
        CambioDatos cambioDatos

        try{
            params?.fechaNacRepresentante = sdf.parse(params?.fechaNacRepresentante)
            char dvEmpresa = params?.dvEmpresa
            char dvRep = params?.dvRepresentante
            if (empresa) {
                if( validarDv(params?.rutEmpresa, dvEmpresa) && validarDv(params?.rutRepresentante, dvRep) ){
                    cambioDatos = new CambioDatos(
                            giro: params?.giro,
                            razonSocial: params?.razonSocial,
                            rut: params?.rutEmpresa,
                            dv: params?.dvEmpresa,
                            direccion: params?.direccionEmpresa,
                            nombre: params?.nombreRepresentante,
                            apellidoPaterno: params?.apellidoPaternoRepresentante,
                            apellidoMaterno: params?.apellidoMaternoRepresentante,
                            celular: params?.celularRepresentante,
                            fechaNac: params?.fechaNacRepresentante,
                            rutUser: params?.rutRepresentante,
                            dvUser: params?.dvRepresentante,
                            empresa: empresa
                    ).save(failOnError: true)
                }else{
                    exito = false
                }
            }else{
                exito = false
            }
        }catch(e){
            exito = false
        }

        if( exito && cambioDatos != null ){
            flash.message = "Solicitud de cambio de datos enviada correctamente!"
        }else{
            flash.error = "Ups! no hemos podido registrar tu solicitud. Por favor intenta más tarde."
        }
        redirect(controller: 'user', action: 'show', id: empresa?.usuario?.id)
    }

    @Secured(['permitAll'])
    def validarDv(String rut, char dv){
        if(rut != "" && dv != null){
            boolean validacion
            dv.upperCase
            int M=0,S=1,T=Integer.parseInt(rut)
            for(;T!=0;T/=10) S=(S+T%10*(9-M++%6))%11
            if (dv.equals((char)(S!=0?S+47:75))) {
                validacion = true
            } else {
                validacion = false
            }
            return  validacion
        }
    }


}
