# Deliverable 3

## Cache

### General design notes

#### FSM model and states

The FSM uses a two process model in which the state behaviour and the state change are isolated.

The first process is synchronized with the clock signal and will update the _current_state_ on the rising edge of the block. The second process is synchronized with the _current_state_ signal and will execute the state's behaviour when the state changes. It will also set the _next_state_ signal based on which behavioural block is executed.

State list:

- State A: Broadcast _waitrequest_ signal to signal ready state. Exit upon receiving read/write signal.
- State B: Receive address, decoded to branch out to the right operation (r/w)

...
