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
public class Tratamientos {
    private ObjectId idTratamiento;
    private int codProducto;
    private String nombre;
    private String description;
    private Date fechaCaducidad;
    private Double precioBase;
    private int stock;

    public Tratamientos() {
    }

    public Tratamientos(ObjectId idTratamiento, int codProducto, String nombre, String description, Date fechaCaducidad, Double precioBase, int stock) {
        this.idTratamiento = idTratamiento;
        this.codProducto = codProducto;
        this.nombre = nombre;
        this.description = description;
        this.fechaCaducidad = fechaCaducidad;
        this.precioBase = precioBase;
        this.stock = stock;
    }

    public ObjectId getIdTratamiento() {
        return idTratamiento;
    }

    public void setIdTratamiento(ObjectId idTratamiento) {
        this.idTratamiento = idTratamiento;
    }

    public int getCodProducto() {
        return codProducto;
    }

    public void setCodProducto(int codProducto) {
        this.codProducto = codProducto;
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

    public Date getFechaCaducidad() {
        return fechaCaducidad;
    }

    public void setFechaCaducidad(Date fechaCaducidad) {
        this.fechaCaducidad = fechaCaducidad;
    }

    public Double getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(Double precioBase) {
        this.precioBase = precioBase;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

}
