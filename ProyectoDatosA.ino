//===================================================
//Juan Diego Benitez Caceres
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

// Variables a utilizar
int analogPin = 3; //vamos a leer el pin analogo 3
int ledPin = 10;   //salida 13 para el LED
int ledPin2 = 12;
int ledPin3 = 11;
int PIR1 = 6;   //En el pin digital 2 va a estar conectado el sensor PIR
int PIR2 = 3;
int PIR3 = 4;
int val = 0;         //variable para la lectura del estado del pin
int val2 = 0;
int val3 = 0;
float rpm1=0;
unsigned long lastmillis1 = 0;
long previousMillis = 0;        // will store last time LED was updated
long interval = 1000;           // interval at which to blink (milliseconds)
long distancia;
long tiempo;
int estadoNFC = 0;


boolean estadoLED1;
boolean estadoLED2;
boolean estadoLED3;
boolean estadoFlujo;
volatile int rpmcontador = 0;//see http://arduino.cc/en/Reference/Volatile
int valores[4];
int alertas[4];


int tiempoLED1 = 0;
int tiempoLED2 = 0;
int tiempoLED3 = 0;

#if 0
#include <SPI.h>
#include <PN532_SPI.h>
#include <PN532.h>
#include <NfcAdapter.h>

PN532_SPI pn532spi(SPI, 10);
NfcAdapter nfc = NfcAdapter(pn532spi);
#else

#include <Wire.h>
#include <PN532_I2C.h>
#include <PN532.h>
#include <NfcAdapter.h>

PN532_I2C pn532_i2c(Wire);
NfcAdapter nfc = NfcAdapter(pn532_i2c);
#endif

void setup() {
 Serial.begin(115200); //Processing tambien esta a 9600 para que esten sincronizados
  //Ponemos los output de los leds
 nfc.begin();
 pinMode(ledPin, OUTPUT);
 pinMode(ledPin2, OUTPUT);
 pinMode(ledPin3, OUTPUT);
 //Ponemos los input de los sensores
 pinMode(PIR1, INPUT);
 pinMode(PIR2, INPUT);
 pinMode(PIR3, INPUT);
 pinMode(40, OUTPUT); /*activación del pin 40 como salida: para el pulso ultrasónico*/
 pinMode(41, INPUT); /*activación del pin 41 como entrada: tiempo del rebote del ultrasonido*/
 valores[3] = 40;
 attachInterrupt(0, rpm_fan1, FALLING);//interrupt cero (0) is on pin 2. FALLING for when the pin goes from high to low.

}

