`timescale 1ps/1ps

module top;
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 64;

  reg clk;
  reg nrst;

  wire i_ncs;
  wire i_nwe;
  wire [ADDR_WIDTH-1:0] i_addr;
  wire [DATA_WIDTH-1:0] i_wdata;
  wire [DATA_WIDTH-1:0] i_wmask;
  wire [DATA_WIDTH-1:0] i_rdata;
  wire i_stall;

  wire d_ncs;
  wire d_nwe;
  wire [ADDR_WIDTH-1:0] d_addr;
  wire [DATA_WIDTH-1:0] d_wdata;
  wire [DATA_WIDTH-1:0] d_wmask;
  wire [DATA_WIDTH-1:0] d_rdata;
  wire d_stall;



  riscv32ima_core riscv32ima(
    .clk(clk),
    .nrst(nrst),

    .i_ncs(i_ncs),
    .i_nwe(i_nwe),
    .i_addr(i_addr),
    .i_wdata(i_wdata),
    .i_wmask(i_wmask),
    .i_rdata(i_rdata),
    .i_stall(i_stall),

    .d_ncs(d_ncs),
    .d_nwe(d_nwe),
    .d_addr(d_addr),
    .d_wdata(d_wdata),
    .d_wmask(d_wmask),
    .d_rdata(d_rdata),
    .d_stall(d_stall)
  );

  assign i_stall = 1'b1;
  assign d_stall = 1'b1;

  memory imem(
    .clk(clk),

    .i_ncs(i_ncs),
    .i_nwe(i_nwe),
    .i_wdata(i_wdata),
    .i_addr(i_addr),
    .i_wmask(i_wmask),
    .i_rdata(i_rdata),

    .d_ncs(d_ncs),
    .d_nwe(d_nwe),
    .d_addr(d_addr),
    .d_wdata(d_wdata),
    .d_wmask(d_wmask),
    .d_rdata(d_rdata)
    );


  always begin
    #500 clk = 1'b0;
    #500 clk = 1'b1;
  end

  initial begin
     nrst <= 1'b0;
     $display("Hello Verilog World.");

     @(posedge clk);
     nrst <= 1'b1;


     repeat(10) @(posedge clk);
     $finish;
  end

endmodule
