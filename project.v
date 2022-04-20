// Initialize modules
module CatTrap (ClkPort, BtnC, BtnU)

// Initialize inputs and outputs
// btn will be select button
input ClkPort;
input BtnC;
input BtnU;

// Initialize cat



// NSL and SM
always @ (posedge Clk)
  // check for button press in each state and do corresponding logic
  case(state)
    START :
      begin
      // Initialize board

      // Initialize cat

      //Wait for button press
        //in button press, go to state play and select first block

      end

    PLAY :
      begin
      //Wait for press
        if (BtnC == 1){
            // if press, update block and move cat


        }

      // then check for win or loss and change to corresponding state


      end

    GAMEOVER :
      begin
      // show loss screen

      // move back to state "start"


      end


    GAMEWIN :
      begin
      // show win screen

      // move back to state "start"


      end
