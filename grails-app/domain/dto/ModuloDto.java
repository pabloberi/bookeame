package dto;

import espacio.Espacio;
import reserva.Dia;

public class ModuloDto {

    private Espacio espacio;
    private String horaInicio;
    private String horaTermino;
    private Integer valor;
    private Dia dias;

    public Espacio getEspacio() {
        return espacio;
    }

    public void setEspacio(Espacio espacio) {
        this.espacio = espacio;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraTermino() {
        return horaTermino;
    }

    public void setHoraTermino(String horaTermino) {
        this.horaTermino = horaTermino;
    }

    public Integer getValor() {
        return valor;
    }

    public void setValor(Integer valor) {
        this.valor = valor;
    }

    public Dia getDias() {
        return dias;
    }

    public void setDias(Dia dias) {
        this.dias = dias;
    }
}
