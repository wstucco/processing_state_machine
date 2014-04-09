import processing.video.*;

/*

  pause for a random amount of time and then log to the console a random number

*/
final int WIDTH = 640, 
          HEIGHT = 480;

Capture cam;
StateMachine sm;

void setup() {
  size(WIDTH, HEIGHT);
  background(255);
  
  cam = new Capture(this, WIDTH, HEIGHT);
  cam.start();

  sm = new StateMachine(new IdleState(), cam); 
}

void draw() {
  if(keyPressed && !sm.scanning()) { // discrd all the inputs while scanning
    sm.input(key);
  }  
  
  sm = sm.nextState();  
}

class StateMachine {
  private State currentstate;
  private Capture cam;
  private int input;
  
  private final int KEY_SCAN = 's'; // looks confusing, it's actually the code of the char 's' 
  
  StateMachine(State initialstate, Capture cam) {
    this.currentstate = initialstate;
    this.cam = cam;
    this.input = 0;
  }
  
  public StateMachine nextState() {
    this.currentstate = this.currentstate.nextState(this.currentstate, this);
    return this; 
  }
  
  // I don't like the setter/getter pattern, unfortunately in java the best
  // you can get is to remove the set/get prefic from the methods to somewhat
  // mimic properties
  public Capture cam() {
    return this.cam;
  }
  
  public void input(int input) {
    this.input = input;
  }
  
  public boolean scanning() {
    return (this.input == KEY_SCAN);
  }
  
}

interface State {
  public State nextState(State prevState, StateMachine sm);  
}

class IdleState implements State {
  public State nextState(State prevState, StateMachine sm) {
    if(sm.cam().available()) {
      sm.cam().read();
      background(sm.cam());
    }
        
    if(sm.scanning()) {
      println("starting facial recognition");
      return new ScanState();
    }
      
    return this;
  }
}

class ScanState implements State {
  public State nextState(State prevState, StateMachine sm) {
    background(sm.cam());
    
    textSize(32);
    fill(0, 255, 0);
    text("Scanning image...", 10, 30);
    
    return new PauseState(1500, new LookupState());
  }
}

class LookupState implements State {
  public State nextState(State prevState, StateMachine sm) {
    sm.input(0); // stop scanning
    
    if(random(0, 100) <= 33) // 1 in 3 scans is successful
      return new SuccessState("Welcome back Gordon Freeman!");
    else
      return new FailureState("Who are you?");
  }
}

class SuccessState implements State {
  private String message; 
  
  SuccessState(String message) {
    this.message = message;
  }
    
  public State nextState(State prevState, StateMachine sm) {
    background(sm.cam());
    textSize(32);
    fill(0, 255, 0);
    text(this.message, 10, 30);
    
    println("happy to see you again mate!");
    
    return new PauseState(2000, new IdleState());
  }
}

class FailureState implements State {
  private String message; 
  
  FailureState(String message) {
    this.message = message;
  }
    
  public State nextState(State prevState, StateMachine sm) {
    background(sm.cam());
    textSize(32);
    fill(0, 255, 255);
    text(this.message, 10, 30);
    filter(INVERT);    
    
    println("BREAK IN ATTEMPT! SEND THE GUARDS!");
    
    return new PauseState(5000, new IdleState());
  }
}

class PauseState implements State {
  private int start;
  private int timeout = 5000; // 5 sec
  private State nextstate = new IdleState(); // next state to move to, if none specified go idle
  
  PauseState() {
    start = millis();
  }

  PauseState(int timeout) {
    this.timeout = timeout;
    this.start = millis();
  }

  PauseState(State nextstate) {
    this.start = millis();
    this.nextstate = nextstate;
  }

  PauseState(int timeout, State nextstate) {
    this.timeout = timeout;
    this.start = millis();
    this.nextstate = nextstate;
  }
  
  public State nextState(State prevState, StateMachine sm) {
    if((millis()-start) < timeout) 
      return this;
      
    return this.nextstate;
  }
}


