/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import static com.mongodb.client.model.Filters.eq;
import com.mongodb.client.model.ReplaceOptions;
import com.mongodb.client.model.Updates;
import jakarta.servlet.Filter;
import java.util.ArrayList;
import java.util.List;
import modelo.Pacientes;

/**
 *
 * @author jonyx
 */
public class PacientesDAO {
    private final MongoCollection<Pacientes> coleccion;
    
    public PacientesDAO(){
        MongoDatabase db = ConexionBD.getDatabase();
        this.coleccion = db.getCollection("Pacientes", Pacientes.class);
    }
    
    public boolean datosPaciente(Pacientes nuevoPaciente){
        try{
            var filtro = Filters.eq("curp", nuevoPaciente.getCurp());
            
            ReplaceOptions options = new ReplaceOptions().upsert(true);
            var resultado = coleccion.replaceOne(filtro, nuevoPaciente, options);
            
            if(resultado.getMatchedCount() > 0){
                System.out.println("Datos actualizados correctamente.");
            }else{
                System.out.println("Paciente registrado correctamente.");
            }
            
            return true;
        }catch(Exception e){
            System.err.println("Error al registrar paciente o actualizar: "+e.getMessage());
            return false;
        }
    }
    
    public Pacientes buscarPorEmail(String email) {
        try {

            return coleccion.find(Filters.eq("email", email)).first();
        } catch (Exception e) {
            System.err.println("Error al buscar paciente por email: " + e.getMessage());
            return null;
        }
    }
    
    public List <Pacientes> obtenerTodos() {
        List <Pacientes> lista = new ArrayList<>();
        try {
            coleccion.find().into(lista);
        } catch (Exception e) {
            System.err.println("Error al obtener la lista de pacientes: " + e.getMessage());
        }
        return lista;
    }
    
}