void loop(){
 int num=Serial.read();
 //Si se recibio alguna modificacion del LED1
 if (num==50){
   digitalWrite(ledPin, LOW);
   estadoLED1 = false;
 }
 else if (num==5){
   digitalWrite(ledPin, HIGH);
   estadoLED1 = true;
 }
 
 //Si se recibio alguna modificacion del LED2
 if (num==20){
   digitalWrite(ledPin2, LOW);
   estadoLED2 = false;
 }
 else if (num==2){
   digitalWrite(ledPin2, HIGH);
   estadoLED2 = true;
 }
 
 //Si se recibio alguna modificacion del LED3
 if (num==30){
   digitalWrite(ledPin3,LOW);
   estadoLED3 = false;
 }
 else if (num==3){
   digitalWrite(ledPin3, HIGH);
   estadoLED3 = true;
 }
 
 int estadoTag = ultrasonico();
 //int estadoTag = 0;
 int retornoTag = 0;
 if (estadoTag == 1){
  retornoTag = leerTag();
 }
 
 if(retornoTag == 1){
   Serial.write(61);
 }
 
  else if(retornoTag == 2){
   Serial.write(82);
 }
 
  else if(retornoTag == 3){
   Serial.write(93);
 }
 
  else if(retornoTag == 4){
   Serial.write(34);
 }
 
 //Lectura de los sensores PIR
 val = digitalRead(PIR1);  // read input value
 if (val == HIGH) {            // check if the input is HIGH
    digitalWrite(ledPin, HIGH);  // turn LED ON

    if (estadoLED1 == false) {
      // we have just turned on
      // We only want to print on the output change, not state
      estadoLED1 = true;
    }
  } 
  else { //si lo quisieramos apagar cuando ya no se detecte movimiento, seria este else
    //digitalWrite(ledPin, LOW);  // turn LED ON
  }
  
   val2 = digitalRead(PIR2);  // read input value
  if (val2 == HIGH) {            // check if the input is HIGH
    digitalWrite(ledPin2, HIGH);  // turn LED ON
    
    if (estadoLED2 == false) {
      // we have just turned on
      //Serial.write(1);
      // We only want to print on the output change, not state
      estadoLED2 = true;
    }
    
  } 
  else { //si lo quisieramos apagar cuando ya no se detecte movimiento, seria este else
    //digitalWrite(ledPin2, LOW);  // turn LED ON
  }
  
  val3 = digitalRead(PIR3);  // read input value
  if (val3 == HIGH) {            // check if the input is HIGH
    digitalWrite(ledPin3, HIGH);  // turn LED ON
    
    
    if (estadoLED3 == false) {
      // we have just turned on
      //Serial.write(1);
      // We only want to print on the output change, not state
      estadoLED3 = true;
    }
    //----valores[2] = 3;
  } 
  else { //si lo quisieramos apagar cuando ya no se detecte movimiento, seria este else
    //digitalWrite(ledPin3, LOW);  // turn LED ON
  }
  
  if ((valores[3] == 40) && (estadoFlujo == false)){
   // SensorFlujo();
  }
  else if ((valores[3] == 4) && (estadoFlujo == true)){
    unsigned long currentMillis = millis();
    if(currentMillis - previousMillis > interval) {
      // save the last time you blinked the LED 
      previousMillis = currentMillis;   
      //SensorFlujo();
    }
  }  
  
  //Guardado de datos en el arreglo a mandar:
  //PIR 1
  if (estadoLED1 == true){
    valores[0] = 5;
  }
  else if (estadoLED1 == false){
    valores[0] = 50;
  }
  //PIR 2
  if (estadoLED2 == true){
    valores[1] = 2;
  }
  else if (estadoLED2 == false){
    valores[1] = 20;
  }
  //PIR 3
  if (estadoLED3 == true){
    valores[2] = 3;
  }
  else if (estadoLED3 == false){
    valores[2] = 30;
  }
  
  for(int i=0;i<4;i++){
    //Serial.print(valores[i]);
    Serial.write(valores[i]);
  }
  
  
  //Alertas
  if(estadoLED1 == true){
  tiempoLED1++;
  //Serial.println(tiempoLED1);
    if (tiempoLED1 == 100){
      alertas[0] = 12; //siento que se puede confundir con un 1..
    }
  }
  else if (estadoLED1 == false){
    tiempoLED1 = 0;
    alertas[0] = 11;
  }
  
  if(estadoLED2 == true){
  tiempoLED2++;
  //Serial.println(tiempoLED2);
    if (tiempoLED2 == 100){
      //Serial.println("Llegueee");
      alertas[1] = 22;
    }
  }
  else if (estadoLED2 == false){
    tiempoLED2 = 0;
    alertas[1] = 21;
  }
  //Este esta fallando por alguna razon.
  if(estadoLED3 == true){
  tiempoLED3++;
  //Serial.println(tiempoLED3);
    if (tiempoLED2 == 100){
      //Serial.println("Llegueee");
      alertas[2] = 32;
    }
  }
  else if (estadoLED3 == false){
    tiempoLED3 = 0;
    alertas[2] = 31;
  }
  
  //Mandado de alertas
  for(int j=0;j<4;j++){
    Serial.write(alertas[j]);
  }
  
  
}

void rpm_fan1(){ /* this code will be executed every time the interrupt 0 (pin2) gets low.*/
 rpmcontador++;
}

