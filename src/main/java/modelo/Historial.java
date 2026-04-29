/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;
import java.util.Date;
/**
 *
 * @author jonyx
 */
public class Historial {
    private Tratamientos tratamiento;
    private String observaciones;
    private Date fechaAplicacion;

    public Historial() {
    }

    public Historial(Tratamientos tratamiento, String observaciones, Date fechaAplicacion) {
        this.tratamiento = tratamiento;
        this.observaciones = observaciones;
        this.fechaAplicacion = fechaAplicacion;
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
    
    
}
