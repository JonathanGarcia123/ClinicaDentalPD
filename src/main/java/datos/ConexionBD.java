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
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author jonyx
 */

public class ConexionBD {
    // 1. Cambiamos la asignación para que llame al nuevo método extractor
    private static final String URI = cargarUriLocal();
    private static MongoClient mongoClient = null;
    private static MongoDatabase database = null;
    
    // 2. Método interno para leer el archivo config.properties en proyectos Maven
    private static String cargarUriLocal() {
        Properties prop = new Properties();
        // Buscamos el archivo dentro del contenedor de recursos de Maven
        try (InputStream input = ConexionBD.class.getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                System.err.println("ALERTA: No se encontró el archivo 'config.properties' en src/main/resources/");
                return null;
            }
            prop.load(input);
            return prop.getProperty("MONGO_URI");
        } catch (IOException ex) {
            System.err.println("Error grave al cargar la configuración: " + ex.getMessage());
            return null;
        }
    }
    
    public static MongoDatabase getDatabase(){
        if(database == null){
            try{
                if (URI == null || URI.isEmpty()) {
                    throw new RuntimeException("La URI de MongoDB es nula o está vacía. Revisa tu archivo config.properties");
                }

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
                System.out.println("Conexión exitosa a MongoDB Atlas usando propiedades locales.");
            }catch(MongoException e){
                System.err.println("Error Mongo: " + e.getMessage());
            }catch(Exception e){
                System.err.println("Error general en Conexión: " + e.getMessage());
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
