module note_generation(
input clk,
input rst,
input hi_lo,

output [15:0] c1,
output [15:0] df1,
output [15:0] d1,
output [15:0] ef1,
output [15:0] e1,
output [15:0] f1,
output [15:0] gf1,
output [15:0] g1,
output [15:0] af1,
output [15:0] a1,
output [15:0] bf1,
output [15:0] b1,
output [15:0] c2,

output [15:0] csdf2,
output [15:0] d2,
output [15:0] dsef2,
output [15:0] e2,
output [15:0] f2,
output [15:0] fsgf2,
output [15:0] g2,
output [15:0] gsaf2,
output [15:0] a2,
output [15:0] asbf2,
output [15:0] b2,

output [15:0] c3,
output [15:0] csdf3,
output [15:0] d3,
output [15:0] dsef3,
output [15:0] e3,
output [15:0] f3,
output [15:0] fsgf3,
output [15:0] g3,
output [15:0] gsaf3,
output [15:0] a3,
output [15:0] asbf3,
output [15:0] b3);



reg [15:0] C1=OFF;
reg [15:0] DF1=OFF;
reg [15:0] D1=OFF;
reg [15:0] EF1=OFF;
reg [15:0] E1=OFF;
reg [15:0] F1=OFF;
reg [15:0] GF1=OFF;
reg [15:0] G1=OFF;
reg [15:0] AF1=OFF;
reg [15:0] A1=OFF;
reg [15:0] BF1=OFF;
reg [15:0] B1=OFF;
reg [15:0] C2=OFF;

reg [15:0] CSDF2=OFF;
reg [15:0] D2=OFF;
reg [15:0] DSEF2=OFF;
reg [15:0] E2=OFF;
reg [15:0] F2=OFF;
reg [15:0] FSGF2=OFF;
reg [15:0] G2=OFF;
reg [15:0] GSAF2=OFF;
reg [15:0] A2=OFF;
reg [15:0] ASBF2=OFF;
reg [15:0] B2=OFF;

reg [15:0] C3=OFF;
reg [15:0] CSDF3=OFF;
reg [15:0] D3=OFF;
reg [15:0] DSEF3=OFF;
reg [15:0] E3=OFF;
reg [15:0] F3=OFF;
reg [15:0] FSGF3=OFF;
reg [15:0] G3=OFF;
reg [15:0] GSAF3=OFF;
reg [15:0] A3=OFF;
reg [15:0] ASBF3=OFF;
reg [15:0] B3=OFF;

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

reg [19:0] count_C3=20'd0;
reg [19:0] count_CSDF3=20'd0;
reg [19:0] count_D3=20'd0;
reg [19:0] count_DSEF3=20'd0;
reg [19:0] count_E3=20'd0;
reg [19:0] count_F3=20'd0;
reg [19:0] count_FSGF3=20'd0;
reg [19:0] count_G3=20'd0;
reg [19:0] count_GSAF3=20'd0;
reg [19:0] count_A3=20'd0;
reg [19:0] count_ASBF3=20'd0;
reg [19:0] count_B3=20'd0;
			
parameter DIV_C1=20'd191113;
parameter DIV_DF1=20'd180386;
parameter DIV_D1=20'd170262;
parameter DIV_EF1=20'd160706;
parameter DIV_E1=20'd151686;
parameter DIV_F1=20'd143173;
parameter DIV_GF1=20'd135137;
parameter DIV_G1=20'd127553;
parameter DIV_AF1=20'd120393;
parameter DIV_A1=20'd113636;
parameter DIV_BF1=20'd107258;
parameter DIV_B1=20'd101239;
parameter DIV_C2=20'd95556;

parameter DIV_CSDF2=20'd90193;
parameter DIV_D2=20'd85131;
parameter DIV_DSEF2=20'd80353;
parameter DIV_E2=20'd75843;
parameter DIV_F2=20'd71587;
parameter DIV_FSGF2=20'd67569;
parameter DIV_G2=20'd63776;
parameter DIV_GSAF2=20'd60197;
parameter DIV_A2=20'd56818;
parameter DIV_ASBF2=20'd53629;
parameter DIV_B2=20'd50619;

