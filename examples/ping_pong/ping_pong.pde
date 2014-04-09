/*

  ping?
  pong!

*/

StateMachine sm;

void setup() {
  frameRate(1);
  sm = new StateMachine(new PingState());
}

void draw() {
  sm = sm.nextState();
}

class StateMachine {
  private State currentstate;
  
  StateMachine(State initialstate) {
    this.currentstate = initialstate;
  }
  
  public StateMachine nextState() {    
    this.currentstate = this.currentstate.nextState();
   return this; 
  }
}

interface State {
  public State nextState();  
}

class PingState implements State {
  public State nextState() {
    println("ping?");
      return new PongState();
    }
}

class PongState implements State {
  public State nextState() {
    println("pong!");
      return new PingState();
    }
}

