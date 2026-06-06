/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import jakarta.servlet.Filter;
import modelo.Doctores;

public class DoctoresDAO {
    private final MongoCollection<Doctores> coleccion;
    
    public DoctoresDAO(){
        MongoDatabase db = ConexionBD.getDatabase();
        this.coleccion = db.getCollection("Doctores", Doctores.class);
    }
    
    public boolean insertarDoctor(Doctores nuevoDoctor){
        try{
            coleccion.insertOne(nuevoDoctor);
            System.out.println("Doctor insertado correctamente.");
            return true;
        }catch(Exception e){
            System.out.println("Error al insertar paciente: "+e.getMessage());
            return false;
        }
    }
    
    public boolean actualizarDoctor(Doctores actDoctor){
        try{
            var filtro = Filters.eq("cedulaProf",actDoctor.getCedulaProf());
            var resultado = coleccion.replaceOne(filtro, actDoctor);
            
            return resultado.getMatchedCount() > 0;
        }catch(Exception e){
            System.err.println("Error al actualizar doctor: "+e.getMessage());
            return false;
        }
    }
}
