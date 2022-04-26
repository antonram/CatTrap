// initialize ALL variables
`timescale 1ns / 1ps

module CatTrap_top( clk, BtnC, BtnD,
Sw0, Sw1, Sw2, Sw3, Sw4, Sw5, Sw6, Sw7, Sw15, Sw14, Sw13, Sw12, Sw11, Sw10, Sw9, Sw8,
An7, An6, An5, An4, An3, An2, An1, An0,
Ca, Cb, Cc, Cd, Ce, Cf, Cg, vgaR, vgaG, vgaB,  hSync, vSync



);

input clk;
input BtnC, BtnD;
input    Sw0, Sw1, Sw2, Sw3, Sw4, Sw5, Sw6, Sw7;
input    Sw8, Sw9, Sw10, Sw11, Sw12, Sw13, Sw14, Sw15;

output An0, An1, An2, An3, An4, An5, An6, An7;
output   Ca, Cb, Cc, Cd, Ce, Cf, Cg;
output [3:0] vgaR, vgaG, vgaB;
output hSync, vSync;


// Local signals
wire Reset, clk;
wire		board_clk, sys_clk;
wire [2:0] 	ssdscan_clk;
wire Start;
wire [7:0] Row, Col;
wire down_button;
wire center_button;

// to produce divided clock
reg [26:0]	DIV_CLK;

// SSD (Seven Segment Display)
reg [7:0]	SSD;
wire [7:0]	SSD4, SSD0;
reg [6:0]  	SSD_CATHODES;
wire[9:0] hc;
wire [9:0] vc;
wire bright;


assign board_clk = clk;
assign Reset = BtnC;
assign Row = {Sw15, Sw14, Sw13, Sw12, Sw11, Sw10, Sw9, Sw8};
assign Col = {Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0};
assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;


//------------
// Our clock is too fast (100MHz) for SSD scanning
// create a series of slower "divided" clocks
// each successive bit is 1/2 frequency
always @(posedge clk, posedge Reset)
  begin
      if (Reset)
	DIV_CLK <= 0;
      else
	DIV_CLK <= DIV_CLK + 1'b1;
  end
//------------
// In this design, we run the core design at full 50MHz clock!
assign	sys_clk = clk;
// assign	sys_clk = DIV_CLK[25];

assign Start = BtnC;

wire [11:0] background;
wire [11:0] rgb;


project sc(.clk(clk), .Row(Row), .Col(Col),
.bright(bright), .hCount(hc),
.vCount(vc), .BtnC(BtnC), .BtnD(BtnD), .rgb(rgb), .background(background),
.center_button(center_button), .down_button(down_button));

display_controller dc(.clk(clk), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));

ee354_debouncer #(.N_dc(25)) B_Down(.CLK(clk),
						.RESET(Reset),
						.PB(BtnD),
						.DPB(),
						.SCEN(down_button),
						.MCEN(),
						.CCEN());


ee354_debouncer #(.N_dc(25)) B_Center(.CLK(clk),
						.RESET(Reset),
						.PB(BtnC),
						.DPB(),
						.SCEN(center_button),
						.MCEN(),
						.CCEN());


assign SSD4 = Row[7:0];
assign SSD0 = Col[7:0];

assign ssdscan_clk = DIV_CLK[25];

assign An0	=  !(~(ssdscan_clk));  // when ssdscan_clk = 0
//assign An4	=  !(ssdscan_clk);  // when ssdscan_clk = 1
assign {An7, An6, An5, An4, An3, An2, An1} = {7'b1111111};

always @ (ssdscan_clk, SSD0, SSD4)
	begin : SSD_SCAN_OUT
		case (ssdscan_clk)
				  1'b0: SSD = SSD0;
				  1'b1: SSD = SSD4;
		endcase
	end


always @ (SSD)
	begin : HEX_TO_SSD
		case (SSD)
			8'b00000000: SSD_CATHODES = 7'b0000001; // 0
			8'b00000001: SSD_CATHODES = 7'b1001111; // 1
			8'b00000010: SSD_CATHODES = 7'b0010010; // 2
			8'b00000100: SSD_CATHODES = 7'b0000110; // 3
			8'b00001000: SSD_CATHODES = 7'b1001100; // 4
			8'b00010000: SSD_CATHODES = 7'b0100100; // 5
			8'b00100000: SSD_CATHODES = 7'b0100000; // 6
			8'b01000000: SSD_CATHODES = 7'b0001111; // 7
			8'b10000000: SSD_CATHODES = 7'b0000000; // 8
			//8'b00001001: SSD_CATHODES = 7'b0000100; // 9
			//8'b00001010: SSD_CATHODES = 7'b0001000; // A
			//8'b00001011: SSD_CATHODES = 7'b1100000; // B
			//8'b00001100: SSD_CATHODES = 7'b0110001; // C
			//8'b00001101: SSD_CATHODES = 7'b1000010; // D
			//8'b00001110: SSD_CATHODES = 7'b0110000; // E
			//8'b00001111: SSD_CATHODES = 7'b0111000; // F
			default: SSD_CATHODES = 7'b0001000; // A. Just picked a random default value
		endcase
	end

// reg [6:0]  SSD_CATHODES;
assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = {SSD_CATHODES};



endmodule
