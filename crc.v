module crc(
		input [66:0]data_in,
		input [3:0]crc,
		input en,
		output [2:0]error
    );
	 
	 integer i;
	 reg [66:0]temp;
	 reg [3:0]temp2;
	 
	 always@(*)
	 begin
		if(en)
		begin
			temp = data_in;
			for(i = 66; i>2; i = i-1)
			begin
				if(temp[i])
				begin
					temp2[3] = temp[i];
					temp2[2] = temp[i-1];
					temp2[1] = temp[i-2];
					temp2[0] = temp[i-3];
					temp2 = temp2 ^ crc;
					temp[i] = temp2[3];
					temp[i-1] = temp2[2];
					temp[i-2] = temp2[1];
					temp[i-3] = temp2[0];
				end
			end
		end
	 end
	 
	 assign error = temp[2:0];

endmodule
