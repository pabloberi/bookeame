package ubicacion

class Region {

    String region
    String abreviatura
    String capital

    static constraints = {
        region nullable: true
        abreviatura nullable: true
        capital nullable: true
    }

    @Override
    String toString() {
        return region
    }
}
