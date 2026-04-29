/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;
import java.util.Date;
import org.bson.types.ObjectId;

/**
 *
 * @author jonyx
 */
public class Doctores {
    private ObjectId idAgenda;
    private NombreCompleto nomCompD;
    private String especialidad;
    private String cedulaProf;
    private HorarioDoctor horarioDisp;
    private Date fechaReg;
    private Boolean activo;

    public Doctores() {
    }

    public Doctores(ObjectId idAgenda, NombreCompleto nomCompD, String especialidad, String cedulaProf, HorarioDoctor horarioDisp, Date fechaReg, Boolean activo) {
        this.idAgenda = idAgenda;
        this.nomCompD = nomCompD;
        this.especialidad = especialidad;
        this.cedulaProf = cedulaProf;
        this.horarioDisp = horarioDisp;
        this.fechaReg = fechaReg;
        this.activo = activo;
    }

    public ObjectId getIdAgenda() {
        return idAgenda;
    }

    public void setIdAgenda(ObjectId idAgenda) {
        this.idAgenda = idAgenda;
    }

    public NombreCompleto getNomCompD() {
        return nomCompD;
    }

    public void setNomCompD(NombreCompleto nomCompD) {
        this.nomCompD = nomCompD;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public void setEspecialidad(String especialidad) {
        this.especialidad = especialidad;
    }

    public String getCedulaProf() {
        return cedulaProf;
    }

    public void setCedulaProf(String cedulaProf) {
        this.cedulaProf = cedulaProf;
    }

    public HorarioDoctor getHorarioDisp() {
        return horarioDisp;
    }

    public void setHorarioDisp(HorarioDoctor horarioDisp) {
        this.horarioDisp = horarioDisp;
    }

    public Date getFechaReg() {
        return fechaReg;
    }

    public void setFechaReg(Date fechaReg) {
        this.fechaReg = fechaReg;
    }

    public Boolean getActivo() {
        return activo;
    }

    public void setActivo(Boolean activo) {
        this.activo = activo;
    }
    
    
}
