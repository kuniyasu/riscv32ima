
module riscv32ima_core (
  clk,
  nrst,

  i_ncs,
  i_nwe,
  i_addr,
  i_wdata,
  i_wmask,
  i_rdata,
  i_stall,

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

  output i_ncs;
  output i_nwe;
  output [ADDR_WIDTH-1:0] i_addr;
  output [DATA_WIDTH-1:0] i_wdata;
  output [DATA_WIDTH-1:0] i_wmask;
  input  [DATA_WIDTH-1:0] i_rdata;
  input  i_stall;

  output d_ncs;
  output d_nwe;
  output [ADDR_WIDTH-1:0] d_addr;
  output [DATA_WIDTH-1:0] d_wdata;
  output [DATA_WIDTH-1:0] d_wmask;
  input  [DATA_WIDTH-1:0] d_rdata;
  input  d_stall;

  wire  fetch_valid;
  wire  fetch_ready;
  wire  [ADDR_WIDTH-1:0] fetch_address;
  wire  [DATA_WIDTH-1:0] fetch_data;

  wire  dec_valid;
  wire  dec_ready;
  wire [OPCODE_WIDTH-1:0]   dec_opcode;
  wire [FUNC3_WIDTH-1:0]    dec_func3_opcode;
  wire [FUNC7_WIDTH-1:0]    dec_func7_opcode;
  wire [REG_ADDR_WIDTH-1:0] dec_src0_addr;
  wire [REG_ADDR_WIDTH-1:0] dec_src1_addr;
  wire [REG_ADDR_WIDTH-1:0] dec_dst_addr;
  wire [ADDR_WIDTH-1:0]     dec_mem_addr;
  wire [DATA_WIDTH-1:0]     dec_src0_data, dec_src1_data;
  wire [DATA_WIDTH-1:0]     dec_imm_data;

  wire  alu_valid;
  wire  alu_ready;
  wire  [OPCODE_WIDTH-1:0]     alu_opcode;
  wire  [FUNC3_WIDTH-1:0]      alu_func3_opcode;
  wire  [REG_ADDR_WIDTH-1:0]   alu_src_addr;
  wire  [REG_ADDR_WIDTH-1:0]   alu_dst_addr;
  wire  [ADDR_WIDTH-1:0]       alu_mem_addr;
  wire  [REG_DATA_WIDTH-1:0]   alu_data;

  wire  lsu_valid;
  wire  lsu_ready;
  wire  [OPCODE_WIDTH-1:0]     lsu_opcode;
  wire  [REG_ADDR_WIDTH-1:0]   lsu_reg_addr;
  wire  [ADDR_WIDTH-1:0]       lsu_mem_addr;
  wire  [REG_DATA_WIDTH-1:0]   lsu_data;

  wire wback_pc_wen;
  wire [ADDR_WIDTH-1:0] wback_pc;
  wire wback_reg_wen;
  wire [REG_ADDR_WIDTH-1:0] wback_reg_addr;
  wire [REG_DATA_WIDTH-1:0] wback_reg_data;

  riscv32ima_fetch fetch(
    .clk(clk),
    .nrst(nrst),

    .fetch_valid(fetch_valid),
    .fetch_ready(fetch_ready),
    .fetch_address(fetch_address),
    .fetch_data(fetch_data),

    .wback_pc_wen(wback_pc_wen),
    .wback_pc(wback_pc),
    .wback_reg_wen(wback_reg_wen),
    .wback_reg_addr(wback_reg_addr),
    .wback_reg_data(wback_reg_data),

    .i_ncs(i_ncs),
    .i_nwe(i_nwe),
    .i_addr(i_addr),
    .i_wdata(i_wdata),
    .i_wmask(i_wmask),
    .i_rdata(i_rdata),
    .i_stall(i_stall)
  );


  riscv32ima_dec dec(
    .clk(clk),
    .nrst(nrst),

    .fetch_valid(fetch_valid),
    .fetch_ready(fetch_ready),
    .fetch_address(fetch_address),
    .fetch_data(fetch_data),

    .dec_valid(dec_valid),
    .dec_ready(dec_ready),
    .dec_opcode(dec_opcode),
    .dec_func3_opcode(dec_func3_opcode),
    .dec_func7_opcode(dec_func7_opcode),
    .dec_src0_addr(dec_src0_addr),
    .dec_src1_addr(dec_src1_addr),
    .dec_dst_addr(dec_dst_addr),
    .dec_mem_addr(dec_mem_addr),
    .dec_src0_data(dec_src0_data),
    .dec_src1_data(dec_src1_data),
    .dec_imm_data(dec_imm_data),

    .wback_pc_wen(wback_pc_wen),
    .wback_pc(wback_pc),
    .wback_reg_wen(wback_reg_wen),
    .wback_reg_addr(wback_reg_addr),
    .wback_reg_data(wback_reg_data)
  );


  riscv32ima_alu alu(
    .clk(clk),
    .nrst(nrst),

    .dec_valid(dec_valid),
    .dec_ready(dec_ready),
    .dec_opcode(dec_opcode),
    .dec_func3_opcode(dec_func3_opcode),
    .dec_func7_opcode(dec_func7_opcode),
    .dec_src0_addr(dec_src0_addr),
    .dec_src1_addr(dec_src1_addr),
    .dec_dst_addr(dec_dst_addr),
    .dec_mem_addr(dec_mem_addr),
    .dec_src0_data(dec_src0_data),
    .dec_src1_data(dec_src1_data),
    .dec_imm_data(dec_imm_data),

    .alu_valid(alu_valid),
    .alu_ready(alu_ready),
    .alu_opcode(alu_opcode),
    .alu_func3_opcode(alu_func3_opcode),
    .alu_src_addr(alu_src_addr),
    .alu_dst_addr(alu_dst_addr),
    .alu_mem_addr(alu_mem_addr),
    .alu_data(alu_data),

    .wback_pc_wen(wback_pc_wen),
    .wback_pc(wback_pc),
    .wback_reg_wen(wback_reg_wen),
    .wback_reg_addr(wback_reg_addr),
    .wback_reg_data(wback_reg_data)
  );

  riscv32ima_lsu lsu(
    .clk(clk),
    .nrst(nrst),

    .alu_valid(alu_valid),
    .alu_ready(alu_ready),
    .alu_opcode(alu_opcode),
    .alu_func3_opcode(alu_func3_opcode),
    .alu_src_addr(alu_src_addr),
    .alu_dst_addr(alu_dst_addr),
    .alu_mem_addr(alu_mem_addr),
    .alu_data(alu_data),

    .lsu_valid(lsu_valid),
    .lsu_ready(lsu_ready),
    .lsu_opcode(lsu_opcode),
    .lsu_reg_addr(lsu_reg_addr),
    .lsu_mem_addr(lsu_mem_addr),
    .lsu_data(lsu_data),

    .wback_pc_wen(wback_pc_wen),
    .wback_pc(wback_pc),
    .wback_reg_wen(wback_reg_wen),
    .wback_reg_addr(wback_reg_addr),
    .wback_reg_data(wback_reg_data),

    .d_ncs(d_ncs),
    .d_nwe(d_nwe),
    .d_addr(d_addr),
    .d_wdata(d_wdata),
    .d_wmask(d_wmask),
    .d_rdata(d_rdata),
    .d_stall(d_stall)

    );

  riscv32ima_wback wback(
    .clk(clk),
    .nrst(nrst),

    .lsu_valid(lsu_valid),
    .lsu_ready(lsu_ready),
    .lsu_opcode(lsu_opcode),
    .lsu_reg_addr(lsu_reg_addr),
    .lsu_mem_addr(lsu_mem_addr),
    .lsu_data(lsu_data),

    .wback_pc_wen(wback_pc_wen),
    .wback_pc(wback_pc),
    .wback_reg_wen(wback_reg_wen),
    .wback_reg_addr(wback_reg_addr),
    .wback_reg_data(wback_reg_data)
    );

endmodule
