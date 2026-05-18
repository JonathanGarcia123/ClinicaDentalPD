/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.client.MongoCollection;
import modelo.Roles;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import datos.ConexionBD;
import org.bson.types.ObjectId;
/**
 *
 * @author jonyx
 */
public class RolesDAO {
    private final MongoCollection<Roles> coleccionRoles;
    
    public RolesDAO(){
        MongoDatabase db = ConexionBD.getDatabase();
        this.coleccionRoles = db.getCollection("Roles", Roles.class);
    }
    
    public Roles buscarPorNombre(String VerficarRol){
        Roles encontrado = coleccionRoles.find(eq("nombreRol",VerficarRol)).first();
        if(encontrado != null){
            return encontrado;
        }
        return null;
    }
    
    public void insertarRol(Roles nuevoRol){
        coleccionRoles.insertOne(nuevoRol);
    }
}