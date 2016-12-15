// This is sort of a copy of the "testkeytolcd.v" file.
// The .v files that need to be included in the "helper
// modules" folder are "oneshot.v" and "keyboard.v"
// Keyboard input is a modified version of from John
// Loomis's "ps2lab1" project

module testkeyboard(
		CLOCK_50,keyboard_clk, keyboard_data,
		keydata, hex0, hex1, hex2, hex3, HEX4, HEX5, HEX6, HEX7, VGA_R, VGA_B, VGA_G, VGA_BLANK_N, VGA_SYNC_N , VGA_HS, VGA_VS, rst, VGA_CLK, ps2_data
);

	// Inputs/outputs
			// System inputs
			input CLOCK_50;

			// System outputs
			//output[8:0] ledg;

			// Hex display outputs
			output[6:0] hex0;
			output[6:0] hex1;
			output[6:0] hex2;
			output[6:0] hex3;
			output[6:0] HEX4;
			output[6:0] HEX5;
			output[6:0] HEX6;
			output[6:0] HEX7;
			output [15:0] keydata;
			output reg [7:0] ps2_data;
			
			// Keyboard inputs
			input keyboard_clk;
			input keyboard_data;
			
			wire reset = 1'b0;
			wire read, scan_ready;
			wire [7:0] scan_code;
			reg [7:0] keyhistory1;
			reg [7:0] keyhistory2;
			reg [15:0] scanhistory;
			reg [15:0] keydata;
	
	// beginning of keyboard code ------------------------------------------
	// copy everything below. keydata[15:0] is the key data (ex: 16'hF032)
	oneshot pulser(
		.pulse_out(read),
		.trigger_in(scan_ready),
		.clk(CLOCK_50)
	);

	keyboard kbd(
	  .keyboard_clk(keyboard_clk),
	  .keyboard_data(keyboard_data),
	  .clock50(CLOCK_50),
	  .reset(reset),
	  .read(read),
	  .scan_ready(scan_ready),
	  .scan_code(scan_code)
	);
	
	always @(posedge scan_ready)
	begin
		keyhistory2 <= keyhistory1;
		keyhistory1 <= scan_code;
	end
	
	always @(*)
	begin
		keydata[15:8] = keyhistory2;
		keydata[7:0] = keyhistory1;
		if (keydata[7:0] == 8'h15 && keydata[15:8] != 8'hF0)
			ps2_data = 8'hC0;
		else if (keydata[7:0] == 8'h1D && keydata[15:8] != 8'hF0)
			ps2_data = 8'hD0;
		else if (keydata[7:0] == 8'h24 && keydata[15:8] != 8'hF0)
			ps2_data = 8'hE0;
		else if (keydata[7:0] == 8'h2D && keydata[15:8] != 8'hF0)
			ps2_data = 8'hF0;
		else if (keydata[7:0] == 8'h2C && keydata[15:8] != 8'hF0)
			ps2_data = 8'h60;
		else if (keydata[7:0] == 8'h35 && keydata[15:8] != 8'hF0)
			ps2_data = 8'hA0;
		else if (keydata[7:0] == 8'h3C && keydata[15:8] != 8'hF0)
			ps2_data = 8'hB0;
		else if (keydata[7:0] == 8'h43 && keydata[15:8] != 8'hF0)
			ps2_data = 8'hC0;
		else if (keydata[7:0] == 8'h1E && keydata[15:8] != 8'hF0)
			ps2_data = 8'hDB;
		else if (keydata[7:0] == 8'h26 && keydata[15:8] != 8'hF0)
			ps2_data = 8'hEB;
		else if (keydata[7:0] == 8'h2E && keydata[15:8] != 8'hF0)
			ps2_data = 8'h6B;
		else if (keydata[7:0] == 8'h36 && keydata[15:8] != 8'hF0)
			ps2_data = 8'hAB;
		else if (keydata[7:0] == 8'h3D && keydata[15:8] != 8'hF0)
			ps2_data = 8'hBB;
		/*else if(keydata[15:8] == 8'hF0)
			ps2_data = 8'h00;*/
		else
			ps2_data = 8'h00;
	end
	
	
	// end of keyboard code ------------------------------------------------
	
	hexDisplay disp0(ps2_data[3:0], HEX4);
	hexDisplay disp1(ps2_data[7:4], HEX5);
	/*hexDisplay disp2(keydata[11:8], HEX6);
	hexDisplay disp3(keydata[15:12], HEX7);*/
	blankHexDisplay disp2(HEX6);
	blankHexDisplay disp3(HEX7);
	blankHexDisplay disp4(hex4);
	blankHexDisplay disp5(hex5);
	blankHexDisplay disp6(hex6);
	blankHexDisplay disp7(hex7);