void SensorFlujo(){
   
   detachInterrupt(0);    //Disable interrupt when calculating 
   rpm1 = (rpmcontador * 60 / 7.5) * 0.264172;  /* Convert frequency to GPH, note: this works for one interruption per full rotation. For two interrups per full rotation use rpmcount * 30.*/
   lastmillis1 = millis(); // Uptade lasmillis
   attachInterrupt(0, rpm_fan1, FALLING); //enable interrupt  
   detachInterrupt(1);    //Disable interrupt when calculating 
   if(rpm1 > 0){
    valores[3] = 4; //hay movimiento del sensor
    estadoFlujo = true; //hay movimiento en el sensor
   }
   else{ //no hay movimiento
    valores[3] = 40;
    estadoFlujo = false; //no hay movimiento en el sensor
   }
   //Serial.print("GPH1 =\t"); //print the word "GPH1" and tab.
   //Serial.println(rpm1); // print the GPH value.  
   //Serial.println("..........................");  
   rpmcontador = 0; // Restart the RPM counter
}

int leerTag(){
  int retorno = 0;
  if (nfc.tagPresent())
  {
    NfcTag tag = nfc.read();
    tag.getTagType();
    tag.getUidString();

    if (tag.hasNdefMessage()) // every tag won't have a message
    {

      NdefMessage message = tag.getNdefMessage();
     message.getRecordCount();

      // cycle through the records, printing some info from each
      int recordCount = message.getRecordCount();
      for (int i = 0; i < recordCount; i++)
      {
        NdefRecord record = message.getRecord(i);
        // NdefRecord record = message[i]; // alternate syntax

        record.getTnf();
        record.getType(); // will be "" for TNF_EMPTY

        // The TNF and Type should be used to determine how your application processes the payload
        // There's no generic processing for the payload, it's returned as a byte[]
        int payloadLength = record.getPayloadLength();
        byte payload[payloadLength];
        record.getPayload(payload);
        
        byte celular[] = {0x00,0x43,0x65,0x6C,0x75,0x6C,0x61,0x72};
        byte lentes[] = {0x00,0x4C,0x65,0x6E,0x74,0x65,0x73,0x20,0x61,0x6E,0x74,0x65,0x6F,0x6A,0x6F,0x73};
        byte reloj[] = {0x00,0x52,0x65,0x6C,0x6F,0x6A};
        byte computadora[] = {0x00,0x43,0x6F,0x6D,0x70,0x75,0x74,0x61,0x64,0x6F,0x72,0x61};
        int contador[] = {0,0,0,0};
        
        
        //00 43 65 6C 75 6C 61 72
        for(int x = 0; x<6; x++){
          if (payload[x] == celular[x]){
            contador[0]++;            
          }
          
          if (payload[x] == lentes[x]){
            contador[1]++;            
          }
          
          if (payload[x] == reloj[x]){
            contador[2]++;            
          }
          
          if (payload[x] == computadora[x]){
            contador[3]++;            
          }
          
        }
        if (contador[0]==6){
          Serial.print("Celulashh");
          retorno = 1;
        }
        
        else if (contador[1]==6){
          Serial.print("Lentes");
          retorno = 2;
        }
        
        else if (contador[2]==6){
          Serial.print("Reloj");
          retorno = 3;
        }
        
        else if (contador[3]==6){
          Serial.print("Computadora");
          retorno = 4;
        }

      }
    }
  }
  delay(100);
  return retorno;
 // delay(3000);
}



int ultrasonico(){
  digitalWrite(40,LOW); /* Por cuestión de estabilización del sensor*/
  delayMicroseconds(5);
  digitalWrite(40, HIGH); /* envío del pulso ultrasónico*/
  delayMicroseconds(10);
  tiempo=pulseIn(41, HIGH); /* Función para medir la longitud del pulso entrante. Mide el tiempo que transcurrido entre el envío
  del pulso ultrasónico y cuando el sensor recibe el rebote, es decir: desde que el pin 12 empieza a recibir el rebote, HIGH, hasta que
  deja de hacerlo, LOW, la longitud del pulso entrante*/
  distancia= int(0.017*tiempo); /*fórmula para calcular la distancia obteniendo un valor entero*/
  if(distancia<=13){
    estadoNFC = 1;
  }
  else {
    estadoNFC = 0;
  }
  return estadoNFC;
}
