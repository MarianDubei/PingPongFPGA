module seven_seg (
	input clk, clk_1ms, reset,
	input [3:0] p1_score, p2_score,
	output reg [6:0] seg1, seg2
	);
	
	always @ (*)
	begin
	if (!reset)
	begin
		seg1 = 7'b1111111;
		seg2 = 7'b1111111;
	end
	else 
	begin
		case (p2_score)
			4'h0 : seg1 = 7'b1000000;  // 0
			4'h1 : seg1 = 7'b1111001;  // 1
			4'h2 : seg1 = 7'b0100100;  // 2
			4'h3 : seg1 = 7'b0110000;  // 3
			4'h4 : seg1 = 7'b0011001;  // 4
			4'h5 : seg1 = 7'b0010010;  // 5
			4'h6 : seg1 = 7'b0000010;  // 6
			4'h7 : seg1 = 7'b1111000;  // 7
			4'h8 : seg1 = 7'b0000000;  // 8
			4'h9 : seg1 = 7'b0010000;  // 9
			default : seg1 = 7'b1111111;
		endcase
		
		case (p1_score)
			4'h0 : seg2 = 7'b1000000;  // 0
			4'h1 : seg2 = 7'b1111001;  // 1
			4'h2 : seg2 = 7'b0100100;  // 2
			4'h3 : seg2 = 7'b0110000;  // 3
			4'h4 : seg2 = 7'b0011001;  // 4
			4'h5 : seg2 = 7'b0010010;  // 5
			4'h6 : seg2 = 7'b0000010;  // 6
			4'h7 : seg2 = 7'b1111000;  // 7
			4'h8 : seg2 = 7'b0000000;  // 8
			4'h9 : seg2 = 7'b0010000;  // 9
			default : seg2 = 7'b1111111;
		endcase
	end
	end

endmodule