//===========================================//
//====================VGA====================//
//===========================================//
/*

VGA MODULE: Modified by Parth Patel, Ian Baker, and Yi Zhan

Most of all the code here is modified to basic VGA Displaying capabilities,

VGA MODULE adopted from BEN SHAFFER...
Utilized Ben's VGA module that he borrowed from OAKLEY KATTERHEINRICH.
Parameters were set by Ben.

*/
//===========================================//
//====================VGA====================//
//===========================================//


//outputs the colors, determined from the color module.
output [7:0] VGA_R, VGA_B, VGA_G;

//Makes sure the screen is synced right.
output VGA_HS, VGA_VS, VGA_BLANK_N, VGA_CLK, VGA_SYNC_N;


input rst; //clk is taken from the onboard clock 50MHz. rst is taken from a switch, SW[17].

wire CLK108; //Clock for the VGA

/*
Coordinates of the pixel being assigned. Moves top to bottom, left to right.
*/
wire [30:0]X, Y;


//Not sure what these are, probably have to do with the display output system.
wire [7:0]countRef;
wire [31:0]countSample;

/*COORDINATES, (X,Y) Starting at the top left hand corner of the monitor. True for all coordinates
in this code block.*/



//"object1"
reg [31:0] object1X = 31'd0, object1Y = 31'd651;

//"object2"
reg [31:0] object2X = 31'd160, object2Y = 31'd651;

//13 objects
reg [31:0] object3X = 31'd320, object3Y = 31'd651;

reg [31:0] object4X = 31'd480, object4Y = 31'd651;

reg [31:0] object5X = 31'd640, object5Y = 31'd651;

reg [31:0] object6X = 31'd800, object6Y = 31'd651;

reg [31:0] object7X = 31'd960, object7Y = 31'd651;

reg [31:0] object8X = 31'd1120, object8Y = 31'd651;

reg [31:0] object9X = 31'd120, object9Y = 31'd0;

reg [31:0] object10X = 31'd280, object10Y = 31'd0;

reg [31:0] object11X = 31'd600, object13Y = 31'd0;

reg [31:0] object12X = 31'd760, object11Y = 31'd0;

reg [31:0] object13X = 31'd920, object12Y = 31'd0;

reg [31:0] object14X = 31'd1120, object14Y = 31'd0;

reg [31:0] object15X = 31'd996, object15Y = 31'd0;

reg [31:0] object16X = 31'd836, object16Y = 31'd0;

reg [31:0] object17X = 31'd676, object17Y = 31'd0;

reg [31:0] object18X = 31'd480, object18Y = 31'd0;

reg [31:0] object19X = 31'd356, object19Y = 31'd0;

reg [31:0] object20X = 31'd196, object20Y = 31'd0;

reg [31:0] object21X = 31'd0, object21Y = 31'd0;




/* T = Top,  B = Bottom, L = Left, R = Right,  all with respect to the coordinate of where 
your "object" is placed.
T and L params are set to the object's upper lefthand.  
Best if you leave the Left hand side parameters to 0, i.e: Object1_L = 31'd0;
This will determine the available usable display space you have left.
*/

//======== Object1 =======//
//object1_localParams
localparam Object1_L = 31'd0;
localparam Object1_R = Object1_L + 31'd155;
localparam Object1_T = 31'd0;
localparam Object1_B = Object1_T + 31'd374;
assign Object1 =((X >= Object1_L + object1X)&&(X <= Object1_R + object1X)&&(Y >= Object1_T+ object1Y)&&(Y <= Object1_B+ object1Y));

