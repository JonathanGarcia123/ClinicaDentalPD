/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import modelo.Agenda;
import modelo.Doctores;

/**
 *
 * @author jonyx
 */
public class AgendaDAO {
    private final MongoCollection<Agenda> coleccion;
    
    public AgendaDAO(){
        MongoDatabase db = ConexionBD.getDatabase();
        this.coleccion = db.getCollection("Agenda", Agenda.class);
    }
    
    public boolean insertarCita(Agenda nuevaCita){
        try{
            coleccion.insertOne(nuevaCita);
            System.out.println("Cita agregada correctamente.");
            return true;
        }catch(Exception e){
            System.err.println("Error al insertar cita: "+e.getMessage());
            return false;
        }
    }
    
    public List <Agenda> obtenerTodos() {
        List <Agenda> lista = new ArrayList<>();
        try {
            coleccion.find().into(lista);
        } catch (Exception e) {
            System.err.println("Error al obtener la lista de citas: " + e.getMessage());
        }
        return lista;
    }
    
    public List<Agenda> obtenerPorPaciente(String correoPaciente) {
        List<Agenda> lista = new ArrayList<>();
        try {
            
            var filtro = Filters.eq("fkPaciente.email", correoPaciente);

            coleccion.find(filtro).into(lista);
        } catch (Exception e) {
            System.err.println("Error al obtener la lista de citas en AgendaDAO: " + e.getMessage());
        }
        return lista;
    }
    
    public boolean verificarDisponibilidad(int cedulaDoc, Date fecha, String hora) {
        try {
            Agenda cita = coleccion.find(Filters.and(
                Filters.eq("fkDoctor.cedulaProf", cedulaDoc),
                Filters.eq("fecha", fecha),
                Filters.eq("hora", hora),
                Filters.eq("status", "Activo")
            )).first();

            return cita == null;
        } catch (Exception e) {
            return false;
        }
    }
    
}
