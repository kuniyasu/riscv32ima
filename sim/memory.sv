
//import "DPI-C" function void loadFile (string str);
//import "DPI-C" function void readdata (input int address, input int length, output byte data[256]);
//import "DPI-C" function void writedata(input int address, input int length, input  byte data[256], input byte mask[256]);

module memory(clk,
    i_ncs, i_nwe, i_addr, i_wdata, i_wmask, i_rdata,
    d_ncs, d_nwe, d_addr, d_wdata, d_wmask, d_rdata
    );
   parameter ADDR_WIDTH = 32;
   parameter DATA_WIDTH = 64;


   input clk;

   input i_ncs, i_nwe;
   input [ADDR_WIDTH-1:0] i_addr;
   input [DATA_WIDTH-1:0] i_wdata, i_wmask;
   output reg [DATA_WIDTH-1:0] i_rdata;

   input d_ncs, d_nwe;
   input [ADDR_WIDTH-1:0] d_addr;
   input [DATA_WIDTH-1:0] d_wdata, d_wmask;
   output reg [DATA_WIDTH-1:0] d_rdata;


   byte 		      data[256];
   byte 		      mask[256];

   always @(posedge clk) begin
      if( i_ncs == 1'b0 && i_nwe == 1'b0 ) begin


         //i_rdata[i*8-1 : i*8-8] <= data[i];
  //    	 writedata(addr, 8, data, mask);

      end else if( i_ncs == 1'b0 && i_nwe == 1'b1 ) begin
  //    	 readdata(addr, 8, data);


      end else begin
	        i_rdata <= {DATA_WIDTH{1'bx}};
      end
   end

endmodule
