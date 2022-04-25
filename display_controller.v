`timescale 1ns / 1ps

module display_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input [9:0] hCount, vCount,
    input BtnC,
    input BtnU,
	output reg [11:0] rgb,
	output reg [11:0] background,
	input [7:0] Row,
	input [7:0] Col,
	output hSync,
	output vSync
	
   );
	wire block_fill;

    reg [2:0] state;


	parameter WHITE = 12'b1111_1111_1111;
	parameter GRAY = 12'b1000_1000_1000;
	parameter ORANGE = 12'b1111_1000_0000;

    localparam
    START = 3'b001,
    PLAY	= 3'b010,
    GAMEOVER = 3'b100,
    GAMEWIN = 3'b101;

	//init grid w/ white squares and one random center orange square for cat

	always @(posedge clk)
		case(state)
			START :
				begin
					if(~bright )	//force black if not inside the display area
						rgb = 12'b0000_0000_0000;
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
						rgb=background;
                    //Wait for button press
                  //if button press, go to state play and select first block
                    if (BtnC == 1)
                        begin
							// add intermediate state for debouncing!!
                            state <= PLAY;
                        end
                    
                end
			PLAY :
				begin
				//Wait for press
	        if (BtnC == 1)
				// add intermediate step for debouncing!!
	            // if press, update block and move cat
	            begin
	            // do stuff
	            
	            end



	        

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


	endcase

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
    
    
    assign hSync = (hCount < 96) ? 1:0;
	assign vSync = (vCount < 2) ? 1:0;
	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	
	
endmodule