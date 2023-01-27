/*
 *     |31     |16     0|
 * [0] | address source |
 * [1] | address result |
 * [2] |   Y   |   X    | read only
 * [3] |    control     |
*/

module dma #(
	parameter WIDTH_MD = 8,
	parameter [15:0] DEFAULT_WIDTH  = 16'd320,
	parameter [15:0] DEFAULT_HEIGHT = 16'd240
) (
	// memory mapped master
	output reg [32-1:0]       mmm_address,
	output                    mmm_read,
	input                     mmm_readdatavalid,
	input      [WIDTH_MD-1:0] mmm_readdata,
	output                    mmm_write,
	input                     mmm_waitrequest,
	output     [WIDTH_MD-1:0] mmm_writedata,
	// memory mapped slave
	input          mms_read,
	input          mms_write,
	input  [3:0]   mms_address,
	input  [3:0]   mms_byteenable,
	output [31:0]  mms_readdata,
	input  [31:0]  mms_writedata,
	// streaming sink
	output                    sink_ready,
	input                     sink_valid,
	input                     sink_startofpacket,
	input                     sink_endofpacket,
	input      [WIDTH_MD-1:0] sink_data,
	// streaming source
	input                     source_ready,
	output reg                source_valid,
	output reg                source_startofpacket,
	output reg                source_endofpacket,
	output reg [WIDTH_MD-1:0] source_data,
	input                     rst,
	input                     clk
);

reg [31:0] memory[0:3];

wire startofpacket, endofpacket;

reg        rw_mode;
wire       event_s;
reg [31:0] addr_r;
reg [31:0] addr_w;

assign event_s = memory[3][0];

always @(posedge clk, posedge rst) begin
	if (rst || event_s)
		addr_r <= 32'b0;
	else begin
		if (mmm_read && !mmm_waitrequest) begin
			if (addr_r[15:0] == memory[2][15:0])
				addr_r <= addr_r + 32'h1 + 32'h200;
			else
				addr_r <= addr_r + 32'h1;
		end
	end
end

always @(posedge clk, posedge rst) begin
	if (rst || event_s)
		addr_w <= 32'b0;
	else begin
		if (sink_ready) begin
			if (addr_w[15:0] == memory[2][15:0])
				addr_w <= addr_w + 32'h1 + 32'h200;
			else
				addr_w <= addr_w + 32'h1;
		end
	end
end

assign startofpacket = addr_r == 32'b0;
assign endofpacket   = addr_r == 32'h1DF3F; // 239 << 9 + 319

always @(posedge clk, posedge rst) begin
	if (rst)
		rw_mode <= 1'b0; // read
	else begin
		if (source_ready)
			rw_mode <= 1'b0; // read
		else
			rw_mode <= 1'b1; // write
	end
end

// sink
assign sink_ready = ~mmm_waitrequest & rw_mode;

// source
always @(posedge clk, posedge rst) begin
	if (rst) begin
		source_valid         <= 1'b0;
		source_data          <= 8'b0;
		source_startofpacket <= 1'b0;
		source_endofpacket   <= 1'b0;
	end else begin
		if (mmm_readdatavalid) begin
			source_valid         <= 1'b1;
			source_data          <= mmm_readdata;
			source_startofpacket <= startofpacket;
			source_endofpacket   <= endofpacket;
		end
		if (source_ready && ~mmm_readdatavalid)
			source_valid         <= 1'b0;
	end
end

// memory mapper master
assign mmm_read      = ~rw_mode;
assign mmm_write     = sink_valid & rw_mode;
assign mmm_writedata = sink_data;

always @(*) begin
	case (rw_mode)
	1'b0: mmm_address = memory[0] + addr_r;
	1'b1: mmm_address = memory[1] + addr_w;
	endcase
end


// memory mapper slave
assign mms_readdata = memory[mms_address[1:0]];
always @(posedge clk, posedge rst) begin
	if (rst) begin
		memory[0] <= 32'b0;
		memory[1] <= 32'b0;
		memory[2] <= {DEFAULT_HEIGHT, DEFAULT_WIDTH};
		memory[3] <= 32'h0;
	end else begin
		if (mms_write)
			if (mms_byteenable[0])
				memory[mms_address][7:0]   <= mms_writedata[7:0];
			if (mms_byteenable[1])
				memory[mms_address][15:8]  <= mms_writedata[15:8];
			if (mms_byteenable[2])
				memory[mms_address][23:16] <= mms_writedata[23:16];
			if (mms_byteenable[3])
				memory[mms_address][31:24] <= mms_writedata[31:24];
		else begin

		end

		if (event_s) begin
			memory[3][0] <= 1'b0;
			memory[3][1] <= 1'b1;
		end
		if (sink_endofpacket)
			memory[3][1] <= 1'b0;
	end
end

endmodule

