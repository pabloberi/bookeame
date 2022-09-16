package gestion

class General {
    String nombre
    String descripcion
    String valor

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
        valor nullable: true
    }

    @Override
    String toString() {
        return nombre
    }
}
