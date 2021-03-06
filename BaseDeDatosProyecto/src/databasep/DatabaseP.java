/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package databasep;

/*import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;
//import datechooser.beans.DateChooserPanel;
import java.sql.Connection;
import java.sql.ResultSet;

import java.sql.SQLException;*/
/**
 *
 * @author Ma. Belen
 */

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class DatabaseP {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) throws SQLException{
        
       
        System.out.println("Esperando registro...");
        
        File fileCasa= new File ("datosCasa.txt");
        int cuarto= 0;
        int sala= 0;
        int cocina= 0;
        int flujo= 0;
        List<Dia> dias = null;
        String verificar = "no";
        
        //Conteo de datos
        
            while (!verificar.equals("4")){
                try{
                BufferedReader br = new BufferedReader(new FileReader(fileCasa));
                try { 
                    for(String line; (line = br.readLine()) != null; ){
                        verificar=line;
                    }  
                }
                catch(Exception e){
                }
            }
            catch(Exception e){

            }
        }
            
        try{
            BufferedReader br = new BufferedReader(new FileReader(fileCasa));
            try { 
                for(String line; (line = br.readLine()) != null; ){
                    String[] entry;
                    entry= line.split(" ");
                    if (entry[1].equals("On")){
                        if (entry[0].equals("LED1")){
                            cuarto++;
                        }
                        if (entry[0].equals("LED2")){
                            sala++;
                        }
                        if (entry[0].equals("LED3")){
                            cocina++;
                        }
                        if (entry[0].equals("Flujo")){
                            flujo++;
                        }
                    }
                }  
            }
            catch(Exception e){
            }
        }
        catch(Exception e){
            
        }
        
        System.out.println("Registro ingresado exitosamente.");
        //Ingreso de datos del dia
        Dia dia = new Dia();
        dia.setCuarto(cuarto);
        dia.setSala(sala);
        dia.setCocina(cocina);
        dia.setFlujo(flujo);
        
        //Ingreso de datos a la base de datos
        DiaSQL sql = new DiaSQL();
        
        try{
            sql.guardar(Conexion.obtener(), dia);
        }catch(SQLException ex){
            System.out.println(ex.getMessage());
        }catch(ClassNotFoundException ex){
            System.out.println(ex);
        }
        
        System.out.println("\nTODOS LOS REGISTROS:");
        //Obtener todas las entradas de la base de datos.
        try {
            dias= sql.recuperarTodas(Conexion.obtener());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DatabaseP.class.getName()).log(Level.SEVERE, null, ex);
        }
        for (int x=0; x<dias.size(); x++){
            System.out.println(dias.get(x).toString());
        }
        System.out.println("\nHOY:");
        //Obtener ultima entrada
        System.out.println(sql.recuperarUltima());
        
        //se inicializa la interfaz grafica
       JFrame frame = new JFrame(); //se crea un JFrame
       frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE); //el frame para que se cierre normalmente
       frame.getContentPane().add(new ConsumoGUI()); //se agrega el contenido del panel
       frame.pack(); //empaqueta
       frame.setVisible(true); //se hace visible
    }
    
}
