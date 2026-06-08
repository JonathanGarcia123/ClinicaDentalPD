/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;
import java.util.Date;
import org.bson.codecs.pojo.annotations.BsonId;
import org.bson.types.ObjectId;
/**
 *
 * @author jonyx
 */
public class Historial {
    @BsonId
    private ObjectId idHistorial;
    private Tratamientos tratamiento;
    private String observaciones;
    private Date fechaAplicacion;
    private String nombreMedico;
    private String medicamentosRecetados;

    public Historial() {
    }

    public Historial(ObjectId idHistorial, Tratamientos tratamiento, String observaciones, Date fechaAplicacion, String nombreMedico, String medicamentosRecetados) {
        this.idHistorial = idHistorial;
        this.tratamiento = tratamiento;
        this.observaciones = observaciones;
        this.fechaAplicacion = fechaAplicacion;
        this.nombreMedico = nombreMedico;
        this.medicamentosRecetados = medicamentosRecetados;
    }

    public ObjectId getIdHistorial() {
        return idHistorial;
    }

    public void setIdHistorial(ObjectId idHistorial) {
        this.idHistorial = idHistorial;
    }

    public Tratamientos getTratamiento() {
        return tratamiento;
    }

    public void setTratamiento(Tratamientos tratamiento) {
        this.tratamiento = tratamiento;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public Date getFechaAplicacion() {
        return fechaAplicacion;
    }

    public void setFechaAplicacion(Date fechaAplicacion) {
        this.fechaAplicacion = fechaAplicacion;
    }

    public String getNombreMedico() {
        return nombreMedico;
    }

    public void setNombreMedico(String nombreMedico) {
        this.nombreMedico = nombreMedico;
    }

    public String getMedicamentosRecetados() {
        return medicamentosRecetados;
    }

    public void setMedicamentosRecetados(String medicamentosRecetados) {
        this.medicamentosRecetados = medicamentosRecetados;
    }
    
}