parameter DIV_C3=20'd47778;
parameter DIV_CSDF3=20'd45097;
parameter DIV_D3=20'd42566;
parameter DIV_DSEF3=20'd40177;
parameter DIV_E3=20'd37922;
parameter DIV_F3=20'd35794;
parameter DIV_FSGF3=20'd33785;
parameter DIV_G3=20'd31888;
parameter DIV_GSAF3=20'd30099;
parameter DIV_A3=20'd28409;
parameter DIV_ASBF3=20'd26815;
parameter DIV_B3=20'd25310;
		
parameter OFF = 16'b0;
//parameter ON = 16'b0111111111111111;

reg [15:0] ON;

always @ (hi_lo)
begin
if (hi_lo==1'b1)
	begin
	ON<=16'b0011111111111111;
	end
	else
	begin
	ON<=16'b0001111111111111;
	end
end
						
always @ (posedge clk or negedge rst) 
begin	
	if (rst==1'b0)
		begin
count_C1<=20'd0;
count_DF1<=20'd0;
count_D1<=20'd0;
count_EF1<=20'd0;
count_E1<=20'd0;
count_F1<=20'd0;
count_GF1<=20'd0;
count_G1<=20'd0;
count_AF1<=20'd0;
count_A1<=20'd0;
count_BF1<=20'd0;
count_B1<=20'd0;
count_C2<=20'd0;

count_CSDF2<=20'd0;
count_D2<=20'd0;
count_DSEF2<=20'd0;
count_E2<=20'd0;
count_F2<=20'd0;
count_FSGF2<=20'd0;
count_G2<=20'd0;
count_GSAF2<=20'd0;
count_A2<=20'd0;
count_ASBF2<=20'd0;
count_B2<=20'd0;

count_C3<=20'd0;
count_CSDF3<=20'd0;
count_D3<=20'd0;
count_DSEF3<=20'd0;
count_E3<=20'd0;
count_F3<=20'd0;
count_FSGF3<=20'd0;
count_G3<=20'd0;
count_GSAF3<=20'd0;
count_A3<=20'd0;
count_ASBF3<=20'd0;
count_B3<=20'd0;

C1<=OFF;
DF1<=OFF;
D1<=OFF;
EF1<=OFF;
E1<=OFF;
F1<=OFF;
GF1<=OFF;
G1<=OFF;
AF1<=OFF;
A1<=OFF;
BF1<=OFF;
B1<=OFF;
C2<=OFF;

CSDF2<=OFF;
D2<=OFF;
DSEF2<=OFF;
E2<=OFF;
F2<=OFF;
FSGF2<=OFF;
G2<=OFF;
GSAF2<=OFF;
A2<=OFF;
ASBF2<=OFF;
B2<=OFF;

C3<=OFF;
CSDF3<=OFF;
D3<=OFF;
DSEF3<=OFF;
E3<=OFF;
F3<=OFF;
FSGF3<=OFF;
G3<=OFF;
GSAF3<=OFF;
A3<=OFF;
ASBF3<=OFF;
B3<=OFF;
end
else
begin
if (count_C1 < DIV_C1) 
begin
count_C1<=count_C1+1'b1;
end
else
begin
count_C1<=20'b0;
C1<=(C1==OFF)?ON:OFF;
end

if (count_DF1 < DIV_DF1) 
begin
count_DF1<=count_DF1+1'b1;
end
else
begin
count_DF1<=20'b0;
DF1<=(DF1==OFF)?ON:OFF;
end

if (count_D1 < DIV_D1) 
begin
count_D1<=count_D1+1'b1;
end
else
begin
count_D1<=20'b0;
D1<=(D1==OFF)?ON:OFF;
end

if (count_EF1 < DIV_EF1) 
begin
count_EF1<=count_EF1+1'b1;
end
else
begin
count_EF1<=20'b0;
EF1<=(EF1==OFF)?ON:OFF;
end

if (count_E1 < DIV_E1) 
begin
count_E1<=count_E1+1'b1;
end
else
begin
count_E1<=20'b0;
E1<=(E1==OFF)?ON:OFF;
end

if (count_F1 < DIV_F1) 
begin
count_F1<=count_F1+1'b1;
end
else
begin
count_F1<=20'b0;
F1<=(F1==OFF)?ON:OFF;
end

if (count_GF1 < DIV_GF1) 
begin
count_GF1<=count_GF1+1'b1;
end
else
begin
count_GF1<=20'b0;
GF1<=(GF1==OFF)?ON:OFF;
end

if (count_G1 < DIV_G1) 
begin
count_G1<=count_G1+1'b1;
end
else
begin
count_G1<=20'b0;
G1<=(G1==OFF)?ON:OFF;
end

if (count_AF1 < DIV_AF1) 
begin
count_AF1<=count_AF1+1'b1;
end
else
begin
count_AF1<=20'b0;
AF1<=(AF1==OFF)?ON:OFF;
end

if (count_A1 < DIV_A1) 
begin
count_A1<=count_A1+1'b1;
end
else
begin
count_A1<=20'b0;
A1<=(A1==OFF)?ON:OFF;
end

if (count_BF1 < DIV_BF1) 
begin
count_BF1<=count_BF1+1'b1;
end
else
begin
count_BF1<=20'b0;
BF1<=(BF1==OFF)?ON:OFF;
end

if (count_B1 < DIV_B1) 
begin
count_B1<=count_B1+1'b1;
end
else
begin
count_B1<=20'b0;
B1<=(B1==OFF)?ON:OFF;
end


if (count_C2 < DIV_C2) 
begin
count_C2<=count_C2+1'b1;
end
else
begin
count_C2<=20'b0;
C2<=(C2==OFF)?ON:OFF;
end

if (count_CSDF2 < DIV_CSDF2) 
begin
count_CSDF2<=count_CSDF2+1'b1;
end
else
begin
count_CSDF2<=20'b0;
CSDF2<=(CSDF2==OFF)?ON:OFF;
end

if (count_D2 < DIV_D2) 
begin
count_D2<=count_D2+1'b1;
end
else
begin
count_D2<=20'b0;
D2<=(D2==OFF)?ON:OFF;
end

if (count_DSEF2 < DIV_DSEF2) 
begin
count_DSEF2<=count_DSEF2+1'b1;
end
else
begin
count_DSEF2<=20'b0;
DSEF2<=(DSEF2==OFF)?ON:OFF;
end

if (count_E2 < DIV_E2) 
begin
count_E2<=count_E2+1'b1;
end
else
begin
count_E2<=20'b0;
E2<=(E2==OFF)?ON:OFF;
end

if (count_F2 < DIV_F2) 
begin
count_F2<=count_F2+1'b1;
end
else
begin
count_F2<=20'b0;
F2<=(F2==OFF)?ON:OFF;
end

if (count_FSGF2 < DIV_FSGF2) 
begin
count_FSGF2<=count_FSGF2+1'b1;
end
else
begin
count_FSGF2<=20'b0;
FSGF2<=(FSGF2==OFF)?ON:OFF;
end

if (count_G2 < DIV_G2) 
begin
count_G2<=count_G2+1'b1;
end
else
begin
count_G2<=20'b0;
G2<=(G2==OFF)?ON:OFF;
end

if (count_GSAF2 < DIV_GSAF2) 
begin
count_GSAF2<=count_GSAF2+1'b1;
end
else
begin
count_GSAF2<=20'b0;
GSAF2<=(GSAF2==OFF)?ON:OFF;
end

if (count_A2 < DIV_A2) 
begin
count_A2<=count_A2+1'b1;
end
else
begin
count_A2<=20'b0;
A2<=(A2==OFF)?ON:OFF;
end

if (count_ASBF2 < DIV_ASBF2) 
begin
count_ASBF2<=count_ASBF2+1'b1;
end
else
begin
count_ASBF2<=20'b0;
ASBF2<=(ASBF2==OFF)?ON:OFF;
end

if (count_B2 < DIV_B2) 
begin
count_B2<=count_B2+1'b1;
end
else
begin
count_B2<=20'b0;
B2<=(B2==OFF)?ON:OFF;
end


if (count_C3 < DIV_C3) 
begin
count_C3<=count_C3+1'b1;
end
else
begin
count_C3<=20'b0;
C3<=(C3==OFF)?ON:OFF;
end

if (count_CSDF3 < DIV_CSDF3) 
begin
count_CSDF3<=count_CSDF3+1'b1;
end
else
begin
count_CSDF3<=20'b0;
CSDF3<=(CSDF3==OFF)?ON:OFF;
end

if (count_D3 < DIV_D3) 
begin
count_D3<=count_D3+1'b1;
end
else
begin
count_D3<=20'b0;
D3<=(D3==OFF)?ON:OFF;
end

if (count_DSEF3 < DIV_DSEF3) 
begin
count_DSEF3<=count_DSEF3+1'b1;
end
else
begin
count_DSEF3<=20'b0;
DSEF3<=(DSEF3==OFF)?ON:OFF;
end

if (count_E3 < DIV_E3) 
begin
count_E3<=count_E3+1'b1;
end
else
begin
count_E3<=20'b0;
E3<=(E3==OFF)?ON:OFF;
end

if (count_F3 < DIV_F3) 
begin
count_F3<=count_F3+1'b1;
end
else
begin
count_F3<=20'b0;
F3<=(F3==OFF)?ON:OFF;
end

if (count_FSGF3 < DIV_FSGF3) 
begin
count_FSGF3<=count_FSGF3+1'b1;
end
else
begin
count_FSGF3<=20'b0;
FSGF3<=(FSGF3==OFF)?ON:OFF;
end

if (count_G3 < DIV_G3) 
begin
count_G3<=count_G3+1'b1;
end
else
begin
count_G3<=20'b0;
G3<=(G3==OFF)?ON:OFF;
end

if (count_GSAF3 < DIV_GSAF3) 
begin
count_GSAF3<=count_GSAF3+1'b1;
end
else
begin
count_GSAF3<=20'b0;
GSAF3<=(GSAF3==OFF)?ON:OFF;
end

if (count_A3 < DIV_A3) 
begin
count_A3<=count_A3+1'b1;
end
else
begin
count_A3<=20'b0;
A3<=(A3==OFF)?ON:OFF;
end

if (count_ASBF3 < DIV_ASBF3) 
begin
count_ASBF3<=count_ASBF3+1'b1;
end
else
begin
count_ASBF3<=20'b0;
ASBF3<=(ASBF3==OFF)?ON:OFF;
end

if (count_B3 < DIV_B3) 
begin
count_B3<=count_B3+1'b1;
end
else
begin
count_B3<=20'b0;
B3<=(B3==OFF)?ON:OFF;
end
end
end	

assign c1=C1;
assign df1=DF1;
assign d1=D1;
assign ef1=EF1;
assign e1=E1;
assign f1=F1;
assign gf1=GF1;
assign g1=G1;
assign af1=AF1;
assign a1=A1;
assign bf1=BF1;
assign b1=B1;
assign c2=C2;

assign csdf2=CSDF2;
assign d2=D2;
assign dsef2=DSEF2;
assign e2=E2;
assign f2=F2;
assign fsgf2=FSGF2;
assign g2=G2;
assign gsaf2=GSAF2;
assign a2=A2;
assign asbf2=ASBF2;
assign b2=B2;

assign c3=C3;
assign csdf3=CSDF3;
assign d3=D3;
assign dsef3=DSEF3;
assign e3=E3;
assign f3=F3;
assign fsgf3=FSGF3;
assign g3=G3;
assign gsaf3=GSAF3;
assign a3=A3;
assign asbf3=ASBF3;
assign b3=B3;
	 
endmodule
					