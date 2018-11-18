
module riscv32ima_gprf(
clk,
nrst,

read0_reg_addr,
read0_reg_data,

read1_reg_addr,
read1_reg_data,

wback_reg_wen,
wback_reg_addr,
wback_reg_data

);

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 64;
parameter REG_ADDR_WIDTH = 5;
parameter REG_DATA_WIDTH = 32;
parameter OPCODE_WIDTH = 7;
parameter FUNC3_WIDTH = 3;
parameter FUNC7_WIDTH = 7;

input clk;
input nrst;

input  [REG_ADDR_WIDTH-1:0] read0_reg_addr;
output reg [REG_DATA_WIDTH-1:0] read0_reg_data;

input  [REG_ADDR_WIDTH-1:0] read1_reg_addr;
output reg [REG_DATA_WIDTH-1:0] read1_reg_data;

input wback_reg_wen;
input [REG_ADDR_WIDTH-1:0] wback_reg_addr;
input [REG_DATA_WIDTH-1:0] wback_reg_data;

wire X00;
reg  X01;
reg  X02;
reg  X03;
reg  X04;
reg  X05;
reg  X06;
reg  X07;
reg  X08;
reg  X09;
reg  X0A;
reg  X0B;
reg  X0C;
reg  X0D;
reg  X0E;
reg  X0F;
reg  X10;
reg  X11;
reg  X12;
reg  X13;
reg  X14;
reg  X15;
reg  X16;
reg  X17;
reg  X18;
reg  X19;
reg  X1A;
reg  X1B;
reg  X1C;
reg  X1D;
reg  X1E;
reg  X1F;


always @( * ) begin
  case( read0_reg_addr )
    7'h00: read0_reg_data <= X00;
    7'h01: read0_reg_data <= X01;
    7'h02: read0_reg_data <= X02;
    7'h03: read0_reg_data <= X03;
    7'h04: read0_reg_data <= X04;
    7'h05: read0_reg_data <= X05;
    7'h06: read0_reg_data <= X06;
    7'h07: read0_reg_data <= X07;
    7'h08: read0_reg_data <= X08;
    7'h09: read0_reg_data <= X09;
    7'h0A: read0_reg_data <= X0A;
    7'h0B: read0_reg_data <= X0B;
    7'h0C: read0_reg_data <= X0C;
    7'h0D: read0_reg_data <= X0D;
    7'h0E: read0_reg_data <= X0E;
    7'h0F: read0_reg_data <= X0F;
    7'h10: read0_reg_data <= X10;
    7'h11: read0_reg_data <= X11;
    7'h12: read0_reg_data <= X12;
    7'h13: read0_reg_data <= X13;
    7'h14: read0_reg_data <= X14;
    7'h15: read0_reg_data <= X15;
    7'h16: read0_reg_data <= X16;
    7'h17: read0_reg_data <= X17;
    7'h18: read0_reg_data <= X18;
    7'h19: read0_reg_data <= X19;
    7'h1A: read0_reg_data <= X1A;
    7'h1B: read0_reg_data <= X1B;
    7'h1C: read0_reg_data <= X1C;
    7'h1D: read0_reg_data <= X1D;
    7'h1E: read0_reg_data <= X1E;
    7'h1F: read0_reg_data <= X1F;
  endcase
end


always @( * ) begin
  case( read1_reg_addr )
    7'h00: read1_reg_data <= X00;
    7'h01: read1_reg_data <= X01;
    7'h02: read1_reg_data <= X02;
    7'h03: read1_reg_data <= X03;
    7'h04: read1_reg_data <= X04;
    7'h05: read1_reg_data <= X05;
    7'h06: read1_reg_data <= X06;
    7'h07: read1_reg_data <= X07;
    7'h08: read1_reg_data <= X08;
    7'h09: read1_reg_data <= X09;
    7'h0A: read1_reg_data <= X0A;
    7'h0B: read1_reg_data <= X0B;
    7'h0C: read1_reg_data <= X0C;
    7'h0D: read1_reg_data <= X0D;
    7'h0E: read1_reg_data <= X0E;
    7'h0F: read1_reg_data <= X0F;
    7'h10: read1_reg_data <= X10;
    7'h11: read1_reg_data <= X11;
    7'h12: read1_reg_data <= X12;
    7'h13: read1_reg_data <= X13;
    7'h14: read1_reg_data <= X14;
    7'h15: read1_reg_data <= X15;
    7'h16: read1_reg_data <= X16;
    7'h17: read1_reg_data <= X17;
    7'h18: read1_reg_data <= X18;
    7'h19: read1_reg_data <= X19;
    7'h1A: read1_reg_data <= X1A;
    7'h1B: read1_reg_data <= X1B;
    7'h1C: read1_reg_data <= X1C;
    7'h1D: read1_reg_data <= X1D;
    7'h1E: read1_reg_data <= X1E;
    7'h1F: read1_reg_data <= X1F;
  endcase
end

assign X00 = {DATA_WIDTH{1'b0}};

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h01 ) X01 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h02 ) X02 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h03 ) X03 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h04 ) X04 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h05 ) X05 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h06 ) X06 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h07 ) X07 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h08 ) X08 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h09 ) X09 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h0A ) X0A <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h0B ) X0B <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h0C ) X0C <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h0D ) X0D <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h0E ) X0E <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h0F ) X0F <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h10 ) X10 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h11 ) X11 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h12 ) X12 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h13 ) X13 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h14 ) X14 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h15 ) X15 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h16 ) X16 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h17 ) X17 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h18 ) X18 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h19 ) X19 <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h1A ) X1A <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h1B ) X1B <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h1C ) X1C <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h1D ) X1D <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h1E ) X1E <= wback_reg_data;
end

always @(posedge clk) begin
  if( wback_reg_wen == 1'b1 && wback_reg_addr == 7'h1F ) X1F <= wback_reg_data;
end



endmodule
