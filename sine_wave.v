//
// Sine Wave ROM Table
//
module sine_wave(//input volume,	
input [15:0] key_press,
output [15:0] songout,
input clk_50
);

reg [19:0] count_C1=20'd0;
reg [19:0] count_DF1=20'd0;
reg [19:0] count_D1=20'd0;
reg [19:0] count_EF1=20'd0;
reg [19:0] count_E1=20'd0;
reg [19:0] count_F1=20'd0;
reg [19:0] count_GF1=20'd0;
reg [19:0] count_G1=20'd0;
reg [19:0] count_AF1=20'd0;
reg [19:0] count_A1=20'd0;
reg [19:0] count_BF1=20'd0;
reg [19:0] count_B1=20'd0;
reg [19:0] count_C2=20'd0;

reg [19:0] count_CSDF2=20'd0;
reg [19:0] count_D2=20'd0;
reg [19:0] count_DSEF2=20'd0;
reg [19:0] count_E2=20'd0;
reg [19:0] count_F2=20'd0;
reg [19:0] count_FSGF2=20'd0;
reg [19:0] count_G2=20'd0;
reg [19:0] count_GSAF2=20'd0;
reg [19:0] count_A2=20'd0;
reg [19:0] count_ASBF2=20'd0;
reg [19:0] count_B2=20'd0;

reg [19:0] count_C3_1 = 20'd0;
reg [19:0] count_C3_2 = 20'd0;
reg [19:0] count_CSDF3=20'd0;
reg [19:0] count_D3_1=20'd0;
reg [19:0] count_D3_2 = 20'd0;
reg [19:0] count_DSEF3=20'd0;
reg [19:0] count_E3_1=20'd0;
reg [19:0] count_E3_2 = 20'd0;
reg [19:0] count_F3=20'd0;
reg [19:0] count_FSGF3=20'd0;
reg [19:0] count_G3=20'd0;
reg [19:0] count_GSAF3_1=20'd0;
reg [19:0] count_GSAF3_2 = 20'd0;
reg [19:0] count_A3=20'd0;
reg [19:0] count_ASBF3=20'd0;
reg [19:0] count_B3=20'd0;

reg [15:0] count_clk_1M;
reg [15:0] count_clk_media;
reg [15:0] count_clk_1Hz;

reg clk_C1;
reg clk_DF1;
reg clk_D1;
reg clk_EF1;
reg clk_E1;
reg clk_F1;
reg clk_GF1;
reg clk_G1;
reg clk_AF1;
reg clk_A1;
reg clk_BF1;
reg clk_B1;
reg clk_C2;

reg clk_CSDF2;
reg clk_D2;
reg clk_DSEF2;
reg clk_E2;
reg clk_F2;
reg clk_FSGF2;
reg clk_G2;
reg clk_GSAF2;
reg clk_A2;
reg clk_ASBF2;
reg clk_B2;
					
reg clk_C3_1;
reg clk_C3_2;
reg clk_CSDF3;
reg clk_D3_1;
reg clk_D3_2;
reg clk_DSEF3;
reg clk_E3_1;
reg clk_E3_2;
reg clk_F3;
reg clk_FSGF3;
reg clk_G3;
reg clk_GSAF3_1;
reg clk_GSAF3_2;
reg clk_A3;
reg clk_ASBF3;
reg clk_B3;

reg clk_1M;
reg clk_media;
reg clk_1Hz;
reg clk_choose;

reg [7:0] index;

