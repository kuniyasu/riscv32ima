
module riscv32ima_dec(
clk,
nrst,

fetch_valid,
fetch_ready,
fetch_address,
fetch_data,

dec_valid,
dec_ready,
dec_opcode,
dec_func3_opcode,
dec_func7_opcode,
dec_src0_addr,
dec_src1_addr,
dec_dst_addr,
dec_mem_addr,
dec_src0_data,
dec_src1_data,
dec_imm_data,

wback_pc_wen,
wback_pc,
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

input  fetch_valid;
output fetch_ready;
input  [ADDR_WIDTH-1:0] fetch_address;
input  [DATA_WIDTH-1:0] fetch_data;


output  dec_valid;
input   dec_ready;
output [OPCODE_WIDTH-1:0]   dec_opcode;
output [FUNC3_WIDTH-1:0]    dec_func3_opcode;
output [FUNC7_WIDTH-1:0]    dec_func7_opcode;
output [REG_ADDR_WIDTH-1:0] dec_src0_addr;
output [REG_ADDR_WIDTH-1:0] dec_src1_addr;
output [REG_ADDR_WIDTH-1:0] dec_dst_addr;
output [ADDR_WIDTH-1:0]     dec_mem_addr;
output [DATA_WIDTH-1:0]     dec_src0_data;
output [DATA_WIDTH-1:0]     dec_src1_data;
output [DATA_WIDTH-1:0]     dec_imm_data;


input wback_pc_wen;
input [ADDR_WIDTH-1:0] wback_pc;
input wback_reg_wen;
input [REG_ADDR_WIDTH-1:0] wback_reg_addr;
input [REG_DATA_WIDTH-1:0] wback_reg_data;


function [REG_DATA_WIDTH-1:0] deode_imm_data(input [REG_DATA_WIDTH:0] dt);
  case( dt[OPCODE_WIDTH-1:0] )
    LOAD:       deode_imm_data = { {20{dt[31]}}, dt[31:20]};
    OP_IMM:     deode_imm_data = { {20{dt[31]}}, dt[31:20]};
    AUIPC:      deode_imm_data = { dt[31:12]   , 12'h000};
    OP_IMM_32:  deode_imm_data = { {20{dt[31]}}, dt[31:25], dt[11:8], dt[7] };
    STORE:      deode_imm_data = { {20{dt[31]}}, dt[31:25], dt[11:8], dt[7] };
    LUI:        deode_imm_data = { dt[31:12]   , 12'h000};
    BRANCH:     deode_imm_data = { {20{dt[31]}}, dt[7], dt[30:25], dt[11:8], 1'b0};
    JALR:       deode_imm_data = { {20{dt[31]}}, dt[31:20]};
    JAL:        deode_imm_data = { {12{dt[31]}}, dt[19:12], dt[20], dt[30:25], dt[24:21],  1'b0};
    default:    deode_imm_data = {REG_DATA_WIDTH{1'b0}};
  endcase
endfunction

reg 			   ready;
reg 			   status;
   

   
reg  [REG_ADDR_WIDTH-1:0] read0_reg_addr;
wire [REG_DATA_WIDTH-1:0] read0_reg_data;

reg  [REG_ADDR_WIDTH-1:0] read1_reg_addr;
wire [REG_DATA_WIDTH-1:0] read1_reg_data;




assign dec_src0_addr = read0_reg_addr;
assign dec_src0_data = read0_reg_data;

assign dec_src1_addr = read1_reg_addr;
assign dec_src1_data = read1_reg_data;

riscv32ima_gprf gprf(
    .clk(clk),
    .nrst(nrst),

    .read0_reg_addr(read0_reg_addr),
    .read0_reg_data(read0_reg_data),

    .read1_reg_addr(read1_reg_addr),
    .read1_reg_data(read1_reg_data),

    .wback_reg_wen(wback_reg_wen),
    .wback_reg_addr(wback_reg_addr),
    .wback_reg_data(wback_reg_data)
);

endmodule
