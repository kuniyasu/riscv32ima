
module riscv32ima_wback(
  clk,
  nrst,

  lsu_valid,
  lsu_ready,
  lsu_opcode,
  lsu_reg_addr,
  lsu_mem_addr,
  lsu_data,

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

  input  lsu_valid;
  output lsu_ready;
  input  [OPCODE_WIDTH-1:0]     lsu_opcode;
  input  [REG_ADDR_WIDTH-1:0]   lsu_reg_addr;
  input  [ADDR_WIDTH-1:0]       lsu_mem_addr;
  input  [REG_DATA_WIDTH-1:0]   lsu_data;


  output reg wback_pc_wen;
  output reg [ADDR_WIDTH-1:0] wback_pc;
  output reg wback_reg_wen;
  output reg [REG_ADDR_WIDTH-1:0] wback_reg_addr;
  output reg [REG_DATA_WIDTH-1:0] wback_reg_data;

  always @(posedge clk) begin
    if( !nrst ) begin
      wback_pc_wen <= 1'b0;
      wback_reg_wen <= 1'b0;
    end else begin
      case( lsu_opcode )
        LOAD: begin
          wback_pc_wen  <= 1'b0;

          wback_reg_wen <= 1'b1;
          wback_reg_addr <= lsu_data;
        end

        /*
        LOAD_FP:;
        custom_0:;
        MISC_MEM:;
        OP_IMM:;
        AUIPC:;
        OP_IMM_32:;
        STORE:;
        STORE_FP:;
        custom_1:;
        AMO:;
        OP:;
        LUI:;
        OP_32:;
        MADD:;
        MSUB:;
        NMSUB:;
        NMADD:;
        OP_FP:;
        reserved_0:;
        custom_2:;
        BRANCH:;
        JALR:;
        reserved_1:;
        JAL:;
        SYSTEM:;
        reserved_2:;
        custom_3:;
        */

        default: begin
          wback_pc_wen  <= 1'b0;
          wback_reg_wen <= 1'b0;
        end
      endcase
    end
  end

  assign lsu_ready = 1'b1;

endmodule
