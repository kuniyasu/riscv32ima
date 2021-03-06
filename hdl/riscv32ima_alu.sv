
module riscv32ima_alu(
		clk,
		nrst,

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

		alu_valid,
		alu_ready,
		alu_opcode,
		alu_func3_opcode,
		alu_src_addr,
		alu_dst_addr,
		alu_mem_addr,
		alu_data,

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

parameter BEQ = 3'b000;
parameter BNE = 3'b001;
parameter BLT = 3'b010;
parameter BGE = 3'b011;
parameter BLTU = 3'b100;
parameter BGEU = 3'b101;


input clk;
input nrst;

input  dec_valid;
output dec_ready;
input [OPCODE_WIDTH-1:0]   dec_opcode;
input [FUNC3_WIDTH-1:0]    dec_func3_opcode;
input [FUNC7_WIDTH-1:0]    dec_func7_opcode;
input [REG_ADDR_WIDTH-1:0] dec_src0_addr;
input [REG_ADDR_WIDTH-1:0] dec_src1_addr;
input [REG_ADDR_WIDTH-1:0] dec_dst_addr;
input [ADDR_WIDTH-1:0]     dec_mem_addr;
input [DATA_WIDTH-1:0]     dec_src0_data;
input [DATA_WIDTH-1:0]     dec_src1_data;
input [DATA_WIDTH-1:0]     dec_imm_data;


output reg alu_valid;
input  alu_ready;
output reg [OPCODE_WIDTH-1:0]     alu_opcode;
output reg [FUNC3_WIDTH-1:0]      alu_func3_opcode;
output reg [REG_ADDR_WIDTH-1:0]   alu_dst_addr;
output reg [REG_ADDR_WIDTH-1:0]   alu_src_addr;
output reg [ADDR_WIDTH-1:0]       alu_mem_addr;
output reg [REG_DATA_WIDTH-1:0]   alu_data;


output wback_pc_wen;
output reg [ADDR_WIDTH-1:0] wback_pc;

input wback_reg_wen;
input [REG_ADDR_WIDTH-1:0] wback_reg_addr;
input [REG_DATA_WIDTH-1:0] wback_reg_data;

reg 	pc_wen;

assign wback_pc_wen = pc_wen & alu_ready;
assign dec_ready = alu_ready;

always @(posedge clk) begin
  if( !nrst ) begin
     alu_valid <= 1'b0;
     pc_wen    <= 1'b0;

  end else if ( pc_wen ) begin
     alu_valid <= 1'b0;
     pc_wen    <= 1'b0;

  end else if( dec_ready  ) begin
    alu_valid <= dec_valid;
    alu_opcode <= dec_opcode;
    alu_func3_opcode <= dec_func3_opcode;
    alu_dst_addr     <= dec_dst_addr;

    case( dec_opcode )
		 /*
		  LOAD: begin
	          alu_src_addr;
	          alu_mem_addr;
	          alu_data;
	          end

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
		  */

		 BRANCH: begin
		 		wback_pc[ADDR_WIDTH-1:0] <= $signed({1'b0,dec_mem_addr}) + $signed(dec_imm_data);

		    case( alu_func3_opcode )
		      BEQ: if( $signed(dec_src0_data) == $signed(dec_src1_data) ) begin
						 pc_wen <= dec_valid;
		      end

		      BNE: if ( $signed(dec_src0_data) != $signed(dec_src1_data) ) begin
						 pc_wen <= dec_valid;
		      end

		      BLT: if( $signed(dec_src0_data) < $signed(dec_src1_data) )begin
						 pc_wen <= dec_valid;
		      end

		      BGE: if( $signed(dec_src0_data) >= $signed(dec_src1_data) ) begin
						 pc_wen <= dec_valid;
		      end

		      BLTU: if ( dec_src0_data < dec_src1_data ) begin
						 pc_wen <= dec_valid;
		      end

		      BGEU: if ( dec_src0_data >= dec_src1_data ) begin
						 pc_wen <= dec_valid;
		      end

		      default : begin
						pc_wen <= 1'b0;
		      end
		    endcase
		 end

		 JALR: begin
		    pc_wen <= dec_valid;
		    wback_pc[ADDR_WIDTH-1:0] <= $signed({1'b0,dec_mem_addr}) + $signed(dec_imm_data);
		 end

		 //reserved_1:;
		 JAL: begin
		    pc_wen <= dec_valid;
		    wback_pc[ADDR_WIDTH-1:0] <= $signed({1'b0,dec_mem_addr}) + $signed(dec_imm_data);
		 end

		 /*
		  SYSTEM:;
		  reserved_2:;
		  custom_3:;
		  */

		 default: begin
		    pc_wen <= 1'b0;
		 end
   endcase // case ( dec_opcode )
  end
end

endmodule
