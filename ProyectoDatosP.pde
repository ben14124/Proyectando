//===================================================
//Juan Diego Benítez Cáceres
//Carne 14124
//María Belén Hernández Batres
//Carne14361
//José Alejandro Rivera García
//Carne 14213
//Daniela Izabel Pocasangre Arévalo
//Carne14162

//Proyecto 1 - Algoritmos y estructura de datos
//Prototipo #1
//===================================================

import processing.serial.*;
Serial myPort;  // Create object from Serial class
//String val;     // Data received from the serial port
int val;

Serial Arduino;
int lectura = 0;
//boolean estado = false;
boolean estadoLED1 = false;
boolean estadoLED2 = false;
boolean estadoLED3 = false;

PrintWriter output;

int mandar;
//colores switches
//-inferiores
int s1 = 0;
int s2 = 0;
int s3 = 0;
int s4 = 0;
//-superiores
int s11 = 250;
int s22 = 250;
int s33 = 250;
int s44 = 250;
//colores de los botones
color rojo = color(250,20,4);
color verde = color(30,250,20);
color color1 = rojo;
color color2 = rojo;
color color3 =  rojo;
color color4 =  rojo;
color color5 =  rojo;
color color6 =  rojo;
//posiciones de los switches
float off = 323;
float on = 323+35.75;
float pos1 = off;
float pos2 = off;
float pos3 = off;
float pos4 = off;
float pos5 = off;
float pos6 = off;
boolean bulean=true;
//posiciones scroll
int PmouseX = 543;
int PmouseY = 625;
color azul = color(0,0,180);
String iolvide = "iOlvidé";
String tele="Television";
String regadera = "Regadera";
String luz1 = "Luz cuarto";
String luz2 = "Luz sala";
String luz3 = "Luz cocina";
String puerta = "Puerta abierta";
float posX = 370.5;
float posiX = 175.5;
int[] valores = new int[6];
int[] alertas = new int[4];
int[] tags = new int[4];

//Colores para los cuadros con texto
color amarillo = color(255,255,10);
color blanco = color(255,255,255);
color base1 = blanco;
color base2 = blanco;
color base3 = blanco;
color base4 = blanco;
color base5 = blanco;
color base6 = blanco;

color color10 =  rojo;
color color11 =  rojo;
color color12 =  rojo;
color color13 =  rojo;

color colorTags = rojo;

String salidaTags = " ¡Aún hay objetos\n      en la casa!";

void setup(){
  size(800,600); //tamano de la ventana
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  output = createWriter("datosCasa.txt"); 
}