///////////////////// Object 2 //////////////////////////////////////
//object2_localParams
localparam Object2_L = 31'd0;
localparam Object2_R = Object2_L + 31'd155;
localparam Object2_T = 31'd0;
localparam Object2_B = Object2_T + 31'd374;
assign Object2 =((X >= Object2_L + object2X)&&(X <= Object2_R + object2X)&&(Y >= Object2_T+ object2Y)&&(Y <= Object2_B + object2Y));


localparam Object3_L = 31'd0;
localparam Object3_R = Object3_L + 31'd155;
localparam Object3_T = 31'd0;
localparam Object3_B = Object3_T + 31'd374;
assign Object3 =((X >= Object3_L + object3X)&&(X <= Object3_R + object3X)&&(Y >= Object3_T+ object3Y)&&(Y <= Object3_B + object3Y));


localparam Object4_L = 31'd0;
localparam Object4_R = Object4_L + 31'd155;
localparam Object4_T = 31'd0;
localparam Object4_B = Object4_T + 31'd374;
assign Object4 =((X >= Object4_L + object4X)&&(X <= Object4_R + object4X)&&(Y >= Object4_T+ object4Y)&&(Y <= Object4_B + object4Y));


localparam Object5_L = 31'd0;
localparam Object5_R = Object5_L + 31'd155;
localparam Object5_T = 31'd0;
localparam Object5_B = Object5_T + 31'd374;
assign Object5 =((X >= Object5_L + object5X)&&(X <= Object5_R + object5X)&&(Y >= Object5_T+ object5Y)&&(Y <= Object5_B + object5Y));


localparam Object6_L = 31'd0;
localparam Object6_R = Object6_L + 31'd155;
localparam Object6_T = 31'd0;
localparam Object6_B = Object6_T + 31'd374;
assign Object6 =((X >= Object6_L + object6X)&&(X <= Object6_R + object6X)&&(Y >= Object6_T+ object6Y)&&(Y <= Object6_B + object6Y));


localparam Object7_L = 31'd0;
localparam Object7_R = Object7_L + 31'd155;
localparam Object7_T = 31'd0;
localparam Object7_B = Object7_T + 31'd374;
assign Object7 =((X >= Object7_L + object7X)&&(X <= Object7_R + object7X)&&(Y >= Object7_T+ object7Y)&&(Y <= Object7_B + object7Y));


localparam Object8_L = 31'd0;
localparam Object8_R = Object8_L + 31'd155;
localparam Object8_T = 31'd0;
localparam Object8_B = Object8_T + 31'd374;
assign Object8 =((X >= Object8_L + object8X)&&(X <= Object8_R + object8X)&&(Y >= Object8_T+ object8Y)&&(Y <= Object8_B + object8Y));

localparam Object14_L = 31'd0;
localparam Object14_R = Object14_L + 31'd155;
localparam Object14_T = 31'd0;
localparam Object14_B = Object14_T + 31'd650;
assign Object14 =((X >= Object14_L + object14X)&&(X <= Object14_R + object14X)&&(Y >= Object14_T+ object14Y)&&(Y <= Object14_B + object14Y));

localparam Object15_L = 31'd0;
localparam Object15_R = Object15_L + 31'd119; 
localparam Object15_T = 31'd0;
localparam Object15_B = Object15_T + 31'd650;
assign Object15 =((X >= Object15_L + object15X)&&(X <= Object15_R + object15X)&&(Y >= Object15_T+ object15Y)&&(Y <= Object15_B + object15Y));

localparam Object16_L = 31'd0;
localparam Object16_R = Object16_L + 31'd84;
localparam Object16_T = 31'd0;
localparam Object16_B = Object16_T + 31'd650;
assign Object16 =((X >= Object16_L + object16X)&&(X <= Object16_R + object16X)&&(Y >= Object16_T+ object16Y)&&(Y <= Object16_B + object16Y));

