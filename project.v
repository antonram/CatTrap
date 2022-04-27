`timescale 1ns / 1ps

module project(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input Reset,
	input [9:0] hCount,
	input [9:0] vCount,
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
	reg [11:0] color [0:2];
	reg [1:0] cat_flag = 1;

	//set color values
	parameter WHITE = 12'b1111_1111_1111;
	parameter GRAY = 12'b1000_1000_1000;
	parameter ORANGE = 12'b1111_1000_0000;

  localparam
    START = 5'b00001,
    PLAY	= 5'b00010,
    GAMEOVER = 5'b00100,
    GAMEWIN = 5'b01000;


	initial
		begin
			color[0] = WHITE;
			color[1] = GRAY;
			color[2] = ORANGE;
		end

	always @(posedge clk)
		begin
		if (Reset)
			state <= START;

			//init grid w/ white squares and one center orange square for cat
			board_map [1][1] = 0;
			board_map [1][2] = 0;
			board_map [1][3] = 0;
			board_map [1][4] = 0;
			board_map [1][5] = 0;
			board_map [1][6] = 0;
			board_map [1][7] = 0;
			board_map [1][8] = 0;

			board_map [2][1] = 0;
			board_map [2][2] = 0;
			board_map [2][3] = 0;
			board_map [2][4] = 0;
			board_map [2][5] = 0;
			board_map [2][6] = 0;
			board_map [2][7] = 0;
			board_map [2][8] = 0;

			board_map [3][1] = 0;
			board_map [3][2] = 0;
			board_map [3][3] = 0;
			board_map [3][4] = 0;
			board_map [3][5] = 0;
			board_map [3][6] = 0;
			board_map [3][7] = 0;
			board_map [3][8] = 0;

			board_map [4][1] = 0;
			board_map [4][2] = 0;
			board_map [4][3] = 0;
			board_map [4][4] = 2; //cat
			board_map [4][5] = 0;
			board_map [4][6] = 0;
			board_map [4][7] = 0;
			board_map [4][8] = 0;

			board_map [5][1] = 0;
			board_map [5][2] = 0;
			board_map [5][3] = 0;
			board_map [5][4] = 0;
			board_map [5][5] = 0;
			board_map [5][6] = 0;
			board_map [5][7] = 0;
			board_map [5][8] = 0;

			board_map [6][1] = 0;
			board_map [6][2] = 0;
			board_map [6][3] = 0;
			board_map [6][4] = 0;
			board_map [6][5] = 0;
			board_map [6][6] = 0;
			board_map [6][7] = 0;
			board_map [6][8] = 0;

			board_map [7][1] = 0;
			board_map [7][2] = 0;
			board_map [7][3] = 0;
			board_map [7][4] = 0;
			board_map [7][5] = 0;
			board_map [7][6] = 0;
			board_map [7][7] = 0;
			board_map [7][8] = 0;

			board_map [8][1] = 0;
			board_map [8][2] = 0;
			board_map [8][3] = 0;
			board_map [8][4] = 0;
			board_map [8][5] = 0;
			board_map [8][6] = 0;
			board_map [8][7] = 0;
			board_map [8][8] = 0;

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
                    board_map[block_row][block_col] = 1;
                    cat_flag = 1;

              //if block next to cat is not GRAY change new block to ORANGE and old block to white

                    if ((board_map[cat_row+1][cat_col] != 1)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row+1][cat_col] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_row = cat_row + 1;
                        cat_flag = 0;
                      end

                    //if block below cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row-1][cat_col] != 1)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row-1][cat_col] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_row = cat_row - 1;
                        cat_flag = 0;
                      end

                    //if block to right of cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row][cat_col+1] != 1)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row][cat_col+1] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_col = cat_col + 1;
                        cat_flag = 0;
                      end

                    //if block to left of cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row][cat_col-1] != 1)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row][cat_col-1] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_col = cat_col - 1;
                        cat_flag = 0;
                      end

                    else
                      state <= GAMEWIN;

	            end

	               // then check for win or loss and change to corresponding state
								 if ((cat_row > 8)||(cat_col > 8)||(cat_col < 1)||(cat_row < 1))
									 state <= GAMEOVER;

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
	assign bf12 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
  assign bf13 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf14 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf15 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf16 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf17 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf18 = ((hCount >= 10'd222) && (hCount <= 10'd272)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf21 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf22 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf23 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf24 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf25 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf26 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf27 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf28 = ((hCount >= 10'd282) && (hCount <= 10'd332)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf31 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf32 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf33 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf34 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf35 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf36 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf37 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf38 = ((hCount >= 10'd342) && (hCount <= 10'd392)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf41 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf42 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf43 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf44 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf45 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf46 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf47 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf48 = ((hCount >= 10'd402) && (hCount <= 10'd452)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf51 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf52 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf53 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf54 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf55 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf56 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf57 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf58 = ((hCount >= 10'd462) && (hCount <= 10'd512)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf61 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf62 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf63 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf64 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf65 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf66 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf67 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf68 = ((hCount >= 10'd522) && (hCount <= 10'd572)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf71 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf72 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf73 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf74 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf75 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf76 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf77 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf78 = ((hCount >= 10'd582) && (hCount <= 10'd632)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;

	assign bf81 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd35) && (vCount <= 10'd85)) ? 1 : 0;
	assign bf82 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd95) && (vCount <= 10'd145)) ? 1 : 0;
	assign bf83 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd155) && (vCount <= 10'd205)) ? 1 : 0;
	assign bf84 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd215) && (vCount <= 10'd265)) ? 1 : 0;
	assign bf85 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd275) && (vCount <= 10'd325)) ? 1 : 0;
	assign bf86 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd335) && (vCount <= 10'd385)) ? 1 : 0;
	assign bf87 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd395) && (vCount <= 10'd445)) ? 1 : 0;
	assign bf88 = ((hCount >= 10'd642) && (hCount <= 10'd692)) && ((vCount >= 10'd455) && (vCount <= 10'd505)) ? 1 : 0;


	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];


	always @ (*)
		begin
		if(~bright )	//force black if not inside the display area
						rgb = 12'b0000_0000_0000;
					else if (bf11)
						rgb = color[board_map[1][1]];
					else if (bf12)
						rgb = color[board_map[1][2]];
					else if (bf13)
						rgb = color[board_map[1][3]];
					else if (bf14)
						rgb = color[board_map[1][4]];
					else if (bf15)
						rgb = color[board_map[1][5]];
					else if (bf16)
						rgb = color[board_map[1][6]];
					else if (bf17)
						rgb = color[board_map[1][7]];
					else if (bf18)
						rgb = color[board_map[1][8]];

					else if (bf21)
						rgb = color[board_map[2][1]];
					else if (bf22)
						rgb = color[board_map[2][2]];
					else if (bf23)
						rgb = color[board_map[2][3]];
					else if (bf24)
						rgb = color[board_map[2][4]];
					else if (bf25)
						rgb = color[board_map[2][5]];
					else if (bf26)
						rgb = color[board_map[2][6]];
					else if (bf27)
						rgb = color[board_map[2][7]];
					else if (bf28)
						rgb = color[board_map[2][8]];

					else if (bf31)
						rgb = color[board_map[3][1]];
					else if (bf32)
						rgb = color[board_map[3][2]];
					else if (bf33)
						rgb = color[board_map[3][3]];
					else if (bf34)
						rgb = color[board_map[3][4]];
					else if (bf35)
						rgb = color[board_map[3][5]];
					else if (bf36)
						rgb = color[board_map[3][6]];
					else if (bf37)
						rgb = color[board_map[3][7]];
					else if (bf38)
						rgb = color[board_map[3][8]];

					else if (bf41)
						rgb = color[board_map[4][1]];
					else if (bf42)
						rgb = color[board_map[4][2]];
					else if (bf43)
						rgb = color[board_map[4][3]];
					else if (bf44) //assigned as cat
						rgb = color[board_map[4][4]];
					else if (bf45)
						rgb = color[board_map[4][5]];
					else if (bf46)
						rgb = color[board_map[4][6]];
					else if (bf47)
						rgb = color[board_map[4][7]];
					else if (bf48)
						rgb = color[board_map[4][8]];

					else if (bf51)
						rgb = color[board_map[5][1]];
					else if (bf52)
						rgb = color[board_map[5][2]];
					else if (bf53)
						rgb = color[board_map[5][3]];
					else if (bf54)
						rgb = color[board_map[5][4]];
					else if (bf55)
						rgb = color[board_map[5][5]];
					else if (bf56)
						rgb = color[board_map[5][6]];
					else if (bf57)
						rgb = color[board_map[5][7]];
					else if (bf58)
						rgb = color[board_map[5][8]];

					else if (bf61)
						rgb = color[board_map[6][1]];
					else if (bf62)
						rgb = color[board_map[6][2]];
					else if (bf63)
						rgb = color[board_map[6][3]];
					else if (bf64)
						rgb = color[board_map[6][4]];
					else if (bf65)
						rgb = color[board_map[6][5]];
					else if (bf66)
						rgb = color[board_map[6][6]];
					else if (bf67)
						rgb = color[board_map[6][7]];
					else if (bf68)
						rgb = color[board_map[6][8]];

					else if (bf71)
						rgb = color[board_map[7][1]];
					else if (bf72)
						rgb = color[board_map[7][2]];
					else if (bf73)
						rgb = color[board_map[7][3]];
					else if (bf74)
						rgb = color[board_map[7][4]];
					else if (bf75)
						rgb = color[board_map[7][5]];
					else if (bf76)
						rgb = color[board_map[7][6]];
					else if (bf77)
						rgb = color[board_map[7][7]];
					else if (bf78)
						rgb = color[board_map[7][8]];

					else if (bf81)
						rgb = color[board_map[8][1]];
					else if (bf82)
						rgb = color[board_map[8][2]];
					else if (bf83)
						rgb = color[board_map[8][3]];
					else if (bf84)
						rgb = color[board_map[8][4]];
					else if (bf85)
						rgb = color[board_map[8][5]];
					else if (bf86)
						rgb = color[board_map[8][6]];
					else if (bf87)
						rgb = color[board_map[8][7]];
					else if (bf88)
						rgb = color[board_map[8][8]];

					else
						rgb = WHITE;

		end





endmodule
