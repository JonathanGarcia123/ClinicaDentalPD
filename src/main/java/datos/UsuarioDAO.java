/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.eq;
import datos.ConexionBD;
import modelo.Usuarios; // Asegúrate de que tu modelo se llame así
import org.bson.types.ObjectId;

/**
 *
 * @author jonyx
 */
public class UsuarioDAO {
    private final MongoCollection<Usuarios> coleccion;
    
    public UsuarioDAO(){
        MongoDatabase db = ConexionBD.getDatabase();
        this.coleccion = db.getCollection("Usuarios", Usuarios.class);
    }
    
    public Usuarios login(String correoEntrada, String passEntrada){
        String passwordCifrada = datos.Encriptar.sha256(passEntrada);
        Usuarios encontrado = coleccion.find(eq("email",correoEntrada)).first();
        
        if(encontrado != null && encontrado.getPassword().equals(passwordCifrada)){
            return encontrado;
        }
        return null;
    }
    
    public boolean registrarUsuario(Usuarios nuevoUsuario){
        try{
            
            Usuarios existente = coleccion.find(eq("email",nuevoUsuario.getEmail())).first();
            
            if(existente != null){
                System.out.println("El correo ya se encuentra vinculado a una cuenta.");
                return false;
            }
            
            coleccion.insertOne(nuevoUsuario);
            return true;
        }catch(Exception e){
            System.err.println("Error al registrar usuario: "+e.getMessage());
            return false;
        }
    }
}