package espacio

class TipoEspacio {

    String nombre
    String descripcion
    Boolean enabled = true

    Date dateCreated
    Date lastUpdated

    static belongsTo = [categoria: Categoria]

    static constraints = {
        nombre nullable: true
        descripcion nullable: true
        enabled nullable: true
        categoria nullable: true
    }

    @Override
    String toString() {
        return nombre
    }
}