void draw(){
  background(0); //color del fondo
  stroke(10);
  strokeWeight(0.5);
  
  //Rectangulo grande
  fill (250);
  rect(150,100,300,400,20);
  //Rectangulo grande
  fill (250);
  rect(595,100,100,400,20);  

  //Rectangulos de cada apartado
  fill(base2);
  rect(175.5,181.5,249,53,10); //2
  fill(base3);
  rect(175.5,241.5,249,53,10); //3
  fill(base4);
  rect(175.5,301.5,249,53,10); //4
  fill(base5);
  rect(175.5,361.5,249,53,10); //5
  
  //Bases switches*/
  strokeWeight(1);
  fill(color(250));
  rect(318,185.5,101,45,10); //2
  rect(318,245.5,101,45,10); //3
  rect(318,305.5,101,45,10); //4
  rect(318,365.5,101,45,10); //5
  
  //Slot switches
  fill(color2);
  rect(323,190.5,91.5,35,10); //2
  fill(color3);
  rect(323,250.5,91.5,35,10); //3
  fill(color4);
  rect(323,310.5,91.5,35,10); //4 
  fill(color5);
  rect(323,370.5,91.5,35,10); //5 
  
  //Switches
  //para mover el switch se suma 35.75
  fill(color(250));
  //rect(pos2,190.5,55.75,35,10); //2 regadera
  rect(pos3,250.5,55.75,35,10); //3
  rect(pos4,310.5,55.75,35,10); //4 
  rect(pos5,370.5,55.75,35,10); //5 
  
  fill(color10); //rojo
  rect(600,130.5,91.5,35,10); //1
  
  fill(color11); //rojo
  rect(600,230.5,91.5,35,10); //1
  
  fill(color12); //rojo
  rect(600,330.5,91.5,35,10); //1
  
  fill(color13); //rojo
  rect(600,430.5,91.5,35,10); //1
  
  //iOlvide
  fill(250); //color
  textSize(45); //tamanio
  text(iolvide,300.5,75); //posicion
  
    //regadera
  fill(0); //color
  textSize(20); //tamanio
  text(regadera,200,212.5); //posicion
  
    //luz1
  fill(0); //color
  textSize(20); //tamanio
  text(luz1,200,272.5); //posicion
  
    //luz2
  fill(0); //color
  textSize(20); //tamanio
  text(luz2,200,332.5); //posicion
  
    //luz3
  fill(0); //color
  textSize(20); //tamanio
  text(luz3,200,392.5); //posicion
 
  
  //Celular
  fill(0); //color
  textSize(15); //tamanio
  text("CELULAR",613,152.5); //posicion  
  
  //Lentes
  fill(0); //color
  textSize(15); //tamanio
  text("LENTES",619,252.5); //posicion    
  
  //Reloj
  fill(0); //color
  textSize(15); //tamanio
  text("RELOJ",625,352.5); //posicion      
  
    //Compu
  fill(0); //color
  textSize(15); //tamanio
  text("LAPTOP",617,454); //posicion  
  
  fill(colorTags); //color de las tags
  textSize(22); //tamanio
  text(salidaTags,545, 50); //posicion
  
  //Lectura de datos recibidos desde el arduino
  
  if (myPort.available()>0) { //Si hay datos disponibles
    int valrecibido = myPort.read();
    //Si se recibio el dato del PIR 1
    if ((valrecibido == 8) || (valrecibido == 80)){
      valores[0] = valrecibido;
      if (valores[0] == 8){
         color3=verde;
         pos3=on;
         estadoLED1 = true;
      }
      else {
        color3=rojo;
        pos3=off;
        estadoLED1 = false;
        base3 = blanco;
      }
    }
    //  LED1
    if ((valrecibido == 5) || (valrecibido == 50)){
      valores[4] = valrecibido;
    }
    //LED2
    else if ((valrecibido == 2) || (valrecibido == 20)){
      valores[1] = valrecibido;
    }
    else if (valrecibido==61){
      color10 = verde;
      tags[0] = 1;
    }
    
    else if (valrecibido==82){
      color11 = verde;
      tags[1] = 1;
    }
    
    else if (valrecibido==93){
      color12 = verde;
      tags[2] = 1;
    }
    
    else if (valrecibido==34){
      color13 = verde;
      tags[3] = 1;
    }
    //LED3
    else if ((valrecibido == 3) || (valrecibido == 30)){
      valores[2] = valrecibido;
    }
    //Si se recibio el dato del sensor de flujo
    else if ((valrecibido == 4) || (valrecibido == 40)){
      valores[3] = valrecibido;
    }
    
    //LED1 EN TXT
    if (valores[4] == 5){
         output.println("LED1 On");  // Write the coordinate to the file
         color3=verde;
         pos3=on;
         estadoLED1 = true;
      }
      else {
        output.println("LED1 Off");  // Write the coordinate to the file
        color3=rojo;
        pos3=off;
        estadoLED1 = false;
        base3 = blanco;
      }
      
      //LED 2 EN TXT
      if (valores[1] == 2){
         output.println("LED2 On");  // Write the coordinate to the file
         color4=verde;
         pos4=on;
         estadoLED2 = true;
      }
      else {
        output.println("LED2 Off");  // Write the coordinate to the file
        color4=rojo;
        pos4=off;
        estadoLED2 = false;
        base4 = blanco;
      }
      
      
      //LED3 EN TXT
      if (valores[2] == 3){
       output.println("LED3 Off");  // Write the coordinate to the file
       color5=verde;
       pos5=on;
       estadoLED3 = true;
      }
      else {
      output.println("LED3 On");  // Write the coordinate to the file
      color5=rojo;
      pos5=off;
      estadoLED3 = false;
      base5 = blanco;
      }
      
      
      //FLUJO EN TXT 
    if (valores[3] == 4){
       output.println("Flujo On");  // Write the coordinate to the file
       color2=verde;
       pos2=on;
      }
      else {
      output.println("Flujo Off");  // Write the coordinate to the file
      color2=rojo;
      pos2=off;
      }
      
      
      
    //Alertas
    
    if ((valrecibido == 11) || (valrecibido == 12)){
      alertas[0] = valrecibido;
    }
    
    if ((valrecibido == 21) || (valrecibido == 22)){
      alertas[1] = valrecibido;
    }
    
    if ((valrecibido == 31) || (valrecibido == 32)){
      alertas[2] = valrecibido;
    }
    
    
    for (int i = 0; i<6; i++){
      println("valores " + i + " es " + valores[i]);
    }
    
    println("Valor recibido: " + valrecibido);
    
    for (int j = 0; j<4; j++){
      println("alertas " + j + " es " + alertas[j]);
    }
    
    int cuentaTags = 0;
    
    for (int k = 0; k<4; k++){
      if(tags[k]==1){
        cuentaTags++;
      }
    }
    
    if(cuentaTags==4){ //Si ya se pasaron todos los objetos por el lector NFC
      if((valores[1]>10) && (valores[2]>10) && (valores[3]>10) && (valores[4]>10)){ //Si todo esta apagado se indica que ya esta todo para salir
        salidaTags = "      ¡Todo listo\n       para salir!";
        colorTags = verde; //Se cambia a color verde el texto de las tags
      }
      else { //Si ya se pasaron todas las tags, pero aun hay luces encendidas, se indica.
        salidaTags = "¡Objetos completos, \n luces encendidas!";
        colorTags = amarillo;
      }
    }
    else if (cuentaTags!= 4){ //Si aun no se han pasado todas las tags, se indica que aun hay algo olvidado.
      colorTags = rojo;
      salidaTags = " ¡Aún hay objetos\n      en la casa!";
    }
    
    //LED 1
    if (alertas[0] == 12){
      println("LED1 lleva mas de 10 segundos encendido");
      base3 = amarillo;
      //Accion
    }
    
    else if (alertas[0] == 11){
      base3 = blanco;
      //Si modificaron algo por dejarlo encendido, lo tienen que regresar cuando se apague
    }
    
    //LED2
    if (alertas[1] == 22){
      base4 = amarillo;
      println("LED2 lleva mas de 10 segundos encendido");
      //Accion
    }
    
    else if (alertas[1] == 21){
      base4 = blanco;
      //Si modificaron algo por dejarlo encendido, lo tienen que regresar cuando se apague
    }
    
    //LED3
    if (alertas[2] == 32){
      base5 = amarillo;
      println("LED3 lleva mas de 10 segundos encendido");
      //Accion
    }
  
    else if (alertas[2] == 31){
      base5 = blanco;
      //Si modificaron algo por dejarlo encendido, lo tienen que regresar cuando se apague
    }
    
  }
  myPort.clear(); //limpiamos el bufer
  
}

