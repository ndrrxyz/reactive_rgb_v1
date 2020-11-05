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

float[]values = new float[2];
int cycles = 0;
int avgValues;
int multp;

HScrollbar hs1;
HScrollbar hs2;
HScrollbar hs3;

void setup()
{
  size(812, 400, P3D);

  minim = new Minim(this);
   arduino = new Arduino(this, Arduino.list()[1], 57600);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn(Minim.STEREO);
  
  arduino.pinMode(greenLED, Arduino.OUTPUT);    
  arduino.pinMode(redLED, Arduino.OUTPUT);  
  arduino.pinMode(blueLED, Arduino.OUTPUT);  
  
  
   hs1 = new HScrollbar(-1, 20, width-413, 16, 16);
  hs2 = new HScrollbar(-1, 90 ,width-43, 16, 16);
  hs3 = new HScrollbar(-1, 180, width-43, 16, 16);
}

void draw()
{
  int amp_line = (int)hs2.getPos()*3;
  background(0);
  stroke(255);
  
  // draw the waveforms so we can see what we are monitoring
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    line( i, 50 + in.left.get(i)*amp_line, i+1, 50 + in.left.get(i+1)*amp_line );
    line( i, 150 + in.right.get(i)*amp_line, i+1, 150 + in.right.get(i+1)*amp_line );
  }
  
  
   hs1.update();
   hs1.display();
   hs2.update();
   hs2.display();
   hs3.update();
   hs3.display();

  
loop();

}

void loop(){
  int amp = (int)hs1.getPos()*8;
  System.out.println(amp);
  
  
  float r = (in.left.level()*amp)+4;
  float l = (in.right.level()*amp)+4;
  
  
  float aRL = ((r + l) / 2f);



   if(aRL > 255){
     aRL = 255;
   }
   
   if(aRL < 20)
     aRL = 0;

  //System.out.println("Cycles: "+cycles);
  //System.out.println(aRL);

   arduino.analogWrite(redLED,Math.round(aRL));
   arduino.analogWrite(greenLED,Math.round(aRL));
  //arduino.analogWrite(blueLED,2555);
  cycles++;
  if(cycles > 2){
  
    
    cycles = 0;
    }



}



void stop() {
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}