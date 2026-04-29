/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

/**
 *
 * @author jonyx
 */
public class NombreCompleto {
    private String nombre;
    private String apPat;
    private String apMat;

    public NombreCompleto() {
    }

    public NombreCompleto(String nombre, String apPat, String apMat) {
        this.nombre = nombre;
        this.apPat = apPat;
        this.apMat = apMat;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApPat() {
        return apPat;
    }

    public void setApPat(String apPat) {
        this.apPat = apPat;
    }

    public String getApMat() {
        return apMat;
    }

    public void setApMat(String apMat) {
        this.apMat = apMat;
    }
    
}
