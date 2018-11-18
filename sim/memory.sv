
module memory(clk, ncs, nwe, addr, wdata, wmask, rdata);
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 64;


  input clk, ncs, nwe;
  input  [ADDR_WIDTH-1:0] addr;
  input  [DATA_WIDTH-1:0] wdata, wmask;
  output [DATA_WIDTH-1:0] rdata;

endmodule
