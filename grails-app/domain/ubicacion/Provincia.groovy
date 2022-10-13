package ubicacion

class Provincia {

    String provincia
    Region region

    static constraints = {
        provincia nullable: true
        region nullable: true
    }

    @Override
    String toString() {
        return provincia
    }
}
