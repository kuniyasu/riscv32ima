
import "DPI-C" function void loadFile (string str);                                                                       
import "DPI-C" function void readdata (input int address, input int length, output byte data[256]);                       
import "DPI-C" function void writedata(input int address, input int length, input  byte data[256], input byte mask[256]); 
                                                                                                                          
module memory(clk, ncs, nwe, addr, wdata, wmask, rdata);
   parameter ADDR_WIDTH = 32;
   parameter DATA_WIDTH = 64;

   
   input clk, ncs, nwe;
   input [ADDR_WIDTH-1:0] addr;
   input [DATA_WIDTH-1:0] wdata, wmask;
   output reg [DATA_WIDTH-1:0] rdata;
   
   byte 		      data[256];
   byte 		      mask[256];
   
   always @(posedge clk) begin      
      if( ncs == 1'b0 && nwe == 1'b0 ) begin
	 
	 for(int i=0; i<8; i++) begin
	    data[i] = wdata[i*8-1 : i*8-8];
	    mask[i] = wmask[i*8-1 : i*8-8];	 
	 end

	 writedata(addr, 8, data, mask);
	 
      end else if( ncs == 1'b0 && nwe == 1'b1 ) begin
	 readdata(addr, 8, data);	 

	 for(int i=0; i<8; i++) begin
	    rdata[i*8-1 : i*8-8] <= data[i];	    
	 end
	 
      end else begin
	 rdata <= {DATA_WIDTH{1'bx}};	 
      end
   end
   
endmodule
