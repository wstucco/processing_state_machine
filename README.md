Processing state machine
========================

A simple pattern for state machines in Processing  
  

Ingredients:  

- a `StateMachine` class responsible for state transitions  
- state classes that implement the `State` interface  
- a loop  


An implementation of the infinite loop

```java

StateMachine sm;

void setup() {
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


```

You can find more examples [here](https://github.com/wstucco/processing_state_machine/tree/master/examples)  
- [`dice_bingo`](https://github.com/wstucco/processing_state_machine/tree/master/examples/dice_bingo) rolls a dice, if the score is even, extracts a random bingo number [1..90]
- [`facial_scanner`](https://github.com/wstucco/processing_state_machine/tree/master/examples/facial_scanner) emulate the states of a facial recognition system. It introduces new elements such as keeping the environment safe ancd clean in the warm body of the `StateMachine` class.

