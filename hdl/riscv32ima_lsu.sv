
module riscv32ima_lsu(
  clk,
  nrst,

  alu_valid,
  alu_ready,
  alu_opcode,
  alu_func3_opcode,
  alu_src_addr,
  alu_dst_addr,
  alu_mem_addr,
  alu_data,

  lsu_valid,
  lsu_ready,
  lsu_opcode,
  lsu_reg_addr,
  lsu_mem_addr,
  lsu_data,

  wback_reg_wen,
  wback_reg_addr,
  wback_reg_data,

  d_ncs,
  d_nwe,
  d_addr,
  d_wdata,
  d_wmask,
  d_rdata,
  d_stall

  );

parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 64;
parameter REG_ADDR_WIDTH = 5;
parameter REG_DATA_WIDTH = 32;
parameter OPCODE_WIDTH = 7;
parameter FUNC3_WIDTH = 3;
parameter FUNC7_WIDTH = 7;

parameter LOAD        = 7'b000_00_11;
parameter LOAD_FP     = 7'b001_00_11;
parameter custom_0    = 7'b010_00_11;
parameter MISC_MEM    = 7'b011_00_11;
parameter OP_IMM      = 7'b100_00_11;
parameter AUIPC       = 7'b101_00_11;
parameter OP_IMM_32   = 7'b110_00_11;

parameter STORE       = 7'b000_01_11;
parameter STORE_FP    = 7'b001_01_11;
parameter custom_1    = 7'b010_01_11;
parameter AMO         = 7'b011_01_11;
parameter OP          = 7'b100_01_11;
parameter LUI         = 7'b101_01_11;
parameter OP_32       = 7'b110_01_11;

parameter MADD        = 7'b000_10_11;
parameter MSUB        = 7'b001_10_11;
parameter NMSUB       = 7'b010_10_11;
parameter NMADD       = 7'b011_10_11;
parameter OP_FP       = 7'b100_10_11;
parameter reserved_0  = 7'b101_10_11;
parameter custom_2    = 7'b110_10_11;

parameter BRANCH      = 7'b000_11_11;
parameter JALR        = 7'b001_11_11;
parameter reserved_1  = 7'b010_11_11;
parameter JAL         = 7'b011_11_11;
parameter SYSTEM      = 7'b100_11_11;
parameter reserved_2  = 7'b101_11_11;
parameter custom_3    = 7'b110_11_11;

input clk;
input nrst;

input  alu_valid;
output alu_ready;
input  [OPCODE_WIDTH-1:0]     alu_opcode;
input  [FUNC3_WIDTH-1:0]      alu_func3_opcode;
input  [REG_ADDR_WIDTH-1:0]   alu_dst_addr;
input  [REG_ADDR_WIDTH-1:0]   alu_src_addr;
input  [ADDR_WIDTH-1:0]       alu_mem_addr;
input  [REG_DATA_WIDTH-1:0]   alu_data;

output  reg lsu_valid;
input   lsu_ready;
output  reg [OPCODE_WIDTH-1:0]      lsu_opcode;
output  reg [REG_ADDR_WIDTH-1:0]    lsu_reg_addr;
output  reg [ADDR_WIDTH-1:0]        lsu_mem_addr;
output  [REG_DATA_WIDTH-1:0]        lsu_data;

//input wback_pc_wen;
//input [ADDR_WIDTH-1:0] wback_pc;

input wback_reg_wen;
input [REG_ADDR_WIDTH-1:0] wback_reg_addr;
input [REG_DATA_WIDTH-1:0] wback_reg_data;

output d_ncs;
output d_nwe;
output [ADDR_WIDTH-1:0] d_addr;
output [DATA_WIDTH-1:0] d_wdata;
output [DATA_WIDTH-1:0] d_wmask;
input  [DATA_WIDTH-1:0] d_rdata;
input  d_stall;

reg  [FUNC3_WIDTH-1:0]    func3_opcode;
wire [REG_DATA_WIDTH-1:0] wdata;
wire [REG_DATA_WIDTH-1:0] rdata;

