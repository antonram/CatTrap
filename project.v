// Initialize modules


// Initialize inputs and outputs
// btn will be select button

// Initialize cat




// NSL and SM
always @ (posedge Clk)
  // check for button press in each state and do corresponding logic
  if(state == Start)
    begin
    // Initialize board

    // Initialize cat

    //Wait for button press
      //in button press, go to state play and select first block

    end

  else if(state == Play)
    begin
    //Wait for press

    // if press, update block and move cat

    // then check for win or loss and change to corresponding state


    end

  else if(state == GameOver)
    begin
    // show loss screen

    // move back to state "start"


    end


  else // GameWin state
    begin
    // show win screen

    // move back to state "start"


    end
