`timescale 1ns / 1ps

module catTrap(Clk, Reset, Down_b, hCount, vCount, rgb, bright, Block_col, Block_row);

	input	Clk, Reset, Down_b;
	input [7:0] Block_col, Block_row;
    
	reg btn_flag;


	integer i, j;

	reg [6:0] state;
	
	input [9:0] hCount, vCount;
	reg [1:0] board_map [0:5] [0:6];
	output reg [11:0] rgb;
	input bright;
	
	
	reg [1:0] cat_flag = 1;
	reg [2:0] block_col;
  reg [2:0] block_row;
	reg [2:0] cat_col;
	reg [2:0] cat_row;
	
	
	

	localparam
		START =    7'b1000000,
		PLAY =   7'b0100000,
		GAMEOVER =   7'b0010000,
		GAMEWIN =  7'b0001000,


	WHITE = 12'b1111_1111_1111;
	parameter GRAY = 12'b1010_1010_1010;
	parameter BLACK = 12'b0000_0000_0000;
	parameter RED = 12'b1111_0000_0000;
	parameter ORANGE = 12'b1111_1000_0000;
	parameter GREEN = 12'b0000_1111_0000;

	reg [11:0] color [0:2];

	initial
	begin
		color[0] = WHITE;
		color[1] = GRAY;
		color[2] = ORANGE;
		color[3] = BLACK;
	end

	//vga screen
	always@ (*)
	begin
    	if(~bright )	//force black if not inside the display area
			rgb = BLACK;
		else if (inbound)
		begin
			if(box00)
				rgb = color[board_map[5][0]];
			else if (box01)
				rgb = color[board_map[5][1]];
			else if (box02)
				rgb = color[board_map[5][2]];
			else if (box03)
				rgb = color[board_map[5][3]];
			else if (box04)
				rgb = color[board_map[5][4]];
			else if (box05)
				rgb = color[board_map[5][5]];
			else if (box06)
				rgb = color[board_map[5][6]];
			else if (box10)
				rgb = color[board_map[4][0]];
			else if (box11)
				rgb = color[board_map[4][1]];
			else if (box12)
				rgb = color[board_map[4][2]];
			else if (box13)
				rgb = color[board_map[4][3]];
			else if (box14)
				rgb = color[board_map[4][4]];
			else if (box15)
				rgb = color[board_map[4][5]];
			else if (box16)
				rgb = color[board_map[4][6]];
			else if (box20)
				rgb = color[board_map[3][0]];
			else if (box21)
				rgb = color[board_map[3][1]];
			else if (box22)
				rgb = color[board_map[3][2]];
			else if (box23)
				rgb = color[board_map[3][3]];
			else if (box24)
				rgb = color[board_map[3][4]];
			else if (box25)
				rgb = color[board_map[3][5]];
			else if (box26)
				rgb = color[board_map[3][6]];
			else if (box30)
				rgb = color[board_map[2][0]];
			else if (box31)
				rgb = color[board_map[2][1]];
			else if (box32)
				rgb = color[board_map[2][2]];
			else if (box33)
				rgb = color[board_map[2][3]];
			else if (box34)
				rgb = color[board_map[2][4]];
			else if (box35)
				rgb = color[board_map[2][5]];
			else if (box36)
				rgb = color[board_map[2][6]];
			else if (box40)
				rgb = color[board_map[1][0]];
			else if (box41)
				rgb = color[board_map[1][1]];
			else if (box42)
				rgb = color[board_map[1][2]];
			else if (box43)
				rgb = color[board_map[1][3]];
			else if (box44)
				rgb = color[board_map[1][4]];
			else if (box45)
				rgb = color[board_map[1][5]];
			else if (box46)
				rgb = color[board_map[1][6]];
			else if (box50)
				rgb = color[board_map[0][0]];
			else if (box51)
				rgb = color[board_map[0][1]];
			else if (box52)
				rgb = color[board_map[0][2]];
			else if (box53)
				rgb = color[board_map[0][3]];
			else if (box54)
				rgb = color[board_map[0][4]];
			else if (box55)
				rgb = color[board_map[0][5]];
			else if (box56)
				rgb = color[board_map[0][6]];
			else
				rgb = 12'b0000_0111_1111;
		end
		
		else
		begin
			if (state == GAMEOVER)
				rgb = RED;
			else if (state == GAMEWIN)
				rgb = GREEN;
			else if (state == START)
			     rgb = ORANGE;
			else
				rgb = 12'b1010_1111_1111;
	     end
	end

	assign inbound = ((hCount >= 190)&&(hCount <= 550)&&(vCount >= 140)&&(vCount <= 450));

	assign box00 = ((hCount >= 200)&&(hCount <= 250)&&(vCount >= 150)&&(vCount <= 200));
	assign box01 = ((hCount >= 250)&&(hCount <= 300)&&(vCount >= 150)&&(vCount <= 200));
	assign box02 = ((hCount >= 300)&&(hCount <= 350)&&(vCount >= 150)&&(vCount <= 200));
	assign box03 = ((hCount >= 350)&&(hCount <= 400)&&(vCount >= 150)&&(vCount <= 200));
	assign box04 = ((hCount >= 400)&&(hCount <= 450)&&(vCount >= 150)&&(vCount <= 200));
	assign box05 = ((hCount >= 450)&&(hCount <= 500)&&(vCount >= 150)&&(vCount <= 200));
	assign box06 = ((hCount >= 500)&&(hCount <= 550)&&(vCount >= 150)&&(vCount <= 200));

	assign box10 = ((hCount >= 200)&&(hCount <= 250)&&(vCount >= 200)&&(vCount <= 250));
	assign box11 = ((hCount >= 250)&&(hCount <= 300)&&(vCount >= 200)&&(vCount <= 250));
	assign box12 = ((hCount >= 300)&&(hCount <= 350)&&(vCount >= 200)&&(vCount <= 250));
	assign box13 = ((hCount >= 350)&&(hCount <= 400)&&(vCount >= 200)&&(vCount <= 250));
	assign box14 = ((hCount >= 400)&&(hCount <= 450)&&(vCount >= 200)&&(vCount <= 250));
	assign box15 = ((hCount >= 450)&&(hCount <= 500)&&(vCount >= 200)&&(vCount <= 250));
	assign box16 = ((hCount >= 500)&&(hCount <= 550)&&(vCount >= 200)&&(vCount <= 250));

	assign box20 = ((hCount >= 200)&&(hCount <= 250)&&(vCount >= 250)&&(vCount <= 300));
	assign box21 = ((hCount >= 250)&&(hCount <= 300)&&(vCount >= 250)&&(vCount <= 300));
	assign box22 = ((hCount >= 300)&&(hCount <= 350)&&(vCount >= 250)&&(vCount <= 300));
	assign box23 = ((hCount >= 350)&&(hCount <= 400)&&(vCount >= 250)&&(vCount <= 300));
	assign box24 = ((hCount >= 400)&&(hCount <= 450)&&(vCount >= 250)&&(vCount <= 300));
	assign box25 = ((hCount >= 450)&&(hCount <= 500)&&(vCount >= 250)&&(vCount <= 300));
	assign box26 = ((hCount >= 500)&&(hCount <= 550)&&(vCount >= 250)&&(vCount <= 300));

	assign box30 = ((hCount >= 200)&&(hCount <= 250)&&(vCount >= 300)&&(vCount <= 350));
	assign box31 = ((hCount >= 250)&&(hCount <= 300)&&(vCount >= 300)&&(vCount <= 350));
	assign box32 = ((hCount >= 300)&&(hCount <= 350)&&(vCount >= 300)&&(vCount <= 350));
	assign box33 = ((hCount >= 350)&&(hCount <= 400)&&(vCount >= 300)&&(vCount <= 350));
	assign box34 = ((hCount >= 400)&&(hCount <= 450)&&(vCount >= 300)&&(vCount <= 350));
	assign box35 = ((hCount >= 450)&&(hCount <= 500)&&(vCount >= 300)&&(vCount <= 350));
	assign box36 = ((hCount >= 500)&&(hCount <= 550)&&(vCount >= 300)&&(vCount <= 350));

	assign box40 = ((hCount >= 200)&&(hCount <= 250)&&(vCount >= 350)&&(vCount <= 400));
	assign box41 = ((hCount >= 250)&&(hCount <= 300)&&(vCount >= 350)&&(vCount <= 400));
	assign box42 = ((hCount >= 300)&&(hCount <= 350)&&(vCount >= 350)&&(vCount <= 400));
	assign box43 = ((hCount >= 350)&&(hCount <= 400)&&(vCount >= 350)&&(vCount <= 400));
	assign box44 = ((hCount >= 400)&&(hCount <= 450)&&(vCount >= 350)&&(vCount <= 400));
	assign box45 = ((hCount >= 450)&&(hCount <= 500)&&(vCount >= 350)&&(vCount <= 400));
	assign box46 = ((hCount >= 500)&&(hCount <= 550)&&(vCount >= 350)&&(vCount <= 400));

	assign box50 = ((hCount >= 200)&&(hCount <= 250)&&(vCount >= 400)&&(vCount <= 450));
	assign box51 = ((hCount >= 250)&&(hCount <= 300)&&(vCount >= 400)&&(vCount <= 450));
	assign box52 = ((hCount >= 300)&&(hCount <= 350)&&(vCount >= 400)&&(vCount <= 450));
	assign box53 = ((hCount >= 350)&&(hCount <= 400)&&(vCount >= 400)&&(vCount <= 450));
	assign box54 = ((hCount >= 400)&&(hCount <= 450)&&(vCount >= 400)&&(vCount <= 450));
	assign box55 = ((hCount >= 450)&&(hCount <= 500)&&(vCount >= 400)&&(vCount <= 450));
	assign box56 = ((hCount >= 500)&&(hCount <= 550)&&(vCount >= 400)&&(vCount <= 450));

	always @ (posedge Clk, posedge Reset)
	begin
		if(Reset)
		begin
			state <= START;
			cat_col <= 3'd3;
			cat_row <= 3'd3;


			//init grid w/ white squares and one center orange square for cat
			board_map [0][0] = 0;
			board_map [0][1] = 1;
			board_map [0][2] = 0;
			board_map [0][3] = 1;
			board_map [0][4] = 0;
			board_map [0][5] = 1;
			board_map [0][6] = 0;

			board_map [1][0] = 1;
			board_map [1][1] = 0;
			board_map [1][2] = 1;
			board_map [1][3] = 0;
			board_map [1][4] = 1;
			board_map [1][5] = 0;
			board_map [1][6] = 1;


			board_map [2][0] = 0;
			board_map [2][1] = 1;
			board_map [2][2] = 0;
			board_map [2][3] = 1;
			board_map [2][4] = 0;
			board_map [2][5] = 1;
			board_map [2][6] = 0;


			board_map [3][0] = 1;
			board_map [3][1] = 0;
			board_map [3][2] = 1;
			board_map [3][3] = 2; // cat
			board_map [3][4] = 1;
			board_map [3][5] = 0;
			board_map [3][6] = 1;
			

			board_map [4][0] = 0;
			board_map [4][1] = 1;
			board_map [4][2] = 0;
			board_map [4][3] = 1;
			board_map [4][4] = 0;
			board_map [4][5] = 1;
			board_map [4][6] = 0;


			board_map [5][0] = 1;
			board_map [5][1] = 0;
			board_map [5][2] = 1;
			board_map [5][3] = 0;
			board_map [5][4] = 1;
			board_map [5][5] = 0;
			board_map [5][6] = 1;


		end
		
		else
		begin
			case(state)
				START:
				begin
					//Wait for button press
					//if button press, go to state play and select first block
						if (Down_b)
							begin
								 // add intermediate state for debouncing!!
								 state <= PLAY;
							end

				end
				PLAY:
				begin
				//Wait for press
	        if (Down_b)
	            // if press, update block and move cat
	            begin
	            // change color of selected block
	            case(Block_row)
	               8'b00000000: block_row = 3'b000;
	               8'b00000001: block_row = 3'b001;
	               8'b00000010: block_row = 3'b010;
	               8'b00000100: block_row = 3'b011;
	               8'b00001000: block_row = 3'b100;
	               8'b00010000: block_row = 3'b101;
	               8'b00100000: block_row = 3'b110;
	               8'b01000000: block_row = 3'b111;
	               default: block_row = 3'b000;
	              endcase
	              
	              case(Block_col)
	               8'b00000000: block_col = 3'b000;
	               8'b00000001: block_col = 3'b001;
	               8'b00000010: block_col = 3'b010;
	               8'b00000100: block_col = 3'b011;
	               8'b00001000: block_col = 3'b100;
	               8'b00010000: block_col = 3'b101;
	               8'b00100000: block_col = 3'b110;
	               8'b01000000: block_col = 3'b111;
	               default: block_col = 3'b000;
	              endcase
	               
                    board_map[block_row][block_col] = 3;
                    cat_flag = 1;

              //if block next to cat is not GRAY change new block to ORANGE and old block to white

                    if ((board_map[cat_row+1][cat_col] != 3)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row+1][cat_col] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_row = cat_row + 1;
                        cat_flag = 0;
                      end

                    
                    //if block to right of cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row][cat_col+1] != 3)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row][cat_col+1] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_col = cat_col + 1;
                        cat_flag = 0;
                      end

					//if block below cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row-1][cat_col] != 3)&&(cat_flag==1))
                      begin
												//move cat to new available block (change to ORANGE)
                        board_map[cat_row-1][cat_col] = 2;
                        //change old block to WHITE
                        board_map[cat_row][cat_col] = 0;
                        //update cat position
                        cat_row = cat_row - 1;
                        cat_flag = 0;
                      end

                    //if block to left of cat is not GRAY and cat has not been moved yet move cat to that block
                    else if ((board_map[cat_row][cat_col-1] != 3)&&(cat_flag==1))
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
								 if ((cat_row > 4)||(cat_col > 5)||(cat_col < 1)||(cat_row < 1))
									 state <= GAMEOVER;

	           end


				GAMEOVER:
				begin
	         // show loss (red) screen
	         
	         // move back to state "start"
           //state <= START;

	      end

				GAMEWIN:
				begin
    	      // show win (green) screen
   
    	      // move back to state "start"
            //state <= START;

	      end

		  endcase
	   end 
    end

	//ofl

endmodule