parameter PERIOD = 48;
//1Mhz clk
always @(posedge clk_50)
begin
	if (count_clk_1M < 4'd24) 
		begin
			count_clk_1M <= count_clk_1M + 1'b1;
		end
	else
		begin
			count_clk_1M <= 20'b0;
			clk_1M <= ~clk_1M;
		end
end
//1Hz clk
always @(posedge clk_1M)
begin
	if (count_clk_media < 16'd499) 
		begin
			count_clk_media <= count_clk_media + 1'b1;
		end
	else
		begin
			count_clk_media <= 20'b0;
			clk_media <= ~clk_media;
		end
end

always @(posedge clk_media)
begin
	if (count_clk_1Hz < 16'd49999) 
		begin
			count_clk_1Hz <= count_clk_1Hz + 1'b1;
		end
	else
		begin
			count_clk_1Hz <= 20'b0;
			clk_1Hz <= ~clk_1Hz;
		end
end
//clk for C3
always @(posedge clk_1M)
begin
	if (count_C3_1 < 4'd0)
		begin
			count_C3_1 <= count_C3_1 + 1'b1;
		end
	else	
		begin
			count_C3_1 <= 20'b0;
			clk_C3_1 <= ~clk_C3_1;
		end
end

always @(posedge clk_C3_1)
begin
	if (count_C3_2 < 4'd9)
		begin
			count_C3_2 <= count_C3_2 + 1'b1;
		end
	else	
		begin
			count_C3_2 <= 20'b0;
			clk_C3_2 <= ~clk_C3_2;
		end
end
//clk for CSDF3
always @(posedge clk_1M)
begin
	if (count_CSDF3 < 4'd28)
		begin
			count_CSDF3 <= count_CSDF3 + 1'b1;
		end
	else	
		begin
			count_CSDF3 <= 20'b0;
			clk_CSDF3 <= ~clk_CSDF3;
		end
end
//clk for D3
always @(posedge clk_1M)
begin
	if (count_D3_1 < 4'd2)
		begin
			count_D3_1 <= count_D3_1 + 1'b1;
		end
	else	
		begin
			count_D3_1 <= 20'b0;
			clk_D3_1 <= ~clk_D3_1;
		end
end

always @(posedge clk_D3_1)
begin
	if (count_D3_2 < 4'd2)
		begin
			count_D3_2 <= count_D3_2 + 1'b1;
		end
	else	
		begin
			count_D3_2 <= 20'b0;
			clk_D3_2 <= ~clk_D3_2;
		end
end
//clk for DSEF3
always @(posedge clk_1M)
begin
	if (count_DSEF3 < 4'd29)
		begin
			count_DSEF3 <= count_DSEF3 + 1'b1;
		end
	else	
		begin
			count_DSEF3 <= 20'b0;
			clk_DSEF3 <= ~clk_DSEF3;
		end
end
//clk for E3
always @(posedge clk_1M)
begin
	if (count_E3_1 < 4'd1)
		begin
			count_E3_1 <= count_E3_1 + 1'b1;
		end
	else	
		begin
			count_E3_1 <= 20'b0;
			clk_E3_1 <= ~clk_E3_1;
		end
end

always @(posedge clk_E3_1)
begin
	if (count_E3_2 < 4'd3)
		begin
			count_E3_2 <= count_E3_2 + 1'b1;
		end
	else	
		begin
			count_E3_2 <= 20'b0;
			clk_E3_2 <= ~clk_E3_2;
		end
end
//clk for F3
always @(posedge clk_1M)
begin
	if (count_F3 < 4'd14)
		begin
			count_F3 <= count_F3 + 1'b1;
		end
	else	
		begin
			count_F3 <= 20'b0;
			clk_F3 <= ~clk_F3;
		end
end
//clk for FSGF3
always @(posedge clk_1M)
begin
	if (count_FSGF3 < 4'd13)
		begin
			count_FSGF3 <= count_FSGF3 + 1'b1;
		end
	else	
		begin
			count_FSGF3 <= 20'b0;
			clk_FSGF3 <= ~clk_FSGF3;
		end
end
//clk for G3
always @(posedge clk_1M)
begin
	if (count_G3 < 4'd12)
		begin
			count_G3 <= count_G3 + 1'b1;
		end
	else	
		begin
			count_G3 <= 20'b0;
			clk_G3 <= ~clk_G3;
		end
end
//clk for GSAF3
always @(posedge clk_1M)
begin
	if (count_GSAF3_1 < 4'd1)
		begin
			count_GSAF3_1 <= count_GSAF3_1 + 1'b1;
		end
	else	
		begin
			count_GSAF3_1 <= 20'b0;
			clk_GSAF3_1 <= ~clk_GSAF3_1;
		end
end

always @(posedge clk_GSAF3_1)
begin
	if (count_GSAF3_2 < 4'd2)
		begin
			count_GSAF3_2 <= count_GSAF3_2 + 1'b1;
		end
	else	
		begin
			count_GSAF3_2 <= 20'b0;
			clk_GSAF3_2 <= ~clk_GSAF3_2;
		end
end
//clk for A3
always @(posedge clk_1M)
begin
	if (count_A3 < 4'd10)
		begin
			count_A3 <= count_A3 + 1'b1;
		end
	else	
		begin
			count_A3 <= 20'b0;
			clk_A3 <= ~clk_A3;
		end
end
//clk for ASBF3
always @(posedge clk_1M)
begin
	if (count_ASBF3 < 4'd9)
		begin
			count_ASBF3 <= count_ASBF3 + 1'b1;
		end
	else	
		begin
			count_ASBF3 <= 20'b0;
			clk_ASBF3 <= ~clk_ASBF3;
		end
end
//clk for B3
always @(posedge clk_1M)
begin
	if (count_B3 < 4'd8)
		begin
			count_B3 <= count_B3 + 1'b1;
		end
	else	
		begin
			count_B3 <= 20'b0;
			clk_B3 <= ~clk_B3;
		end
end




//clk for C2
always @(posedge clk_C3_2)
begin
	if (count_C2 < 4'd0)
		begin
			count_C2 <= count_C2 + 1'b1;
		end
	else	
		begin
			count_C2 <= 20'b0;
			clk_C2 <= ~clk_C2;
		end
end

//clk for CSDF2
always @(posedge clk_CSDF3)
begin
	if (count_CSDF2 < 4'd0)
		begin
			count_CSDF2 <= count_CSDF2 + 1'b1;
		end
	else	
		begin
			count_CSDF2 <= 20'b0;
			clk_CSDF2 <= ~clk_CSDF2;
		end
end
//clk for D2
always @(posedge clk_D3_2)
begin
	if (count_D2 < 4'd0)
		begin
			count_D2 <= count_D2 + 1'b1;
		end
	else	
		begin
			count_D2 <= 20'b0;
			clk_D2 <= ~clk_D2;
		end
end
//clk for DSEF2
always @(posedge clk_DSEF3)
begin
	if (count_DSEF2 < 4'd0)
		begin
			count_DSEF2 <= count_DSEF2 + 1'b1;
		end
	else	
		begin
			count_DSEF2 <= 20'b0;
			clk_DSEF2 <= ~clk_DSEF2;
		end
end
//clk for E2
always @(posedge clk_E3_2)
begin
	if (count_E2 < 4'd0)
		begin
			count_E2 <= count_E2 + 1'b1;
		end
	else	
		begin
			count_E2 <= 20'b0;
			clk_E2 <= ~clk_E2;
		end
end
//clk for F2
always @(posedge clk_F3)
begin
	if (count_F2 < 4'd0)
		begin
			count_F2 <= count_F2 + 1'b1;
		end
	else	
		begin
			count_F2 <= 20'b0;
			clk_F2 <= ~clk_F2;
		end
end
//clk for FSGF2
always @(posedge clk_FSGF3)
begin
	if (count_FSGF2 < 4'd0)
		begin
			count_FSGF2 <= count_FSGF2 + 1'b1;
		end
	else	
		begin
			count_FSGF2 <= 20'b0;
			clk_FSGF2 <= ~clk_FSGF2;
		end
end
//clk for G2
always @(posedge clk_G3)
begin
	if (count_G2 < 4'd0)
		begin
			count_G2 <= count_G2 + 1'b1;
		end
	else	
		begin
			count_G2 <= 20'b0;
			clk_G2 <= ~clk_G2;
		end
end
//clk for GSAF2
always @(posedge clk_GSAF3_2)
begin
	if (count_GSAF2 < 4'd0)
		begin
			count_GSAF2 <= count_GSAF2 + 1'b1;
		end
	else	
		begin
			count_GSAF2 <= 20'b0;
			clk_GSAF2 <= ~clk_GSAF2;
		end
end
//clk for A2
always @(posedge clk_A3)
begin
	if (count_A2 < 4'd0)
		begin
			count_A2 <= count_A2 + 1'b1;
		end
	else	
		begin
			count_A2 <= 20'b0;
			clk_A2 <= ~clk_A2;
		end
end
//clk for ASBF2
always @(posedge clk_ASBF3)
begin
	if (count_ASBF2 < 4'd0)
		begin
			count_ASBF2 <= count_ASBF2 + 1'b1;
		end
	else	
		begin
			count_ASBF2 <= 20'b0;
			clk_ASBF2 <= ~clk_ASBF2;
		end
end
//clk for B2
always @(posedge clk_B3)
begin
	if (count_B2 < 4'd0)
		begin
			count_B2 <= count_B2 + 1'b1;
		end
	else	
		begin
			count_B2 <= 20'b0;
			clk_B2 <= ~clk_B2;
		end
end








//clk for C1
always @(posedge clk_C2)
begin
	if (count_C1 < 4'd0)
		begin
			count_C1 <= count_C1 + 1'b1;
		end
	else	
		begin
			count_C1 <= 20'b0;
			clk_C1 <= ~clk_C1;
		end
end
//clk for DF1
always @(posedge clk_CSDF2)
begin
	if (count_DF1 < 4'd0)
		begin
			count_DF1 <= count_DF1 + 1'b1;
		end
	else	
		begin
			count_DF1 <= 20'b0;
			clk_DF1 <= ~clk_DF1;
		end
end
//clk for D1
always @(posedge clk_D2)
begin
	if (count_D1 < 4'd0)
		begin
			count_D1 <= count_D1 + 1'b1;
		end
	else	
		begin
			count_D1 <= 20'b0;
			clk_D1 <= ~clk_D1;
		end
end
//clk for EF1
always @(posedge clk_DSEF2)
begin
	if (count_EF1 < 4'd0)
		begin
			count_EF1 <= count_EF1 + 1'b1;
		end
	else	
		begin
			count_EF1 <= 20'b0;
			clk_EF1 <= ~clk_EF1;
		end
end
//clk for E1
always @(posedge clk_E2)
begin
	if (count_E1 < 4'd0)
		begin
			count_E1 <= count_E1 + 1'b1;
		end
	else	
		begin
			count_E1 <= 20'b0;
			clk_E1 <= ~clk_E1;
		end
end
//clk for F1
always @(posedge clk_F2)
begin
	if (count_F1 < 4'd0)
		begin
			count_F1 <= count_F1 + 1'b1;
		end
	else	
		begin
			count_F1 <= 20'b0;
			clk_F1 <= ~clk_F1;
		end
end
//clk for GF1
always @(posedge clk_FSGF2)
begin
	if (count_GF1 < 4'd0)
		begin
			count_GF1 <= count_GF1 + 1'b1;
		end
	else	
		begin
			count_GF1 <= 20'b0;
			clk_GF1 <= ~clk_GF1;
		end
end
//clk for G1
always @(posedge clk_G2)
begin
	if (count_G1 < 4'd0)
		begin
			count_G1 <= count_G1 + 1'b1;
		end
	else	
		begin
			count_G1 <= 20'b0;
			clk_G1 <= ~clk_G1;
		end
end
//clk for AF1
always @(posedge clk_GSAF2)
begin
	if (count_AF1 < 4'd0)
		begin
			count_AF1 <= count_AF1 + 1'b1;
		end
	else	
		begin
			count_AF1 <= 20'b0;
			clk_AF1 <= ~clk_AF1;
		end
end
//clk for A1
always @(posedge clk_A2)
begin
	if (count_A1 < 4'd0)
		begin
			count_A1 <= count_A1 + 1'b1;
		end
	else	
		begin
			count_A1 <= 20'b0;
			clk_A1 <= ~clk_A1;
		end
end
//clk for BF1
always @(posedge clk_ASBF2)
begin
	if (count_BF1 < 4'd0)
		begin
			count_BF1 <= count_BF1 + 1'b1;
		end
	else	
		begin
			count_BF1 <= 20'b0;
			clk_BF1 <= ~clk_BF1;
		end
end
//clk for B1
always @(posedge clk_B2)
begin
	if (count_B1 < 4'd0)
		begin
			count_B1 <= count_B1 + 1'b1;
		end
	else	
		begin
			count_B1 <= 20'b0;
			clk_B1 <= ~clk_B1;
		end
end




always @(*)
begin
	if ((key_press [7:0] == 8'h15) && (key_press [15:8] !== 8'hf0))
		clk_choose = clk_C1;
	
	else if ((key_press [7:0] == 8'h1e)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_DF1;
	
	else if ((key_press [7:0] == 8'h1d)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_D1;
	
	else if ((key_press [7:0] == 8'h26)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_EF1;
	
	else if ((key_press [7:0] == 8'h24)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_E1;
	
	else if ((key_press [7:0] == 8'h2d)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_F1;
	
	else if ((key_press [7:0] == 8'h2e)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_GF1;
	
	else if ((key_press [7:0] == 8'h2c)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_G1;
	
	else if ((key_press [7:0] == 8'h36)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_AF1;
	
	else if ((key_press [7:0] == 8'h35)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_A1;
	
	else if ((key_press [7:0] == 8'h3d)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_BF1;
	
	else if ((key_press [7:0] == 8'h3c)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_B1;
	
	
	else if ((key_press [7:0] == 8'h43)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_C2;
	
	/*else if ((key_press [7:0] == 8'h1d)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_CSDF2;
	
	else if ((key_press [7:0] == 8'h24)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_D2;
	
	else if ((key_press [7:0] == 8'h2d)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_DSEF2;
	
	else if ((key_press [7:0] == 8'h2c)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_E2;
	
	else if ((key_press [7:0] == 8'h35)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_F2;
	
	else if ((key_press [7:0] == 8'h3c)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_FSGF2;
	
	else if ((key_press [7:0] == 8'h43)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_G2;
	
	else if ((key_press [7:0] == 8'h44)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_GSAF2;
	
	else if ((key_press [7:0] == 8'h4d)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_A2;
	
	else if ((key_press [7:0] == 8'h54)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_ASBF2;
	
	else if ((key_press [7:0] == 8'h5b)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_B2;

		
	else if ((key_press [7:0] == 8'h1c)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_C3_2;
	
	else if ((key_press [7:0] == 8'h1b)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_CSDF3;
	
	else if ((key_press [7:0] == 8'h23)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_D3_2;
	
	else if ((key_press [7:0] == 8'h2b)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_DSEF3;
	
	else if ((key_press [7:0] == 8'h34)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_E3_2;
	
	else if ((key_press [7:0] == 8'h33)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_F3;
	
	else if ((key_press [7:0] == 8'h3b)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_FSGF3;
	
	else if ((key_press [7:0] == 8'h42)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_G3;
	
	else if ((key_press [7:0] == 8'h4b)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_GSAF3_2;
	
	else if ((key_press [7:0] == 8'h4c)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_A3;
	
	else if ((key_press [7:0] == 8'h52)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_ASBF3;
	
	else if ((key_press [7:0] == 8'h4a)&& (key_press [15:8] !== 8'hf0))
		clk_choose = clk_B3;
*/
	
	else
		clk_choose = clk_1Hz;
end







always @(posedge clk_choose)
		if (index<PERIOD-1) index <= index + 1'b1;
		else index <= 8'h00;

sine_table sine_wave_1(
//volume,
index,
songout
);


endmodule

module sine_table(
//input volume,
input [7:0] index,
output [15:0] signal
);
parameter PERIOD = 48; // length of table

assign signal = sine;
reg [15:0] sine;
        
always@(index)
begin
	/*if (volume == 1'b1)
	begin
		case(index)
		0  :  sine       <=      0       ;
		1  :  sine       <=      4276    ;
		2  :  sine       <=      8480    ;
		3  :  sine       <=      12539   ;
		4  :  sine       <=      16383   ;
		5  :  sine       <=      19947   ;
		6  :  sine       <=      23169   ;
		7  :  sine       <=      25995   ;
		8  :  sine       <=      28377   ;
		9  :  sine       <=      30272   ;
		10  :  sine      <=      31650   ;
		11  :  sine      <=      32486   ;
		12  :  sine      <=      32767   ;
		13  :  sine      <=      32486   ;
		14  :  sine      <=      31650   ;
		15  :  sine      <=      30272   ;
		16  :  sine      <=      28377   ;
		17  :  sine      <=      25995   ;
		18  :  sine      <=      23169   ;
		19  :  sine      <=      19947   ;
		20  :  sine      <=      16383   ;
		21  :  sine      <=      12539   ;
		22  :  sine      <=      8480    ;
		23  :  sine      <=      4276    ;
		24  :  sine      <=      0       ;
		25  :  sine      <=      61259   ;
		26  :  sine      <=      57056   ;
		27  :  sine      <=      52997   ;
		28  :  sine      <=      49153   ;
		29  :  sine      <=      45589   ;
		30  :  sine      <=      42366   ;
		31  :  sine      <=      39540   ;
		32  :  sine      <=      37159   ;
		33  :  sine      <=      35263   ;
		34  :  sine      <=      33885   ;
		35  :  sine      <=      33049   ;
		36  :  sine      <=      32768   ;
		37  :  sine      <=      33049   ;
		38  :  sine      <=      33885   ;
		39  :  sine      <=      35263   ;
		40  :  sine      <=      37159   ;
		41  :  sine      <=      39540   ;
		42  :  sine      <=      42366   ;
		43  :  sine      <=      45589   ;
		44  :  sine      <=      49152   ;
		45  :  sine      <=      52997   ;
		46  :  sine      <=      57056   ;
		47  :  sine      <=      61259   ;
		default   : sine   <=   0   ;
		endcase
	end
	else
	begin*/
		case(index)
		0  :  sine       <=      0       ;
		1  :  sine       <=      2134    ;
		2  :  sine       <=      4240    ;
		3  :  sine       <=      6270   ;
		4  :  sine       <=      8192   ;
		5  :  sine       <=      9974   ;
		6  :  sine       <=      11585   ;
		7  :  sine       <=      12998   ;
		8  :  sine       <=      14189   ;
		9  :  sine       <=      15136   ;
		10  :  sine      <=      15825   ;
		11  :  sine      <=      16243   ;
		12  :  sine      <=      16384   ;
		13  :  sine      <=      16243   ;
		14  :  sine      <=      15825   ;
		15  :  sine      <=      15136   ;
		16  :  sine      <=      14189   ;
		17  :  sine      <=      12998   ;
		18  :  sine      <=      11585   ;
		19  :  sine      <=      9974   ;
		20  :  sine      <=      8192   ;
		21  :  sine      <=      6270   ;
		22  :  sine      <=      4240    ;
		23  :  sine      <=      2134    ;
		24  :  sine      <=      0       ;
		25  :  sine      <=      63402   ;
		26  :  sine      <=      61296   ;
		27  :  sine      <=      59266   ;
		28  :  sine      <=      57344   ;
		29  :  sine      <=      55562   ;
		30  :  sine      <=      53951   ;
		31  :  sine      <=      52538   ;
		32  :  sine      <=      51347   ;
		33  :  sine      <=      50400   ;
		34  :  sine      <=      49711   ;
		35  :  sine      <=      49293   ;
		36  :  sine      <=      49152   ;
		37  :  sine      <=      49293   ;
		38  :  sine      <=      49711   ;
		39  :  sine      <=      50400   ;
		40  :  sine      <=      51347   ;
		41  :  sine      <=      52538   ;
		42  :  sine      <=      53951   ;
		43  :  sine      <=      55562   ;
		44  :  sine      <=      57344   ;
		45  :  sine      <=      59266   ;
		46  :  sine      <=      61296   ;
		47  :  sine      <=      63402   ;
		default   : sine   <=   0   ;
		endcase
	//end
end
endmodule
