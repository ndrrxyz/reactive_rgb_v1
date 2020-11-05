import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioInput in;
Arduino arduino;


int greenLED = 6;
int redLED = 5;
int blueLED = 3;
int mode = 1;

float[]values = new float[11];
int cycles = 0;
int avgValues;
int multp;

void setup()
{
  size(512, 200, P3D);

  minim = new Minim(this);
   arduino = new Arduino(this, Arduino.list()[2], 57600);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO);
  
  arduino.pinMode(greenLED, Arduino.OUTPUT);    
  arduino.pinMode(redLED, Arduino.OUTPUT);  
  arduino.pinMode(blueLED, Arduino.OUTPUT);  
}

void draw()
{
  
  background(0);
  stroke(255);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line( i, 50 + in.left.get(i)*100, i+1, 50 + in.left.get(i+1)*100 );
    line( i, 150 + in.right.get(i)*100, i+1, 150 + in.right.get(i+1)*100 );
  }
  
  if(mode == 1){
  
float r = (in.left.level()*2000)+10;
float l = (in.right.level()*2000)+10;
  
  
  float aRL = ((r + l) / 2f);

  values[cycles] = aRL;

   if(aRL > 255){
   aRL = 255;
   }

  //System.out.println("Cycles: "+cycles);
  //System.out.println(aRL);
  arduino.analogWrite(blueLED,Math.round(aRL)+multp);

   
  
  cycles++;
  if(cycles > 10){
    cycles = 0;
    }
  }else{
     for(int iU = 0;iU<256;iU++){
     delay(20);
     arduino.analogWrite(redLED,iU);
     if(iU == 255){
        for(int iD = 255;iD>=0;iD--){
        delay(20);
        arduino.analogWrite(redLED,iD);
   }
     }
   }


  }
}

void stop() {
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}