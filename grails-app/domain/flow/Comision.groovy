package flow

class Comision {

    Float valor

    static constraints = {
    }

    @Override
    String toString() {
        if( valor != 0 ){
            return valor?.toString() + "% + IVA"
        }else{
            return "La empresa asume la comisión"
        }
    }
}
