/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;
import org.bson.types.ObjectId;
/**
 *
 * @author jonyx
 */
public class Tratamientos {
    private ObjectId idTratamiento;
    private String nombre;
    private String description;
    private Double precioBase;

    public Tratamientos() {
    }

    public Tratamientos(ObjectId idTratamiento, String nombre, String description, Double precioBase) {
        this.idTratamiento = idTratamiento;
        this.nombre = nombre;
        this.description = description;
        this.precioBase = precioBase;
    }

    public ObjectId getIdTratamiento() {
        return idTratamiento;
    }

    public void setIdTratamiento(ObjectId idTratamiento) {
        this.idTratamiento = idTratamiento;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(Double precioBase) {
        this.precioBase = precioBase;
    }
    
}
