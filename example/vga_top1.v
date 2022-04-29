`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:00 12/14/2017 
// Design Name: 
// Module Name:    vga_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_top(
	input ClkPort,
	input BtnC,
	input BtnD,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	//SSG signal 
	output An0, An1, An2, An3, An4, An5, An6, An7,
	output Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS,
	input    Sw0, Sw1, Sw2, Sw3, Sw4, Sw5, Sw6, Sw7,
    input    Sw8, Sw9, Sw10, Sw11, Sw12, Sw13, Sw14, Sw15
	);
	wire Reset;
	assign Reset=BtnC;
	
	wire Down_b;
	
	wire bright;
	wire[9:0] hc, vc;
	wire[15:0] score;
	wire [3:0] anode;
	wire [11:0] rgb;
	wire [11:0] background;
	reg [7:0]	SSD;
	wire [7:0]	SSD4, SSD0;
	reg [7:0]  	SSD_CATHODES;
	wire [1:0] 	ssdscan_clk;
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen

	// Outputs
/* 	wire [11:0] column0, column1, column2, column3, 
					column4, column5, column6; */
					
	wire [2:0] p1_pointer, 
					full_columns;
					
	wire q_start;
	wire q_p1_move;
	wire q_p1_place;
	wire q_p1_win;
	wire q_p2_move;
	wire q_p2_place;
	wire q_p2_win;
	
	ee354_debouncer #(.N_dc(25)) B_Down(.CLK(ClkPort), 
						.RESET(Reset), 
						.PB(BtnD), 
						.DPB(), 
						.SCEN(Down_b), 
						.MCEN(), 
						.CCEN());
	
	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	catTrap sc(.Clk(ClkPort), 
					.Reset(Reset),  
					.Down_b(Down_b), 
					.p1_pointer(p1_pointer), 
					.full_columns(full_columns), 
					.q_start(q_start), 
					.q_p1_move(q_p1_move), 
					.q_p1_place(q_p1_place), 
					.q_p1_win(q_p1_win),
					.q_p2_move(q_p2_move), 
					.q_p2_place(q_p2_place),
					.q_p2_win(q_p2_win),
					.hCount(hc), 
					.vCount(vc), 
					.rgb(rgb),
					.bright(bright)
					);


	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	// disable mamory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	
	//------------
// SSD (Seven Segment Display)
	// reg [3:0]	SSD;
	// wire [3:0]	SSD3, SSD2, SSD1, SSD0;
	
	//SSDs display 
	//to show how we can interface our "game" module with the SSD's, we output the 12-bit rgb background value to the SSD's
	
	
	assign Row = {Sw15, Sw14, Sw13, Sw12, Sw11, Sw10, Sw9, Sw8};
	assign Col = {Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0};



	assign SSD4 = Row[7:0];
	assign SSD0 = Col[7:0];

	// need a scan clk for the seven segment display 
	
	// 100 MHz / 2^18 = 381.5 cycles/sec ==> frequency of DIV_CLK[17]
	// 100 MHz / 2^19 = 190.7 cycles/sec ==> frequency of DIV_CLK[18]
	// 100 MHz / 2^20 =  95.4 cycles/sec ==> frequency of DIV_CLK[19]
	
	// 381.5 cycles/sec (2.62 ms per digit) [which means all 4 digits are lit once every 10.5 ms (reciprocal of 95.4 cycles/sec)] works well.
	
	//                  --|  |--|  |--|  |--|  |--|  |--|  |--|  |--|  |   
    //                    |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | 
	//  DIV_CLK[17]       |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__|
	//
	//               -----|     |-----|     |-----|     |-----|     |
    //                    |  0  |  1  |  0  |  1  |     |     |     |     
	//  DIV_CLK[18]       |_____|     |_____|     |_____|     |_____|
	//
	//         -----------|           |-----------|           |
    //                    |  0     0  |  1     1  |           |           
	//  DIV_CLK[19]       |___________|           |___________|
	//

	assign ssdscan_clk = DIV_CLK[25];
	assign An0	=  !(~(ssdscan_clk));  // when ssdscan_clk = 0
	//assign An4	=  !(ssdscan_clk);  // when ssdscan_clk = 1
	assign {An7, An6, An5, An4, An3, An2, An1} = {7'b1111111};
	
	always @ (ssdscan_clk, SSD0, SSD1, SSD2, SSD3)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk) 
				  1'b0: SSD = SSD0;
				  1'b1: SSD = SSD4;
		endcase 
	end

	// Following is Hex-to-SSD conversion
	always @ (SSD) 
	begin : HEX_TO_SSD
		case (SSD) // in this solution file the dot points are made to glow by making Dp = 0
		    //                                                                abcdefg,Dp
			7'b0000000: SSD_CATHODES = 8'b00000010; // 0
			7'b0000001: SSD_CATHODES = 8'b10011110; // 1
			7'b0000010: SSD_CATHODES = 8'b00100100; // 2
			7'b0000100: SSD_CATHODES = 8'b00001100; // 3
			7'b0001000: SSD_CATHODES = 8'b10011000; // 4
			7'b0010000: SSD_CATHODES = 8'b01001000; // 5
			7'b0100000: SSD_CATHODES = 8'b01000000; // 6
			7'b1000000: SSD_CATHODES = 8'b00011110; // 7
			//7'b1000: SSD_CATHODES = 8'b00000000; // 8
			//7'b1001: SSD_CATHODES = 8'b00001000; // 9
			//7'b1010: SSD_CATHODES = 8'b00010000; // A
			//7'b1011: SSD_CATHODES = 8'b11000000; // B
			//7'b1100: SSD_CATHODES = 8'b01100010; // C
			//7'b1101: SSD_CATHODES = 8'b10000100; // D
			//7'b1110: SSD_CATHODES = 8'b01100000; // E
			//7'b1111: SSD_CATHODES = 8'b01110000; // F    
			default: SSD_CATHODES = 8'b00010000; // default is not needed as we covered all cases
		endcase
	end	
	
	// reg [7:0]  SSD_CATHODES;
	assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp} = {SSD_CATHODES};

endmodule
