package ubicación

class Comuna {

    String comuna
    Provincia provincia

    static constraints = {
        comuna nullable: true
        provincia nullable: true
    }

    @Override
    String toString() {
        return comuna
    }
}