assign wdata = ((alu_dst_addr == wback_reg_addr)&(wback_reg_wen==1'b1)&(alu_valid==1'b1)&(alu_ready==1'b1))? wback_reg_data : alu_data;

wire ready;
reg  [REG_DATA_WIDTH-1:0]   bypass_data;

always @(posedge clk) begin
  if( !nrst )begin
    lsu_valid <= 1'b0;
  end else if( ready ) begin
    lsu_valid <= alu_valid;
    lsu_opcode <= alu_opcode;
    func3_opcode <= alu_func3_opcode;

    lsu_reg_addr <= alu_dst_addr;
    lsu_mem_addr <= alu_mem_addr;
    bypass_data  <= alu_data;
  end
end

assign rdata = ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b000))? {{24{d_rdata[ 7]}}, d_rdata[ 7: 0]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b001))? {{24{d_rdata[15]}}, d_rdata[15: 8]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b010))? {{24{d_rdata[23]}}, d_rdata[23:16]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b011))? {{24{d_rdata[31]}}, d_rdata[31:24]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b100))? {{24{d_rdata[31]}}, d_rdata[39:32]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b101))? {{24{d_rdata[47]}}, d_rdata[47:40]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b110))? {{24{d_rdata[55]}}, d_rdata[55:48]}:
               ((func3_opcode == 3'b000)&(lsu_mem_addr[2:0] == 3'b111))? {{24{d_rdata[63]}}, d_rdata[63:56]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b000))? {{24{1'b0}},        d_rdata[ 7: 0]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b001))? {{24{1'b0}},        d_rdata[15: 8]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b010))? {{24{1'b0}},        d_rdata[23:16]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b011))? {{24{1'b0}},        d_rdata[31:24]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b100))? {{24{1'b0}},        d_rdata[39:32]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b101))? {{24{1'b0}},        d_rdata[47:40]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b110))? {{24{1'b0}},        d_rdata[55:48]}:
               ((func3_opcode == 3'b100)&(lsu_mem_addr[2:0] == 3'b111))? {{24{1'b0}},        d_rdata[63:56]}:
               ((func3_opcode == 3'b001)&(lsu_mem_addr[2:1] == 2'b00 ))? {{16{d_rdata[15]}}, d_rdata[15: 0]}:
               ((func3_opcode == 3'b001)&(lsu_mem_addr[2:1] == 2'b01 ))? {{16{d_rdata[31]}}, d_rdata[31:16]}:
               ((func3_opcode == 3'b001)&(lsu_mem_addr[2:1] == 2'b10 ))? {{16{d_rdata[47]}}, d_rdata[47:32]}:
               ((func3_opcode == 3'b001)&(lsu_mem_addr[2:1] == 2'b11 ))? {{16{d_rdata[63]}}, d_rdata[63:48]}:
               ((func3_opcode == 3'b101)&(lsu_mem_addr[2:1] == 2'b00 ))? {{16{1'b0}},        d_rdata[15: 0]}:
               ((func3_opcode == 3'b101)&(lsu_mem_addr[2:1] == 2'b01 ))? {{16{1'b0}},        d_rdata[31:16]}:
               ((func3_opcode == 3'b101)&(lsu_mem_addr[2:1] == 2'b10 ))? {{16{1'b0}},        d_rdata[47:32]}:
               ((func3_opcode == 3'b101)&(lsu_mem_addr[2:1] == 2'b11 ))? {{16{1'b0}},        d_rdata[63:48]}:
               ((func3_opcode == 3'b001)&(lsu_mem_addr[2]   == 2'b0  ))? {                   d_rdata[31: 0]}:
               ((func3_opcode == 3'b001)&(lsu_mem_addr[2]   == 2'b1  ))? {                   d_rdata[63:32]}:
               32'h0;

assign lsu_data  = (lsu_opcode == LOAD)? rdata : bypass_data;
assign ready     = lsu_ready & d_stall;
assign alu_ready = ready;


assign d_ncs   = ((alu_opcode == STORE)&(alu_valid == 1'b1))? 1'b0:1'b1;
assign d_nwe   = (alu_opcode == STORE)? 1'b0:1'b1;
assign d_addr  = {lsu_mem_addr[ADDR_WIDTH-1:3],3'b000};

assign d_wmask = ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b000))? {8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b001))? {8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hff}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b010))? {8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hff,8'hff}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b011))? {8'hff,8'hff,8'hff,8'hff,8'h00,8'hff,8'hff,8'hff}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b100))? {8'hff,8'hff,8'hff,8'h00,8'hff,8'hff,8'hff,8'hff}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b101))? {8'hff,8'hff,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b110))? {8'hff,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff}:
                 ((alu_func3_opcode == 3'b000)&(alu_mem_addr[2:0] == 3'b111))? {8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff}:
                 ((alu_func3_opcode == 3'b001)&(alu_mem_addr[2:1] == 2'b00))?  {16'hffff,16'hffff,16'hffff,16'h0000}:
                 ((alu_func3_opcode == 3'b001)&(alu_mem_addr[2:1] == 2'b01))?  {16'hffff,16'hffff,16'h0000,16'hffff}:
                 ((alu_func3_opcode == 3'b001)&(alu_mem_addr[2:1] == 2'b10))?  {16'hffff,16'h0000,16'hffff,16'hffff}:
                 ((alu_func3_opcode == 3'b001)&(alu_mem_addr[2:1] == 2'b11))?  {16'h0000,16'hffff,16'hffff,16'hffff}:
                 ((alu_func3_opcode == 3'b010)&(alu_mem_addr[2]   == 1'b0))?   {32'hffffffff,32'h00000000}:
                 ((alu_func3_opcode == 3'b010)&(alu_mem_addr[2]   == 1'b1))?   {32'h00000000,32'hffffffff}:
                 64'hffffffff_ffffffff;

assign d_wdata = (alu_func3_opcode == 3'b000)? {wdata[ 7:0],wdata[ 7:0],wdata[ 7:0],wdata[ 7:0],wdata[ 7:0],wdata[ 7:0],wdata[ 7:0],wdata[ 7:0]}:
                 (alu_func3_opcode == 3'b001)? {wdata[15:0],wdata[15:0],wdata[15:0],wdata[15:0]}:
                 {wdata[31:0],wdata[31:0]};

endmodule
