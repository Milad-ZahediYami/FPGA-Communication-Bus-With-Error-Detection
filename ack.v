module make_packet(input [63:0]data_in,
		input [3:0]sender_address,
		input [3:0]reciever_address,
		input [1:0]data_size,
		input [2:0]crc_in,
		input en,
		output reg[78:0]packet_out
    );
	 
	 always@(*)
	 begin
		if(en)
		begin
			packet_out[78] <= 0;
			packet_out[77:74] <= sender_address;
			packet_out[73:70] <= reciever_address;
			packet_out[69:68] <= data_size;
			packet_out[67:4] <= data_in;
			packet_out[3:1] <= crc_in;
			packet_out[0] <= 1;
		end
	 end



endmodule
