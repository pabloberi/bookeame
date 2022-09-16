package espacio

class Categoria {

    String nombre
    String descripcion
    String color
    String icono
    Boolean enabled = true

    static hasMany = [tipoEspacioList: TipoEspacio]

    Date dateCreated
    Date lastUpdated

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
        enabled nullable: true
        color nullable: true
        icono nullable: true
        tipoEspacioList nullable: true
    }

    @Override
    String toString() {
        return nombre
    }
}