localparam Object17_L = 31'd0;
localparam Object17_R = Object17_L + 31'd83;
localparam Object17_T = 31'd0;
localparam Object17_B = Object17_T + 31'd650;
assign Object17 =((X >= Object17_L + object17X)&&(X <= Object17_R + object17X)&&(Y >= Object17_T+ object17Y)&&(Y <= Object17_B + object17Y));

localparam Object18_L = 31'd0;
localparam Object18_R = Object18_L + 31'd119;
localparam Object18_T = 31'd0;
localparam Object18_B = Object18_T + 31'd650;
assign Object18 =((X >= Object18_L + object18X)&&(X <= Object18_R + object18X)&&(Y >= Object18_T+ object18Y)&&(Y <= Object18_B + object18Y));

localparam Object19_L = 31'd0;
localparam Object19_R = Object19_L + 31'd119;
localparam Object19_T = 31'd0;
localparam Object19_B = Object19_T + 31'd650;
assign Object19 =((X >= Object19_L + object19X)&&(X <= Object19_R + object19X)&&(Y >= Object19_T+ object19Y)&&(Y <= Object19_B + object19Y));

localparam Object20_L = 31'd0;
localparam Object20_R = Object20_L + 31'd83;
localparam Object20_T = 31'd0;
localparam Object20_B = Object20_T + 31'd650;
assign Object20 =((X >= Object20_L + object20X)&&(X <= Object20_R + object20X)&&(Y >= Object20_T+ object20Y)&&(Y <= Object20_B + object20Y));


localparam Object21_L = 31'd0;
localparam Object21_R = Object21_L + 31'd119;
localparam Object21_T = 31'd0;
localparam Object21_B = Object21_T + 31'd650;
assign Object21 =((X >= Object21_L + object21X)&&(X <= Object21_R + object21X)&&(Y >= Object21_T+ object21Y)&&(Y <= Object21_B + object21Y));


localparam Object9_L = 31'd0;
localparam Object9_R = Object9_L + 31'd75;
localparam Object9_T = 31'd0;
localparam Object9_B = Object9_T + 31'd650;
assign Object9 =((X >= Object9_L + object9X)&&(X <= Object9_R + object9X)&&(Y >= Object9_T+ object9Y)&&(Y <= Object9_B + object9Y));


localparam Object10_L = 31'd0;
localparam Object10_R = Object10_L + 31'd75;
localparam Object10_T = 31'd0;
localparam Object10_B = Object10_T + 31'd650;
assign Object10 =((X >= Object10_L + object10X)&&(X <= Object10_R + object10X)&&(Y >= Object10_T+ object10Y)&&(Y <= Object10_B + object10Y));


localparam Object11_L = 31'd0;
localparam Object11_R = Object11_L + 31'd75;
localparam Object11_T = 31'd0;
localparam Object11_B = Object11_T + 31'd650;
assign Object11 =((X >= Object11_L + object11X)&&(X <= Object11_R + object11X)&&(Y >= Object11_T+ object11Y)&&(Y <= Object11_B + object11Y));


localparam Object12_L = 31'd0;
localparam Object12_R = Object12_L + 31'd75;
localparam Object12_T = 31'd0;
localparam Object12_B = Object12_T + 31'd650;
assign Object12 =((X >= Object12_L + object12X)&&(X <= Object12_R + object12X)&&(Y >= Object12_T+ object12Y)&&(Y <= Object12_B + object12Y));


localparam Object13_L = 31'd0;
localparam Object13_R = Object13_L + 31'd75;
localparam Object13_T = 31'd0;
localparam Object13_B = Object13_T + 31'd650;
assign Object13 =((X >= Object13_L + object13X)&&(X <= Object13_R + object13X)&&(Y >= Object13_T+ object13Y)&&(Y <= Object13_B + object13Y));






//======Borrowed Code======//
//==========DO NOT EDIT BELOW==========//
countingRefresh(X, Y, CLOCK_50, countRef );
clock108(rst, CLOCK_50, CLK_108, locked);

wire hblank, vblank, clkLine, blank;

