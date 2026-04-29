/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;
import java.util.ArrayList;
import org.bson.types.ObjectId;
import java.util.Date;

public class Pacientes {
    private ObjectId idPaciente;
    private NombreCompleto nomCompP;
    private String telefono;
    private String email;
    private Date fechaRegP;
    private ArrayList<Historial> HistorialClinico;
    private ArrayList<String> alergias;

    public Pacientes() {
    }

    public Pacientes(ObjectId idPaciente, NombreCompleto nomCompP, String telefono, String email, Date fechaRegP, ArrayList<Historial> HistorialClinico, ArrayList<String> alergias) {
        this.idPaciente = idPaciente;
        this.nomCompP = nomCompP;
        this.telefono = telefono;
        this.email = email;
        this.fechaRegP = fechaRegP;
        this.HistorialClinico = HistorialClinico;
        this.alergias = alergias;
    }

    public ObjectId getIdPaciente() {
        return idPaciente;
    }

    public void setIdPaciente(ObjectId idPaciente) {
        this.idPaciente = idPaciente;
    }

    public NombreCompleto getNomCompP() {
        return nomCompP;
    }

    public void setNomCompP(NombreCompleto nomCompP) {
        this.nomCompP = nomCompP;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getFechaRegP() {
        return fechaRegP;
    }

    public void setFechaRegP(Date fechaRegP) {
        this.fechaRegP = fechaRegP;
    }

    public ArrayList<Historial> getHistorialClinico() {
        return HistorialClinico;
    }

    public void setHistorialClinico(ArrayList<Historial> HistorialClinico) {
        this.HistorialClinico = HistorialClinico;
    }

    public ArrayList<String> getAlergias() {
        return alergias;
    }

    public void setAlergias(ArrayList<String> alergias) {
        this.alergias = alergias;
    }
    
    
}
