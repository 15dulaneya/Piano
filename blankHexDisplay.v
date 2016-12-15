// Displays hex characters to the 7-segment display

module blankHexDisplay(hexOut);
// displays all parts of the 7-segment display blank

	output[6:0] hexOut;
	wire blank = 1'b1;
	
	assign hexOut[0] = blank;
	assign hexOut[1] = blank;
	assign hexOut[2] = blank;
	assign hexOut[3] = blank;
	assign hexOut[4] = blank;
	assign hexOut[5] = blank;
	assign hexOut[6] = blank;
endmodule

module hexDisplay(in, hexOut);
// converts a 4-bit input to a hex character on the 7-segment display
	
	input[3:0]in;
	
	output[6:0] hexOut;
	reg[6:0] hexOut;
	
	reg A, B, C, D;
	
	always@(*)
	begin
		A = in[3];
		B = in[2];
		C = in[1];
		D = in[0];
		
		hexOut[0] = ~((~B&~D)|(B&C)|(A&~D)|(~A&C)|(~A&B&D)|(A&~B&~C));
		hexOut[1] = ~((~A&~C&~D)|(A&~C&D)|(~A&C&D)|(~B&~D)|(~B&~C));
		hexOut[2] = ~((~A&~C)|(~A&D)|(~C&D)|(~A&B)|(A&~B));
		hexOut[3] = ~((A&~C&~D)|(~A&~B&~D)|(B&C&~D)|(~B&C&D)|(B&~C&D));
		hexOut[4] = ~((A&~D)|(C&~D)|(A&B)|(A&C)|(~B&~D));
		hexOut[5] = ~((A&~B)|(A&C)|(B&~D)|(~C&~D)|(~A&B&~C));
		hexOut[6] = ~((A&~B)|(A&D)|(C&~D)|(~B&C)|(~A&B&~C));
	end	
endmodule