void mouseClicked(){
  
  //Switch luz cuarto
  if((mouseX>318)&&(mouseX<419)&&(mouseY>245.5)&&(mouseY<290.5)){
    if (valores[4]==5){ //Si esta encendido y lo queremos apagar
      estadoLED1 = false;
      println("Apagando LED1");
       myPort.write(50); //este 10 en el arduino significa que hay que
    }
    else if (valores[4]==50){ //Si esta apagado y lo queremos encender
      estadoLED1 = true;
       println("Encendiendo LED1");
       myPort.write(5); //este 20 en el arduino significa que
    }

   }
   

  //Switch luz sala
   if((mouseX>318)&&(mouseX<419)&&(mouseY>305.5)&&(mouseY<350.5)){
    if (valores[1]==2){ //Si esta encendido y lo queremos apagar
      estadoLED2 = false;
      println("Apagando LED2");
       myPort.write(20); //este 10 en el arduino significa que hay que
    }
    else if (valores[1]==20){ //Si esta apagado y lo queremos encender
      estadoLED2 = true;
       println("Encendiendo LED2");
       myPort.write(2); //este 20 en el arduino significa que
    }    
   }
   

   //Switch luz cocina
   if((mouseX>318)&&(mouseX<419)&&(mouseY>365.5)&&(mouseY<410.5)){
    if (valores[2]==3){ //Si esta encendido y lo queremos apagar
      estadoLED3 = false;
      println("Apagando LED3");
       myPort.write(30); //este 10 en el arduino significa que hay que
    }
    else if (valores[2]==30){ //Si esta apagado y lo queremos encender
      estadoLED3 = true;
       println("Encendiendo LED3");
       myPort.write(3); //este 20 en el arduino significa que
    }
    
   }
   
   //Puerta abierta
  if((mouseX>318)&&(mouseX<419)&&(mouseY>425.5)&&(mouseY<470.5)){
  }
   
}

void keyPressed() {
  output.flush();  // Writes the remaining data to the file
  output.println("4");
  output.close();  // Finishes the file
  exit();  // Stops the program
}
