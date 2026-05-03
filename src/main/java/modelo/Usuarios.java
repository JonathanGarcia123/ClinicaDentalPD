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
public class Usuarios {
    private ObjectId idUsuario;
    private String email;
    private String password;
    private Roles fkRol;
    private ObjectId datosPersona;

    public Usuarios() {
    }

    public Usuarios(ObjectId idUsuario, String email, String password, Roles fkRol, ObjectId datosPersona) {
        this.idUsuario = idUsuario;
        this.email = email;
        this.password = password;
        this.fkRol = fkRol;
        this.datosPersona = datosPersona;
    }

    public ObjectId getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(ObjectId idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Roles getFkRol() {
        return fkRol;
    }

    public void setFkRol(Roles fkRol) {
        this.fkRol = fkRol;
    }

    public ObjectId getDatosPersona() {
        return datosPersona;
    }

    public void setDatosPersona(ObjectId datosPersona) {
        this.datosPersona = datosPersona;
    }

    

}
