module transmit(input serial_in,
		input [78:0]data_in,
		input [3:0]crc,
		input clk,
		input [1:0]data_size,
		input [3:0]my_address,
		input start_transmit,
		output serial_out1,
		output transmit_finished
    );
	 reg serial_out = 1'b1;
	 assign serial_out1 = serial_out;
	 
	 reg send_or_recieve1 = 0;
	 reg send_or_recieve2 = 0;
	 wire send_or_recieve = send_or_recieve1 ^ send_or_recieve2;
	 reg en1, en2;
	 reg [78:0]temp;
	 wire [78:0]temp2;
	 assign temp2 = temp;
	 wire [66:0]temp3;		//crc error detection
	 assign temp3 = temp[67:1];
	 reg send_idle;
	 integer counter = 78;
	 wire [2:0]error;
	 wire [78:0]temp_ack, temp_nack;
	 reg foo, foo2;
	 wire [3:0]temp_my_address_from_R;
	 assign temp_my_address_from_R = temp[73:70];
	 reg [3:0]rec_ad = 0;
	 reg [66:0]crc1001;
	 reg [3:0]temp_my_address_from_Rec;
	 
	 always@(posedge clk)
	 begin
		if(!send_or_recieve)
		begin
			temp <= {temp[77:0], serial_in};
			en2 <= 0;
			en1 <= 0;
			if(!temp[78])
			begin
				rec_ad <= temp[77:74];
				crc1001 <= temp[67:1];
				temp_my_address_from_Rec <= temp[73:70];
				if(my_address == temp_my_address_from_Rec)
				begin
					en1 <= 1;	//crc check
					/*if(crc1001 == 67'b1111111111111111111111111111111111111111111111111111111111111111111)
					begin
						if(start_transmit)
						begin
							if(!send_or_recieve)
								send_or_recieve1 <= ~send_or_recieve1;
						end
					end*/
					//else
					//begin
						if(error == 0)
						begin
							en2 <= 1;	//make ack
						end
						if(!send_or_recieve)
							send_or_recieve1 <= ~send_or_recieve1;
					//end
				end
			end
			else 
			begin
				if(temp == 79'b1111111111111111111111111111111111111111111111111111111111111111111111111111111)
				begin
					if(start_transmit)
					begin
						if(!send_or_recieve)
							send_or_recieve1 <= ~send_or_recieve1;
					end
				end
			end
		end
	 end
	 
	 always@(posedge clk)
	 begin
		if(send_or_recieve)
		begin
			counter <= 78;
			if(en1)
			begin
				if(en2)
				begin
					serial_out <= temp_ack[counter];
					counter <= counter - 1;
				end
				else
				begin
					serial_out <= temp_nack[counter];
					counter <= counter - 1;
				end
			end
			else
			begin
				//if(start_transmit)
				//begin
					serial_out <= data_in[counter];
					counter <= counter - 1;
				//end
			end
			if(counter == -1)
			begin
				counter <= 78;
				temp <= 79'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
				serial_out <= 1'b1;
				//transmit_finished <= 1;
				if(send_or_recieve)
					send_or_recieve2 <= ~send_or_recieve2;
			end
		end
	 end
	 
	 crc crc_error_detect (
    .data_in(crc1001), 
    .crc(crc), 
    .en(en1), 
    .error(error)
    );//detect error
	 
	 
	 wire [3:0]RA;
	 assign RA = temp[77:74];
	 
	 wire [1:0]data_size0;
	 assign data_size0 = 0;
	 wire [63:0]data_in_ack, data_in_nack;
	 assign data_in_nack = 0;
	 assign data_in_ack = 64'b1111111111111111111111111111111111111111111111111111111111111111;
	 wire [2:0]crc_ack, crc_nack;
	 assign crc_ack = 3'b111;
	 assign crc_nack = 3'b000;
	 
	 make_packet packet_ack (
    .data_in(data_in_ack), 
    .sender_address(my_address), 
    .reciever_address(rec_ad), 
    .data_size(data_size0), 
    .crc_in(crc_ack), 
    .en(en2), 
    .packet_out(temp_ack)
    );
	 
	 wire en20;
	 assign en20 = ~en2;
	 
	 make_packet packet_nack (
    .data_in(data_in_nack), 
    .sender_address(my_address), 
    .reciever_address(rec_ad), 
    .data_size(data_size0), 
    .crc_in(crc_nack), 
    .en(en20), 
    .packet_out(temp_nack)
    );
endmodule
