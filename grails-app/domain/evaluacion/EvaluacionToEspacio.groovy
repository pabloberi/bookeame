package evaluacion

class EvaluacionToEspacio {

    String descripcion
    Integer nota

    static constraints = {
        descripcion nullable: true
        nota nullable: true
    }

    @Override
    String toString() {
        return nota + ".- "+ descripcion
    }
}
