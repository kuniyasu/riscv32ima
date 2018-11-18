
module riscv32ima_fetch(
clk,
nrst,

fetch_valid,
fetch_ready,
fetch_address,
fetch_data,

wback_pc_wen,
wback_pc,
wback_reg_wen,
wback_reg_addr,
wback_reg_data,

i_ncs,
i_nwe,
i_addr,
i_wdata,
i_wmask,
i_rdata,
i_stall

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

output  fetch_valid;
input   fetch_ready;
output  [ADDR_WIDTH-1:0] fetch_address;
output  [DATA_WIDTH-1:0] fetch_data;

input wback_pc_wen;
input [ADDR_WIDTH-1:0] wback_pc;
input wback_reg_wen;
input [REG_ADDR_WIDTH-1:0] wback_reg_addr;
input [REG_DATA_WIDTH-1:0] wback_reg_data;

output i_ncs;
output i_nwe;
output [ADDR_WIDTH-1:0] i_addr;
output [DATA_WIDTH-1:0] i_wdata;
output [DATA_WIDTH-1:0] i_wmask;
input  [DATA_WIDTH-1:0] i_rdata;
input  i_stall;

endmodule
