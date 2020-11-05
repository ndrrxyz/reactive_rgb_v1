import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 
import ddf.minim.*; 
import ddf.minim.analysis.*; 
import cc.arduino.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Test_RealtimeAudio extends PApplet {






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

public void setup()
{
  

  minim = new Minim(this);
   arduino = new Arduino(this, Arduino.list()[2], 57600);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO);
  
  arduino.pinMode(greenLED, Arduino.OUTPUT);    
  arduino.pinMode(redLED, Arduino.OUTPUT);  
  arduino.pinMode(blueLED, Arduino.OUTPUT);  
}

public void draw()
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

public void stop() {
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}
  public void settings() {  size(512, 200, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Test_RealtimeAudio" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
