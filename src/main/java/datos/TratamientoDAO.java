/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.List;
import modelo.Tratamientos;

/**
 *
 * @author jonyx
 */
public class TratamientoDAO {
    private final MongoCollection<Tratamientos> coleccion;
    
    public TratamientoDAO(){
        MongoDatabase db = ConexionBD.getDatabase();
        this.coleccion = db.getCollection("Tratamientos", Tratamientos.class);
    }
    
    public boolean insertarTratamiento(Tratamientos nuevoTratamiento){
        try{
            coleccion.insertOne(nuevoTratamiento);
            System.out.println("Tratamientos insertado correctamente.");
            return true;
        }catch(Exception e){
            System.err.println("Error al insertar tratamiento: "+e.getMessage());
            return false;
        }
    }
    
    public boolean actualizarTratamiento(Tratamientos actTratamiento){
        try{
            var filtro = Filters.eq("codProducto",actTratamiento.getCodProducto());
            var resultado = coleccion.replaceOne(filtro, actTratamiento);
            
            return resultado.getMatchedCount() > 0;
        }catch(Exception e){
            System.err.println("Error al actualizar doctor: "+e.getMessage());
            return false;
        }
    }
    
    public List <Tratamientos> obtenerTodos(){
        List <Tratamientos> lista = new ArrayList<>();
        try{
            coleccion.find().into(lista);
        }catch(Exception e){
            System.err.println();
        }
        return lista;
    }
    
    public Tratamientos buscarPorCodigo(int codProducto){
        try{
            return coleccion.find(Filters.eq("codProducto",codProducto)).first();
        }catch(Exception e){
            System.err.println("Producto no encontrado: "+e.getMessage());
            return null;
        }
    }
    
    public Tratamientos buscarPorTipo(String tipo){
        try{
            return coleccion.find(Filters.eq("tipo",tipo)).first();
        }catch(Exception e){
            System.err.println("Producto no encontrado: "+e.getMessage());
            return null;
        }
    }
}
