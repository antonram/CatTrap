`timescale 1ns / 1ps

module connect_4(Clk, Reset, Start_Ack, Left_b, Right_b, Down_b, p1_pointer, full_columns, q_start, q_p1_move, q_p1_place, 
					q_p1_win, q_p2_move, q_p2_place, q_p2_win, hCount, vCount, rgb, bright);
					
	input	Clk, Reset, Start_Ack, Left_b, Right_b, Down_b;
	
	reg btn_flag;
	
	
	reg [2:0] column_count [0:6];
	
	reg column_full [0:6];
	
	output reg [2:0]  p1_pointer, full_columns;
	
	integer i, j;
	
	output q_start, q_p1_move, q_p2_move, q_p1_place, q_p2_place, q_p1_win, q_p2_win;
	reg [6:0] state;	
	assign {q_start, q_p1_move, q_p2_move, q_p1_place, q_p2_place, q_p1_win, q_p2_win} = state;
	
	input [9:0] hCount, vCount;
	reg [1:0] board_map [0:5] [0:6];
	output reg [11:0] rgb;
	input bright;
	wire [3:0] p1x, p2x, p1y, p2y, p1xM, p2xM, p1yM, p2yM;

	localparam
		START =    7'b1000000,
		PLAY =   7'b0100000,
		GAMEOVER =   7'b0010000,
		GAMEWIN =  7'b0001000,
		P2PLACE =  7'b0000100,
		P1WIN =    7'b0000010,
		P2WIN =    7'b0000001;
	
	parameter RED = 12'b1111_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter GRAY = 12'b1010_1010_1010;
	parameter BLACK = 12'b0000_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	
	reg [11:0] color [0:2];
	
	initial
	begin
		color[0] = WHITE;
		color[1] = RED;
		color[2] = GRAY;
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
			if (state == P1WIN)
				rgb = RED;
			else if (state == P2WIN)
				rgb = GREEN;
			else
				rgb = 12'b1010_1111_1111;		
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
			p1_pointer <= 3'bx;
			for(i = 0; i < 7; i = i + 1)
			begin 
				column_count[i] <= 3'bxxx;
				column_full[i] <= 1'bx;
			end
			
			full_columns <= 3'bxxx;
			
			//init grid w/ white squares and one center orange square for cat
			board_map [0][1] = 1;
			board_map [0][2] = 0;
			board_map [0][3] = 1;
			board_map [0][4] = 0;
			board_map [0][5] = 1;
			board_map [0][6] = 0;
			
			board_map [1][1] = 0;
			board_map [1][2] = 1;
			board_map [1][3] = 0;
			board_map [1][4] = 1;
			board_map [1][5] = 0;
			board_map [1][6] = 1;
			

			board_map [2][1] = 1;
			board_map [2][2] = 0;
			board_map [2][3] = 1;
			board_map [2][4] = 0;
			board_map [2][5] = 1;
			board_map [2][6] = 0;
		

			board_map [3][1] = 0;
			board_map [3][2] = 1;
			board_map [3][3] = 0;
			board_map [3][4] = 1;
			board_map [3][5] = 0;
			board_map [3][6] = 1;
			board_map [3][7] = 0;
			board_map [3][8] = 1;

			board_map [4][1] = 1;
			board_map [4][2] = 0;
			board_map [4][3] = 1;
			board_map [4][4] = 2; //cat
			board_map [4][5] = 1;
			board_map [4][6] = 0;
			

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
					//nsl
					if(Start_Ack) state <= PLAY;
					
					//dpu
					p1_pointer <= 3'b011;
					for(i = 0; i < 7; i = i + 1)
					begin 
						column_count[i] <= 3'b000;
						column_full[i] <= 1'b0;
						
					end
					full_columns <= 3'b000;
					
					for(i = 0; i < 7; i = i+1)
					begin
						for(j = 0; j < 6; j = j+1)
						begin
							board_map[j][i] = 2'b00;
						end
					end
					
				end
				PLAY:
				begin
					//nsl
					if(Down_b && (full_columns < 7))
						state <= GAMEWIN;
						
					if(full_columns == 7)
						state <= START;
						
					//check horizontal win
					for (i = 0; i < 6; i = i + 1)
						for (j = 0; j < 4; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i][j+1] == 2'b01 && board_map[i][j+2] == 2'b01 && board_map[i][j+3] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i][j+1] == 2'b10 && board_map[i][j+2] == 2'b10 && board_map[i][j+3] == 2'b10)
								state <= P2WIN;
						end
					
					//check vertical win
					for (i = 0; i < 3; i = i + 1)
						for (j = 0; j < 7; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i+1][j] == 2'b01 && board_map[i+2][j] == 2'b01 && board_map[i+3][j] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i+1][j] == 2'b10 && board_map[i+2][j] == 2'b10 && board_map[i+3][j] == 2'b10)
								state <= P2WIN;
						end
						
					//check positive diagonal win
					for (i = 0; i < 3; i = i + 1)
						for (j = 0; j < 4; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i+1][j+1] == 2'b01 && board_map[i+2][j+2] == 2'b01 && board_map[i+3][j+3] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i+1][j+1] == 2'b10 && board_map[i+2][j+2] == 2'b10 && board_map[i+3][j+3] == 2'b10)
								state <= P2WIN;
						end
					
					// check negative diagonal win
					for (i = 3; i < 6; i = i + 1)
						for (j = 0; j < 4; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i-1][j+1] == 2'b01 && board_map[i-2][j+2] == 2'b01 && board_map[i-3][j+3] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i-1][j+1] == 2'b10 && board_map[i-2][j+2] == 2'b10 && board_map[i-3][j+3] == 2'b10)
								state <= P2WIN;
						end
					
					//dpu
					if(Right_b && !Left_b && !btn_flag)
					begin
						btn_flag <= 1;
						if(p1_pointer != 6)
							p1_pointer <= p1_pointer + 1;
							
					end
					
					if(!Right_b && Left_b && !btn_flag)
					begin
						btn_flag <= 1;
						if(p1_pointer != 0)
							p1_pointer <= p1_pointer - 1;
					end
					
					if(!Right_b && !Left_b)
						btn_flag <= 0;
				end
				GAMEOVER:
				begin
				//nsl
					if(Down_b && (full_columns < 7))
						state <= P2PLACE;
						
					if(full_columns == 7)
						state <= START;
						
					//check horizontal win
					for (i = 0; i < 6; i = i + 1)
						for (j = 0; j < 4; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i][j+1] == 2'b01 && board_map[i][j+2] == 2'b01 && board_map[i][j+3] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i][j+1] == 2'b10 && board_map[i][j+2] == 2'b10 && board_map[i][j+3] == 2'b10)
								state <= P2WIN;
						end
					
					//check vertical win
					for (i = 0; i < 3; i = i + 1)
						for (j = 0; j < 7; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i+1][j] == 2'b01 && board_map[i+2][j] == 2'b01 && board_map[i+3][j] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i+1][j] == 2'b10 && board_map[i+2][j] == 2'b10 && board_map[i+3][j] == 2'b10)
								state <= P2WIN;
						end
						
					//check positive diagonal win
					for (i = 0; i < 3; i = i + 1)
						for (j = 0; j < 4; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i+1][j+1] == 2'b01 && board_map[i+2][j+2] == 2'b01 && board_map[i+3][j+3] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i+1][j+1] == 2'b10 && board_map[i+2][j+2] == 2'b10 && board_map[i+3][j+3] == 2'b10)
								state <= P2WIN;
						end
					
					// check negative diagonal win
					for (i = 3; i < 6; i = i + 1)
						for (j = 0; j < 4; j = j + 1)
						begin
							if (board_map[i][j] == 2'b01 && board_map[i-1][j+1] == 2'b01 && board_map[i-2][j+2] == 2'b01 && board_map[i-3][j+3] == 2'b01)
								state <= P1WIN;
							else if (board_map[i][j] == 2'b10 && board_map[i-1][j+1] == 2'b10 && board_map[i-2][j+2] == 2'b10 && board_map[i-3][j+3] == 2'b10)
								state <= P2WIN;
						end
						
					//dpu
					if(Right_b && !Left_b && !btn_flag)
					begin
						btn_flag <= 1;
						if(p1_pointer != 6)
							p1_pointer <= p1_pointer + 1;
							
					end
					
					if(!Right_b && Left_b && !btn_flag)
					begin
						btn_flag <= 1;
						if(p1_pointer != 0)
							p1_pointer <= p1_pointer - 1;
					end
					
					if(!Right_b && !Left_b)
						btn_flag <= 0;
					
				end
				GAMEWIN:
				begin
					//nsl
 					if(!Down_b && column_full[p1_pointer])
						state <= PLAY;
					if(!Down_b && !column_full[p1_pointer])
						state <= GAMEOVER; 
					
					
					//dpu
					
					if(!Down_b)
						p1_pointer <= 3'b011;
						
					if(!Down_b && !column_full[p1_pointer])
					begin
						if(board_map[column_count[p1_pointer]][p1_pointer] == 2'b00)
						begin
							board_map[column_count[p1_pointer]][p1_pointer] <= 2'b01;
						
							column_count[p1_pointer] <= column_count[p1_pointer] + 1;
							if(column_count[p1_pointer] == 5)
							begin
							    column_full[p1_pointer] <= 1'b1;
								full_columns <= full_columns + 1;
							end
						end
					end
					
				end
				P2PLACE:
				begin
					//nsl
 					if(!Down_b && column_full[p1_pointer])
						state <= GAMEOVER;
					if(!Down_b && !column_full[p1_pointer])
						state <= PLAY; 
						
					//dpu
					
					if(!Down_b)
						p1_pointer <= 3'b011;
					
					if(!Down_b && !column_full[p1_pointer])
					begin
						if(board_map[column_count[p1_pointer]][p1_pointer] == 2'b00)
						begin
							board_map[column_count[p1_pointer]][p1_pointer] <= 2'b10;
						
							column_count[p1_pointer] <= column_count[p1_pointer] + 1;
							if(column_count[p1_pointer] == 5)
							begin
							    column_full[p1_pointer] <= 1'b1;
								full_columns <= full_columns + 1;
							end
						end
					end
					
				end
				P1WIN:
				begin
				end
				P2WIN:
				begin
				end
		  endcase
	   end 
    end
	
	//ofl
	
endmodule