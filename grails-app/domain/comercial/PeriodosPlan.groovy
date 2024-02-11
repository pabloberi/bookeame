package comercial

class PeriodosPlan {

    Integer ultimosMeses
    String  nombre

    static constraints = {
        ultimosMeses nullable: true
        nombre nullable: true
    }

    @Override
    String toString() {
        return this.nombre
    }
}
