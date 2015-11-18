/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package databasep;

/**
 *
 * @author Ma. Belen
 */
public class Dia {
   private Integer id;
   private Integer cuarto;
   private Integer sala;
   private Integer cocina;
   private Integer flujo;
   public Dia() {
      this.id = null;
      this.cuarto = null;
      this.sala = null;
      this.cocina = null;
      this.flujo = null;
   }
   public Dia(Integer id, Integer cuarto, Integer sala, Integer cocina, Integer flujo) {
      this.id = id;
      this.cuarto = cuarto;
      this.sala = sala;
      this.cocina = cocina;
      this.flujo = flujo;
   }
   public Integer getId() {
        return id;
    }
   
   public void setId(Integer id) {
        this.id=id;
    }

    public Integer getCuarto() {
        return cuarto;
    }

    public void setCuarto(Integer cuarto) {
        this.cuarto = cuarto;
    }

    public Integer getSala() {
        return sala;
    }

    public void setSala(Integer sala) {
        this.sala = sala;
    }

    public Integer getCocina() {
        return cocina;
    }

    public void setCocina(Integer cocina) {
        this.cocina = cocina;
    }

    public Integer getFlujo() {
        return flujo;
    }

    public void setFlujo(Integer flujo) {
        this.flujo = flujo;
    }
    public String toString() {
      return "Dia "+id+"{cuarto=" + cuarto + ", sala=" + sala + ", cocina=" + cocina + ", flujo=" + flujo + '}';
   } 
}
