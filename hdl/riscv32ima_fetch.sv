
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

  reg [ADDR_WIDTH-1:0] PC;

  wire stall;
  reg                     i_mem_read;
  reg [ADDR_WIDTH-1:0]    i_mem_addr;
  wire [DATA_WIDTH-1:0]   i_mem_rdata;
  reg [DATA_WIDTH-1:0]    i_mem_rdata_buf;

  assign nstall = fetch_ready & i_stall;

  always @(posedge clk) begin
    if( !nrst ) begin
      PC <= 32'h1000_0000;
    end else if( wback_pc_wen == 1'b1 ) begin
      PC <= wback_pc;
    end else if( nstall == 1'b1 ) begin
      PC <= {PC[ADDR_WIDTH-1:3],3'b000} + 4'h8;
    end
  end

  assign i_ncs = 1'b1;
  assign i_nwe = 1'b1;
  assign i_addr = PC;
  assign i_wdata = {DATA_WIDTH{1'b0}};
  assign i_wmask = {DATA_WIDTH{1'b0}};



  always @(posedge clk) begin
    if( !nrst ) begin
      i_mem_read <= 1'b0;
    end else if( wback_pc_wen == 1'b1 ) begin
      i_mem_read <= 1'b0;
    end else begin
      i_mem_read <= (nstall == 1'b1);
      i_mem_addr <= PC;
    end
  end


  always @(posedge clk) begin
    if( !nstall & i_mem_read ) begin
      i_mem_rdata_buf <= i_rdata;
    end
  end

  assign fetch_valid   = i_mem_read;
  assign fetch_address = i_mem_addr;
  assign fetch_data    = ( nstall & !i_mem_read )? i_mem_rdata_buf : i_rdata;

endmodule
