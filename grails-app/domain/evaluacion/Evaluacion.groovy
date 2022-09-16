package evaluacion

class Evaluacion {

    EvaluacionToEspacio evaluacionToEspacio
    EvaluacionToUser evaluacionToUser
    String comentarioToEspacio
    String comentarioToUser

    static constraints = {
        evaluacionToEspacio nullable: true
        evaluacionToUser nullable: true
        comentarioToEspacio nullable: true
        comentarioToUser nullable: true
    }
}
