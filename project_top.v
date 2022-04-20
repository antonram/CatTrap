// initialize ALL variables
module CatTrap_top( ClkPort, BtnC, BtnU,
Sw0, Sw1, Sw2, Sw3, Sw4, Sw5, Sw6, Sw7, Sw15, Sw14, Sw13, Sw12, Sw11, Sw10, Sw9, Sw8,
An7, An6, An5, An4, An3, An2, An1, An0,
Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp


);

input ClkPort;
input BtnC, BtnU;
input    Sw0, Sw1, Sw2, Sw3, Sw4, Sw5, Sw6, Sw7;
input    Sw8, Sw9, Sw10, Sw11, Sw12, Sw13, Sw14, Sw15;

output An0, An1, An2, An3, An4, An5, An6, An7;
output   Ca, Cb, Cc, Cd, Ce, Cf, Cg, Dp;


// ROM drivers: Control signals on Memory chips (to disable them)
output 	MemOE, MemWR, RamCS, QuadSpiFlashCS;

// Local signals
wire Reset, ClkPort;
wire		board_clk, sys_clk;
wire [2:0] 	ssdscan_clk;
wire Start;
wire [3:0] Row, Col;

// to produce divided clock
reg [26:0]	DIV_CLK;

// SSD (Seven Segment Display)
reg [3:0]	SSD;
wire [3:0]	SSD4, SSD0;
reg [6:0]  	SSD_CATHODES;

// Disable the three memories so that they do not interfere with the rest of the design.
assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;


assign Reset = BtnC;
assign Row = {Sw15, Sw14, Sw13, Sw12, Sw11, Sw10, Sw9, Sw8};
assign Col = {Sw7, Sw6, Sw5, Sw4, Sw3, Sw2, Sw1, Sw0};

//------------
// Our clock is too fast (100MHz) for SSD scanning
// create a series of slower "divided" clocks
// each successive bit is 1/2 frequency
always @(posedge board_clk, posedge Reset)
  begin
      if (Reset)
	DIV_CLK <= 0;
      else
	DIV_CLK <= DIV_CLK + 1'b1;
  end
//------------
// In this design, we run the core design at full 50MHz clock!
assign	sys_clk = board_clk;
// assign	sys_clk = DIV_CLK[25];

assign Start = BtnU;

wire [11:0] background;
wire [11:0] rgb;
display_controller dc(.clk(ClkPort), .Row(Row), .Col(Col), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));

assign SSD4 = Row[3:0];
assign SSD0 = Col[3:0];

assign ssdscan_clk = DIV_CLK[20];

assign An0	=  !(~(ssdscan_clk));  // when ssdscan_clk = 0
assign An4	=  !(ssdscan_clk);  // when ssdscan_clk = 1
assign {An7, An6, An5, An3, An2, An1} = {6'b111111};

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
			4'b0000: SSD_CATHODES = 7'b0000001; // 0
			4'b0001: SSD_CATHODES = 7'b1001111; // 1
			4'b0010: SSD_CATHODES = 7'b0010010; // 2
			4'b0011: SSD_CATHODES = 7'b0000110; // 3
			4'b0100: SSD_CATHODES = 7'b1001100; // 4
			4'b0101: SSD_CATHODES = 7'b0100100; // 5
			4'b0110: SSD_CATHODES = 7'b0100000; // 6
			4'b0111: SSD_CATHODES = 7'b0001111; // 7
			4'b1000: SSD_CATHODES = 7'b0000000; // 8
			4'b1001: SSD_CATHODES = 7'b0000100; // 9
			4'b1010: SSD_CATHODES = 7'b0001000; // A
			4'b1011: SSD_CATHODES = 7'b1100000; // B
			4'b1100: SSD_CATHODES = 7'b0110001; // C
			4'b1101: SSD_CATHODES = 7'b1000010; // D
			4'b1110: SSD_CATHODES = 7'b0110000; // E
			4'b1111: SSD_CATHODES = 7'b0111000; // F
			default: SSD_CATHODES = 7'bXXXXXXX; // default is not needed as we covered all cases
		endcase
	end

// reg [6:0]  SSD_CATHODES;
assign {Ca, Cb, Cc, Cd, Ce, Cf, Cg} = {SSD_CATHODES};

endmodule
