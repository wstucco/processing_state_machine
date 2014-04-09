import processing.video.*;

/*

  a very interesting state machine that loops like there's no tomorrow

*/

StateMachine sm;

void setup() {
  frameRate(2);
  sm = new StateMachine(new InfiniteLoopState());
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

class InfiniteLoopState implements State {
  public State nextState() {
     println("still running ...");
    
    return this;
  }
}

