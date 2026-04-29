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
public class Roles {
    private ObjectId idRol;
    private String nombreRol;

    public Roles() {
    }

    public Roles(ObjectId idRol, String nombreRol) {
        this.idRol = idRol;
        this.nombreRol = nombreRol;
    }

    public ObjectId getIdRol() {
        return idRol;
    }

    public void setIdRol(ObjectId idRol) {
        this.idRol = idRol;
    }

    public String getNombreRol() {
        return nombreRol;
    }

    public void setNombreRol(String nombreRol) {
        this.nombreRol = nombreRol;
    }
    
}
