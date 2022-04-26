`timescale 1ns / 1ps

module project(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input [9:0] hCount,
	input [0:0] vCount,
    input BtnC,
    input BtnD,
	output reg [11:0] rgb,
	output reg [11:0] background,
	input [7:0] Row,
	input [7:0] Col,
	input down_button,
	input center_button

   );
	wire block_fill;

  reg [5:0] state;
	reg [1:0] board_map [1:8] [1:8];
  reg [3:0] block_col;
  reg [3:0] block_row;
	reg [2:0] cat_col;
	reg [2:0] cat_row;

  int cat_flag = 1;

	parameter WHITE = 12'b1111_1111_1111;
	parameter GRAY = 12'b1000_1000_1000;
	parameter ORANGE = 12'b1111_1000_0000;

    localparam
    START = 5'b00001,
    PLAY	= 5'b00010,
    GAMEOVER = 5'b00100,
    GAMEWIN = 5'b01000;

	//init grid w/ white squares and one random center orange square for cat



	always @(posedge clk)
		begin

		case(state)
			START :
				begin

        //Wait for button press
        //if button press, go to state play and select first block
          if (down_button)
            begin
							 // add intermediate state for debouncing!!
               state <= PLAY;
            end

        end

			PLAY :
				begin
				//Wait for press
	        if (down_button)
	            // if press, update block and move cat
	            begin
	            // change color of selected block
                    if(~bright )	//force black if not inside the display area
                      rgb = 12'b0000_0000_1111;
                    else if (board_map[block_row][block_col])
                      rgb = GRAY;
                    cat_flag = 1;

              //if block next to cat is not GRAY change new block to ORANGE and old block to white
                    if (~bright)
                      rgb = 12'b0000_0000_1111;
                    //if block above cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row+1][cat_col]) && (cat_flag==1))
                      begin
                        if (rgb != GRAY)
                          begin
                            rbg = ORANGE;
                            //change old block to WHITE
                            if(~bright )	//force black if not inside the display area
                              rgb = 12'b0000_0000_1111;
                            else if (board_map[cat_row][cat_col])
                              rgb = WHITE;
                            //update cat position
                            cat_row = cat_row + 1;
                            cat_flag = 0;
                          end
                      end
                    //if block below cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row-1][cat_col]) && (cat_flag==1))
                      begin
                        if (rgb != GRAY)
                          begin
                            rbg = ORANGE;
                            //change old block to WHITE
                            if(~bright )	//force black if not inside the display area
                              rgb = 12'b0000_0000_1111;
                            else if (board_map[cat_row][cat_col])
                              rgb = WHITE;
                            //update cat position
                            cat_row = cat_row - 1;
                            cat_flag = 0;

                          end
                      end
                    //if block to right of cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row][cat_col+1]) && (cat_flag==1))
                      begin
                        if (rgb != GRAY)
                          begin
                            rbg = ORANGE;
                            //change old block to WHITE
                            if(~bright )	//force black if not inside the display area
                              rgb = 12'b0000_0000_1111;
                            else if (board_map[cat_row][cat_col])
                              rgb = WHITE;
                            //update cat position
                            cat_col = cat_col + 1;
                            cat_flag = 0;
                          end
                      end
                    //if block to left of cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row][cat_col-1]) && (cat_flag==1))
                      begin
                        if (rgb != GRAY)
                          begin
                            rbg = ORANGE;
                            //change old block to WHITE
                            if(~bright )	//force black if not inside the display area
                              rgb = 12'b0000_0000_1111;
                            else if (board_map[cat_row][cat_col])
                              rgb = WHITE;
                            //update cat position
                            cat_col = cat_col - 1;
                            cat_flag = 0;
                          end
                      end
                    else
                      state <= GAMEWIN;

	            end

	               // then check for win or loss and change to corresponding state


	           end

	    GAMEOVER :
	      begin
	         // show loss (red) screen
           background <= 12'b1111_0000_0000;
	         // move back to state "start"
           state <= START;

	      end


	    GAMEWIN :
	      begin
    	      // show win (green) screen
            background <= 12'b0000_1111_0000;
    	      // move back to state "start"
            state <= START;

	      end


	endcase
		end


	assign bf11 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [1][1] = bf11;
	assign bf12 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [1][2] = bf12;
  assign bf13 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [1][3] = bf13;
	assign bf14 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [1][4] = bf14;
	assign bf15 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [1][5] = bf15;
	assign bf16 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [1][6] = bf16;
	assign bf17 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [1][7] = bf17;
	assign bf18 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [1][8] = bf18;
	assign bf21 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [2][1] = bf21;
	assign bf22 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [2][2] = bf22;
	assign bf23 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [2][3] = bf23;
	assign bf24 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [2][4] = bf24;
	assign bf25 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [2][5] = bf25;
	assign bf26 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [2][6] = bf26;
	assign bf27 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [2][7] = bf27;
	assign bf28 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [2][8] = bf28;
	assign bf31 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [3][1] = bf31;
	assign bf32 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [3][2] = bf32;
	assign bf33 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [3][3] = bf33;
	assign bf34 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [3][4] = bf34;
	assign bf35 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [3][5] = bf35;
	assign bf36 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [3][6] = bf36;
	assign bf37 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [3][7] = bf37;
	assign bf38 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [3][8] = bf38;
	assign bf41 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [4][1] = bf41;
	assign bf42 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [4][2] = bf42;
	assign bf43 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [4][3] = bf43;
	assign bf44 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [4][4] = bf44;
	assign bf45 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [4][5] = bf45;
	assign bf46 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [4][6] = bf46;
	assign bf47 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [4][7] = bf47;
	assign bf48 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [4][8] = bf48;
	assign bf51 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [5][1] = bf51;
	assign bf52 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [5][2] = bf52;
	assign bf53 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [5][3] = bf53;
	assign bf54 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [5][4] = bf54;
	assign bf55 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [5][5] = bf55;
	assign bf56 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [5][6] = bf56;
	assign bf57 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [5][7] = bf57;
	assign bf58 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [5][8] = bf58;
	assign bf61 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [6][1] = bf61;
	assign bf62 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [6][2] = bf62;
	assign bf63 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [6][3] = bf63;
	assign bf64 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [6][4] = bf64;
	assign bf65 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [6][5] = bf65;
	assign bf66 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [6][6] = bf66;
	assign bf67 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [6][7] = bf67;
	assign bf68 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [6][8] = bf68;
	assign bf71 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [7][1] = bf71;
	assign bf72 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [7][2] = bf72;
	assign bf73 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [7][3] = bf73;
	assign bf74 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [7][4] = bf74;
	assign bf75 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [7][5] = bf75;
	assign bf76 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [7][6] = bf76;
	assign bf77 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [7][7] = bf77;
	assign bf78 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [7][8] = bf78;
	assign bf81 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
  assign board_map [8][1] = bf81;
	assign bf82 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign board_map [8][2] = bf82;
	assign bf83 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
  assign board_map [8][3] = bf83;
	assign bf84 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
  assign board_map [8][4] = bf84;
	assign bf85 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
  assign board_map [8][5] = bf85;
	assign bf86 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
  assign board_map [8][6] = bf86;
	assign bf87 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
  assign board_map [8][7] = bf87;
	assign bf88 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;
  assign board_map [8][8] = bf88;


	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];


	always @ (*)
		begin
		if(~bright )	//force black if not inside the display area
						rgb = 12'b0000_0000_1111;
					else if (bf11)
						rgb = WHITE;
					else if (bf12)
						rgb = WHITE;
					else if (bf13)
						rgb = WHITE;
					else if (bf14)
						rgb = WHITE;
					else if (bf15)
						rgb = WHITE;
					else if (bf16)
						rgb = WHITE;
					else if (bf17)
						rgb = WHITE;
					else if (bf18)
						rgb = WHITE;
					else if (bf21)
						rgb = WHITE;
					else if (bf22)
						rgb = WHITE;
					else if (bf23)
						rgb = WHITE;
					else if (bf24)
						rgb = WHITE;
					else if (bf25)
						rgb = WHITE;
					else if (bf26)
						rgb = WHITE;
					else if (bf27)
						rgb = WHITE;
					else if (bf28)
						rgb = WHITE;
					else if (bf31)
						rgb = WHITE;
					else if (bf32)
						rgb = WHITE;
					else if (bf33)
						rgb = WHITE;
					else if (bf34)
						rgb = WHITE;
					else if (bf35)
						rgb = WHITE;
					else if (bf36)
						rgb = WHITE;
					else if (bf37)
						rgb = WHITE;
					else if (bf38)
						rgb = WHITE;
					else if (bf41)
						rgb = WHITE;
					else if (bf42)
						rgb = WHITE;
					else if (bf43)
						rgb = WHITE;
					else if (bf44) //could be randomly assigned as cat
						rgb = ORANGE;
            cat_col = 4;
            cat_row = 4;
            cat_flag = 0;
					else if (bf45) //could be randomly assigned as cat
						rgb = WHITE;
					else if (bf46)
						rgb = WHITE;
					else if (bf47)
						rgb = WHITE;
					else if (bf48)
						rgb = WHITE;
					else if (bf51)
						rgb = WHITE;
					else if (bf52)
						rgb = WHITE;
					else if (bf53)
						rgb = WHITE;
					else if (bf54) //could be randomly assigned as cat
						rgb = WHITE;
					else if (bf55) //could be randomly assigned as cat
						rgb = WHITE;
					else if (bf56)
						rgb = WHITE;
					else if (bf57)
						rgb = WHITE;
					else if (bf58)
						rgb = WHITE;
					else if (bf61)
						rgb = WHITE;
					else if (bf62)
						rgb = WHITE;
					else if (bf63)
						rgb = WHITE;
					else if (bf64)
						rgb = WHITE;
					else if (bf65)
						rgb = WHITE;
					else if (bf66)
						rgb = WHITE;
					else if (bf67)
						rgb = WHITE;
					else if (bf68)
						rgb = WHITE;
					else if (bf71)
						rgb = WHITE;
					else if (bf72)
						rgb = WHITE;
					else if (bf73)
						rgb = WHITE;
					else if (bf74)
						rgb = WHITE;
					else if (bf75)
						rgb = WHITE;
					else if (bf76)
						rgb = WHITE;
					else if (bf77)
						rgb = WHITE;
					else if (bf78)
						rgb = WHITE;
					else if (bf81)
						rgb = WHITE;
					else if (bf82)
						rgb = WHITE;
					else if (bf83)
						rgb = WHITE;
					else if (bf84)
						rgb = WHITE;
					else if (bf85)
						rgb = WHITE;
					else if (bf86)
						rgb = WHITE;
					else if (bf87)
						rgb = WHITE;
					else if (bf88)
						rgb = WHITE;
					else
						rgb=WHITE;

		end





endmodule
