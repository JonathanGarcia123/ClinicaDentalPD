/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package datos;

import com.mongodb.MongoException;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import static org.bson.codecs.configuration.CodecRegistries.fromRegistries;
import static org.bson.codecs.configuration.CodecRegistries.fromProviders;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.codecs.pojo.PojoCodecProvider;
import com.mongodb.MongoClientSettings;
/**
 *
 * @author jonyx
 */
public class ConexionBD {
    private static final String URI = System.getenv("MONGO_URI");
    private static MongoClient mongoClient = null;
    private static MongoDatabase database = null;
    
    public static MongoDatabase getDatabase(){
        if(database==null){
            try{
                CodecRegistry pojoCodecRegistry = fromRegistries(
                        MongoClientSettings.getDefaultCodecRegistry(),
                        fromProviders(PojoCodecProvider.builder().automatic(true).build())
                );
                
                MongoClientSettings settings = MongoClientSettings.builder()
                        .applyConnectionString(new com.mongodb.ConnectionString(URI))
                        .codecRegistry(pojoCodecRegistry)
                        .build();
                
                mongoClient = MongoClients.create(settings);
                database = mongoClient.getDatabase("ClinicaDentalPD");
            }catch(MongoException e){
                System.err.println("Error Mongo: "+e.getMessage());
            }catch(Exception e){
                System.err.println("Error general: "+e.getMessage());
            }
        }
        return database;
    }
    
    public static void cerrarConexion(){
        if(mongoClient != null){
            mongoClient.close();
            System.out.println("Conexion cerrada.");
        }
    }
}
