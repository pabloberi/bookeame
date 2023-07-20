package dto;

public class EventoCalendario {
    private String	title;
    private String	className;
    private String	start;
    private String	end;
    private String	description;

    private String	usuario; // nombre
    private Long	reservaId;
    private String	horaInicio;
    private String	horaTermino;
    private String	fechaReserva;
    private String	valor;
    private String	urlDelete;
    private String	urlFicha;
    private String  urlSave;

    private Long	modulo;

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getClassName() {
        return className;
    }
    public void setClassName(String className) {
        this.className = className;
    }
    public String getStart() {
        return start;
    }
    public void setStart(String start) {
        this.start = start;
    }
    public String getEnd() {
        return end;
    }
    public void setEnd(String end) {
        this.end = end;
    }
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }
    public String getUsuario() {
        return usuario;
    }
    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }
    public Long getReservaId() {
        return reservaId;
    }
    public void setReservaId(Long reservaId) {
        this.reservaId = reservaId;
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
    public String getFechaReserva() {
        return fechaReserva;
    }
    public void setFechaReserva(String fechaReserva) {
        this.fechaReserva = fechaReserva;
    }
    public String getValor() {
        return valor;
    }
    public void setValor(String valor) {
        this.valor = valor;
    }
    public String getUrlDelete() {
        return urlDelete;
    }
    public void setUrlDelete(String urlDelete) {
        this.urlDelete = urlDelete;
    }
    public String getUrlFicha() {
        return urlFicha;
    }
    public void setUrlFicha(String urlFicha) {
        this.urlFicha = urlFicha;
    }
    public Long getModulo() {
        return modulo;
    }
    public void setModulo(Long modulo) {
        this.modulo = modulo;
    }
    public String getUrlSave(){ return urlSave;}
    public void setUrlSave(String urlSave){this.urlSave = urlSave;}
}
