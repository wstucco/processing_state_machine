import processing.video.*;

/*

  roll a dice, if the score is even, pause for a random amount of time
  and then extract a random bingo number

*/

StateMachine sm;

void setup() {
  frameRate(1); // slowly we roll
  sm = new StateMachine(new IdleState());
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

class IdleState implements State {
  public State nextState() {
    return new RollState();
  }
}

class RollState implements State {
  public State nextState() {
    println("rolling the dice ...");
    
    int score = int(random(1, 7)); // upper bound is not inclued so to get 6 we need to specify 7
    println("it's a " + score);
    
    if(score % 2 == 0) {
      println("looks like we getting a number...");
     return new PauseState();
    }
    
    println("try again!");
    return new IdleState(); 
  }
}


class PauseState implements State {
  private int start;
  private float timeout;
  
  PauseState() {
    start = millis();
    timeout = random(500, 1500);
    
    println("in exactly " + (timeout/1000.0) + " seconds");    
  }

  public State nextState() {
    if((millis()-start) < timeout) 
      return this;
      
    return new RandomBingoNumberState();
  }
}

class RandomBingoNumberState implements State {
  public State nextState() {
    float r = int(random(1, 91));
    println("the next number number is " + r);
    
    return new IdleState();
  }
}