//Sync the display
H_SYNC(CLK_108, VGA_HS, hblank, clkLine, X);
V_SYNC(clkLine, VGA_VS, vblank, Y);
//==========DO NOT EDIT ABOVE==========//


//======DISPLAY CODE IN ORDER OF LAYER IMPORTANCE======//
/*This block sets the priority of what to display in order, best to list in order of importance.
The lowercase variables translate the object-to-be-displayed decision to the color module.
*/
reg box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21;

//drawing shapes	
always@(*)
begin
	if(Object9) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b1;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object10) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b1;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object11) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b1;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object12) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b1;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object13) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b1;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object14) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b1;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object15) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b1;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
		
		
	else if(Object16) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b1;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object17) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b1;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object18) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b1;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object19) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b1;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object20) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b1;
		box21 = 1'b0;
		end
	else if(Object21) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b1;
		end
	else if(Object1) begin
		box1 = 1'b1;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object2) begin
		box1 = 1'b0;
		box2 = 1'b1;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object3) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b1;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object4) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b1;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object5) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b1;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object6) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b1;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object7) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b1;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	else if(Object8) begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b1;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end


	else begin
		box1 = 1'b0;
		box2 = 1'b0;
		box3 = 1'b0;
		box4 = 1'b0;
		box5 = 1'b0;
		box6 = 1'b0;
		box7 = 1'b0;
		box8 = 1'b0;
		box9 = 1'b0;
		box10 = 1'b0;
		box11 = 1'b0;
		box12 = 1'b0;
		box13 = 1'b0;
		box14 = 1'b0;
		box15 = 1'b0;
		box16 = 1'b0;
		box17 = 1'b0;
		box18 = 1'b0;
		box19 = 1'b0;
		box20 = 1'b0;
		box21 = 1'b0;
		end
	end 


//======Modified Borrowed Code======//
//Determines the color output based on the decision from the priority block
color(CLOCK_50, VGA_R, VGA_B, VGA_G, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, keydata);

//======Borrowed code======//
//======DO NOT EDIT========//
assign VGA_CLK = CLK_108;
assign VGA_BLANK_N = VGA_VS&VGA_HS;
assign VGA_SYNC_N = 1'b0;
endmodule


