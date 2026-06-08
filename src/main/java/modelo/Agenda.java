/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;
import org.bson.types.ObjectId;
import java.util.Date;
import org.bson.codecs.pojo.annotations.BsonId;

/**
 *
 * @author jonyx
 */
public class Agenda {
    @BsonId
    private ObjectId idAgenda;
    private Pacientes fkPaciente;
    private Doctores fkDoctor;
    private Date fecha;
    private String hora;
    private int duracionMin;
    private String motivo;
    private String status;
    private int consultorio;

    public Agenda() {
    }

    public Agenda(ObjectId idAgenda, Pacientes fkPaciente, Doctores fkDoctor, Date fecha, String hora, int duracionMin, String motivo, String status, int consultorio) {
        this.idAgenda = idAgenda;
        this.fkPaciente = fkPaciente;
        this.fkDoctor = fkDoctor;
        this.fecha = fecha;
        this.hora = hora;
        this.duracionMin = duracionMin;
        this.motivo = motivo;
        this.status = status;
        this.consultorio = consultorio;
    }

    public ObjectId getIdAgenda() {
        return idAgenda;
    }

    public void setIdAgenda(ObjectId idAgenda) {
        this.idAgenda = idAgenda;
    }

    public Pacientes getFkPaciente() {
        return fkPaciente;
    }

    public void setFkPaciente(Pacientes fkPaciente) {
        this.fkPaciente = fkPaciente;
    }

    public Doctores getFkDoctor() {
        return fkDoctor;
    }

    public void setFkDoctor(Doctores fkDoctor) {
        this.fkDoctor = fkDoctor;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public String getHora() {
        return hora;
    }

    public void setHora(String hora) {
        this.hora = hora;
    }

    public int getDuracionMin() {
        return duracionMin;
    }

    public void setDuracionMin(int duracionMin) {
        this.duracionMin = duracionMin;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getConsultorio() {
        return consultorio;
    }

    public void setConsultorio(int consultorio) {
        this.consultorio = consultorio;
    }
    
    
}
