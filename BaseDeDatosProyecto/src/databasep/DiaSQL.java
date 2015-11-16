/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Ma. Belen
 */
package databasep;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
public class DiaSQL {
   private final String tabla = "dias";
   public void guardar(Connection conexion, Dia dia) throws SQLException{
      try{
         PreparedStatement consulta;
         if(dia.getId() == null){
            consulta = conexion.prepareStatement("INSERT INTO " + this.tabla + "(cuarto, sala, cocina, flujo) VALUES(?, ?, ?, ?)");
            consulta.setInt(1, dia.getCuarto());
            consulta.setInt(2, dia.getSala());
            consulta.setInt(3, dia.getCocina());
            consulta.setInt(4, dia.getFlujo());
         }else{
            consulta = conexion.prepareStatement("UPDATE " + this.tabla + " SET cuarto = ?, sala = ?, cocina = ?, flujo = ? WHERE id = ?");
            consulta.setInt(1, dia.getCuarto());
            consulta.setInt(2, dia.getSala());
            consulta.setInt(3, dia.getCocina());
            consulta.setInt(4, dia.getFlujo());
            consulta.setInt(5, dia.getId());
         }
         consulta.executeUpdate();
      }catch(SQLException ex){
         throw new SQLException(ex);
      }
   }
   public Dia recuperarPorId(Connection conexion, int id) throws SQLException {
      Dia dia = null;
      try{
         PreparedStatement consulta = conexion.prepareStatement("SELECT cuarto, sala, cocina, flujo " + this.tabla + " WHERE id = ?" );
         consulta.setInt(1, id);
         ResultSet resultado = consulta.executeQuery();
         while(resultado.next()){
            dia = new Dia(id, resultado.getInt("cuarto"), resultado.getInt("sala"), resultado.getInt("cocina"), resultado.getInt("flujo"));
         }
      }catch(SQLException ex){
         throw new SQLException(ex);
      }
      return dia;
   }
   public void eliminar(Connection conexion, Dia dia) throws SQLException{
      try{
         PreparedStatement consulta = conexion.prepareStatement("DELETE FROM " + this.tabla + " WHERE id = ?");
         consulta.setInt(1, dia.getId());
         consulta.executeUpdate();
      }catch(SQLException ex){
         throw new SQLException(ex);
      }
   }
   public List<Dia> recuperarTodas(Connection conexion) throws SQLException{
      List<Dia> dias = new ArrayList<>();
      try{
         PreparedStatement consulta = conexion.prepareStatement("SELECT id, cuarto, sala, cocina, flujo FROM " + this.tabla + " ORDER BY id");
         ResultSet resultado = consulta.executeQuery();
         while(resultado.next()){
            dias.add(new Dia(resultado.getInt("id"), resultado.getInt("cuarto"), resultado.getInt("sala"), resultado.getInt("cocina"), resultado.getInt("flujo")));
         }
      }catch(SQLException ex){
         throw new SQLException(ex);
      }
      return dias;
   }
   
   //Agregado
   public Dia recuperarUltima() throws SQLException {
      List<Dia> dias = null;
      Dia dia = null;
      try {
            dias= this.recuperarTodas(Conexion.obtener());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DatabaseP.class.getName()).log(Level.SEVERE, null, ex);
        }
      dia= dias.get(dias.size()-1);
      return dia;
   }
   
   //Agregado
   public void eliminarUltima() throws SQLException{
      List<Dia> dias = null;
      Dia dia = null;
      try {
            dias= this.recuperarTodas(Conexion.obtener());
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DatabaseP.class.getName()).log(Level.SEVERE, null, ex);
        }
      PreparedStatement consulta;
       try {
           consulta = Conexion.obtener().prepareStatement("DELETE FROM " + this.tabla + " WHERE id = ?");
           consulta.setInt(1, dias.size()-1);
           consulta.executeUpdate();
       } catch (ClassNotFoundException ex) {
           Logger.getLogger(DiaSQL.class.getName()).log(Level.SEVERE, null, ex);
       }
   }
}