//Controls the counter
module countingRefresh(X, Y, CLOCK_50, count);
input [31:0]X, Y;
input CLOCK_50;
output [7:0]count;
reg[7:0]count;
always@(posedge CLOCK_50)
begin
	if(X==0 &&Y==0)
		count<=count+1;
	else if(count==7'd11)
		count<=0;
	else
		count<=count;
end

endmodule



//======Formatted like Borrowed code, adjust you own parameters======//
//============================//
//========== COLOR ===========//
//============================//
module color(CLOCK_50, red, blue, green, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21, keydata);

input CLOCK_50, box1, box2, box3, box4, box5, box6, box7, box8, box9, box10, box11, box12, box13, box14, box15, box16, box17, box18, box19, box20, box21;
input [15:0] keydata;

output [7:0] red, blue, green;
reg[7:0] red, green, blue;

always@(*)
begin
	if(box1) begin
		if (keydata[7:0] == 8'h15 && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	end
	else if(box2) begin
		if (keydata[7:0] == 8'h1D && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	end
	else if(box3) begin
		if (keydata[7:0] == 8'h24 && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		end
	else if(box4) begin
		if (keydata[7:0] == 8'h2D && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		end
	else if(box5) begin
		if (keydata[7:0] == 8'h2C && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		end
	else if(box6) begin
		if (keydata[7:0] == 8'h35 && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		end
	else if(box7) begin
		if (keydata[7:0] == 8'h3C && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		end
	else if(box8) begin
		if (keydata[7:0] == 8'h43 && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		end
	else if(box9) begin
		if (keydata[7:0] == 8'h1E && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd001;
		blue = 8'd001;
		green = 8'd001;
		end
		end
	else if(box10) begin
		if (keydata[7:0] == 16'h26 && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd001;
		blue = 8'd001;
		green = 8'd001;
		end
		end
	else if(box11) begin
		if (keydata[7:0] == 8'h2E && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd001;
		blue = 8'd001;
		green = 8'd001;
		end
		end
	else if(box12) begin
		if (keydata[7:0] == 8'h36 && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd001;
		blue = 8'd001;
		green = 8'd001;
		end
		end
	else if(box13) begin
		if (keydata[7:0] == 8'h3D && keydata[15:8] != 8'hF0)
		begin
		red = 8'd255;
		blue = 8'd001;
		green = 8'd255;
		end
		else
		begin
		red = 8'd001;
		blue = 8'd001;
		green = 8'd001;
		end
		end
	else if(box14) begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box15) begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box16) begin
	red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box17) begin
	red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box18) begin
	red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box19) begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box20) begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
	else if(box21) begin
		red = 8'd255;
		blue = 8'd255;
		green = 8'd255;
		end
		/* I have no idea why this block below won't work.
		its supposed to be the block that displays the background color, however any values other than 000 for R,G, and B
		will mess eveything up... 
		*/
	else begin
		red = 8'd0;
		blue = 8'd0;
		green = 8'd0;
		end
	end
	
endmodule





//====================================//
//========DO NOT EDIT PAST HERE=======//
//====================================//
/* --VGA CONTROLLER MODULES--
 * Controls vga output syncs and clk
 */
module H_SYNC(clk, hout, bout, newLine, Xcount);

input clk;
output hout, bout, newLine;
output [31:0] Xcount;
	
reg [31:0] count = 32'd0;
reg hsync, blank, new1;

always @(posedge clk) 
begin
	if (count <  1688)
		count <= Xcount + 1;
	else 
      count <= 0;
   end 

always @(*) 
begin
	if (count == 0)
		new1 = 1;
	else
		new1 = 0;
   end 

always @(*) 
begin
	if (count > 1279) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1328)
		hsync = 1;
   else if (count > 1327 && count < 1440)
		hsync = 0;
   else    
		hsync = 1;
	end

assign Xcount=count;
assign hout = hsync;
assign bout = blank;
assign newLine = new1;

endmodule


module V_SYNC(clk, vout, bout, Ycount);

input clk;
output vout, bout;
output [31:0]Ycount; 
	  
reg [31:0] count = 32'd0;
reg vsync, blank;

always @(posedge clk) 
begin
	if (count <  1066)
		count <= Ycount + 1;
   else 
            count <= 0;
   end 

always @(*) 
begin
	if (count < 1024) 
		blank = 1;
   else 
		blank = 0;
   end

always @(*) 
begin
	if (count < 1025)
		vsync = 1;
	else if (count > 1024 && count < 1028)
		vsync = 0;
	else    
		vsync = 1;
	end

assign Ycount=count;
assign vout = vsync;
assign bout = blank;

endmodule

//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module clock108 (areset, inclk0, c0, locked);

input     areset;
input     inclk0;
output    c0;
output    locked;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_off
`endif

tri0      areset;

`ifndef ALTERA_RESERVED_QIS
 //synopsys translate_on
`endif

wire [0:0] sub_wire2 = 1'h0;
wire [4:0] sub_wire3;
wire  sub_wire5;
wire  sub_wire0 = inclk0;
wire [1:0] sub_wire1 = {sub_wire2, sub_wire0};
wire [0:0] sub_wire4 = sub_wire3[0:0];
wire  c0 = sub_wire4;
wire  locked = sub_wire5;
	 
altpll  altpll_component (
            .areset (areset),
            .inclk (sub_wire1),
            .clk (sub_wire3),
            .locked (sub_wire5),
            .activeclock (),
            .clkbad (),
            .clkena ({6{1'b1}}),
            .clkloss (),
            .clkswitch (1'b0),
            .configupdate (1'b0),
            .enable0 (),
            .enable1 (),
            .extclk (),
            .extclkena ({4{1'b1}}),
            .fbin (1'b1),
            .fbmimicbidir (),
            .fbout (),
            .fref (),
            .icdrclk (),
            .pfdena (1'b1),
            .phasecounterselect ({4{1'b1}}),
            .phasedone (),
            .phasestep (1'b1),
            .phaseupdown (1'b1),
            .pllena (1'b1),
            .scanaclr (1'b0),
            .scanclk (1'b0),
            .scanclkena (1'b1),
            .scandata (1'b0),
            .scandataout (),
            .scandone (),
            .scanread (1'b0),
            .scanwrite (1'b0),
            .sclkout0 (),
            .sclkout1 (),
            .vcooverrange (),
            .vcounderrange ());
defparam
    altpll_component.bandwidth_type = "AUTO",
    altpll_component.clk0_divide_by = 25,
    altpll_component.clk0_duty_cycle = 50,
    altpll_component.clk0_multiply_by = 54,
    altpll_component.clk0_phase_shift = "0",
    altpll_component.compensate_clock = "CLK0",
    altpll_component.inclk0_input_frequency = 20000,
    altpll_component.intended_device_family = "Cyclone IV E",
    altpll_component.lpm_hint = "CBX_MODULE_PREFIX=clock108",
    altpll_component.lpm_type = "altpll",
    altpll_component.operation_mode = "NORMAL",
    altpll_component.pll_type = "AUTO",
    altpll_component.port_activeclock = "PORT_UNUSED",
    altpll_component.port_areset = "PORT_USED",
    altpll_component.port_clkbad0 = "PORT_UNUSED",
    altpll_component.port_clkbad1 = "PORT_UNUSED",
    altpll_component.port_clkloss = "PORT_UNUSED",
    altpll_component.port_clkswitch = "PORT_UNUSED",
    altpll_component.port_configupdate = "PORT_UNUSED",
    altpll_component.port_fbin = "PORT_UNUSED",
    altpll_component.port_inclk0 = "PORT_USED",
    altpll_component.port_inclk1 = "PORT_UNUSED",
    altpll_component.port_locked = "PORT_USED",
    altpll_component.port_pfdena = "PORT_UNUSED",
    altpll_component.port_phasecounterselect = "PORT_UNUSED",
    altpll_component.port_phasedone = "PORT_UNUSED",
    altpll_component.port_phasestep = "PORT_UNUSED",
    altpll_component.port_phaseupdown = "PORT_UNUSED",
    altpll_component.port_pllena = "PORT_UNUSED",
    altpll_component.port_scanaclr = "PORT_UNUSED",
    altpll_component.port_scanclk = "PORT_UNUSED",
    altpll_component.port_scanclkena = "PORT_UNUSED",
    altpll_component.port_scandata = "PORT_UNUSED",
    altpll_component.port_scandataout = "PORT_UNUSED",
    altpll_component.port_scandone = "PORT_UNUSED",
    altpll_component.port_scanread = "PORT_UNUSED",
    altpll_component.port_scanwrite = "PORT_UNUSED",
    altpll_component.port_clk0 = "PORT_USED",
    altpll_component.port_clk1 = "PORT_UNUSED",
    altpll_component.port_clk2 = "PORT_UNUSED",
    altpll_component.port_clk3 = "PORT_UNUSED",
    altpll_component.port_clk4 = "PORT_UNUSED",
    altpll_component.port_clk5 = "PORT_UNUSED",
    altpll_component.port_clkena0 = "PORT_UNUSED",
    altpll_component.port_clkena1 = "PORT_UNUSED",
    altpll_component.port_clkena2 = "PORT_UNUSED",
    altpll_component.port_clkena3 = "PORT_UNUSED",
    altpll_component.port_clkena4 = "PORT_UNUSED",
    altpll_component.port_clkena5 = "PORT_UNUSED",
    altpll_component.port_extclk0 = "PORT_UNUSED",
    altpll_component.port_extclk1 = "PORT_UNUSED",
    altpll_component.port_extclk2 = "PORT_UNUSED",
    altpll_component.port_extclk3 = "PORT_UNUSED",
    altpll_component.self_reset_on_loss_lock = "OFF",
    altpll_component.width_clock = 5;

endmodule
