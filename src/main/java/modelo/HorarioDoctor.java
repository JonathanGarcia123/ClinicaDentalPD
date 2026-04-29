/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package modelo;

/**
 *
 * @author jonyx
 */
public class HorarioDoctor {
    private String Dia;
    private String horaInicio;
    private String horaSalida;

    public HorarioDoctor() {
    }

    public HorarioDoctor(String Dia, String horaInicio, String horaSalida) {
        this.Dia = Dia;
        this.horaInicio = horaInicio;
        this.horaSalida = horaSalida;
    }

    public String getDia() {
        return Dia;
    }

    public void setDia(String Dia) {
        this.Dia = Dia;
    }

    public String getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(String horaInicio) {
        this.horaInicio = horaInicio;
    }

    public String getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(String horaSalida) {
        this.horaSalida = horaSalida;
    }
    
    
}
