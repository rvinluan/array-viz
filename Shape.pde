import java.util.*;

public static int startingAmp = 30;

enum State {
  ATTACK, 
    DECAY, 
    SUSTAIN, 
    RELEASE, 
    OFF
}

public class Shape {
  private final static int attack = 3;
  private final static int decay = 10;
  private final static float sustain = .6;
  private final static int release = 10;

  private State state;
  private int t;
  private int r; //random factor
  private int noteValue;
  private int velocityValue;
  
  //mappable parameters
  private int x;
  private int y;
  private int rectSize;
  private int rectStroke;

  public Shape(int _n, int _x, int _y, int _r) {
    this.noteValue = _n;
    this.x = _x;
    this.y = _y;
    this.t = 0;
    this.r = _r;
    this.state = State.OFF;
  }

  public void update() {
    float apv = 0; //value between 0 and 1 that represents the desired value depending on state and t
    
    this.t++;
    
    if (this.state == State.OFF) {
      this.apply(0);
    }
    if (this.state == State.ATTACK) {
      if (this.t > attack) {
        this.state = State.DECAY;
        this.t = 0;
      } else {
        this.apply( map(t, 0, Shape.attack, 0, 1) );
      }
    }
    if (this.state == State.DECAY) {
      if (this.t > decay) {
        this.state = State.SUSTAIN;
        this.t = 0;
      } else {
        this.apply( map(t, 0, Shape.decay, 1, Shape.sustain) );
      }
    }
    if (this.state == State.SUSTAIN) {
      this.apply(Shape.sustain);
    }
    if (this.state == State.RELEASE) {
      if (this.t > release) {
        this.state = State.OFF;
        this.t = 0;
      } else {
        this.apply( map(t, 0, Shape.release, Shape.sustain, 0) );
      }
    }
  }
  
  public void apply(float appliedValue) {
    //map appliedValue to all of this shape's parameters
    int maxRectSize = (int)map(this.velocityValue,0,128,10,90);
    this.rectSize = (int)map(appliedValue, 0, 1, 10, maxRectSize);
    this.rectStroke = (int)map(appliedValue,  0, 1, 1, 10);
  }

  public void on(int _v) {
    this.state = State.ATTACK;
    this.velocityValue = _v;
    this.t = 0;
  }

  public void off() {
    this.state = State.RELEASE;
    this.t = 0;
  }

  public void render() {
    pushMatrix();
    rectMode(CENTER);
    strokeWeight(this.rectStroke);
    float vibrato;
    if(this.state == State.SUSTAIN) {
      vibrato = (sin(this.t));
    } else {
      vibrato = 0;
    }
    if(this.isBlack()) {
      stroke(0);
      fill(0);
      translate(this.x + r, this.y + vibrato + r);
      rotate(r*0.01);
      rect(0, 0, this.rectSize*1.66, this.rectSize);
    } else {
      stroke(255);
      noFill();
      translate(this.x + r, this.y + vibrato + r);
      rotate(r*0.01);
      rect(0, 0, this.rectSize*1.2, this.rectSize*4.666);
    }
    popMatrix();
  }
  
  public boolean isBlack() {
    int k = this.noteValue % 12;
    return (k % 2 != 0 && k < 4) || (k % 2 == 0 && k > 5);
  }
}