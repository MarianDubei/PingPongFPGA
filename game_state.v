module game_state(
	input clk, clk_1ms, reset,
	input [3:0] p1_score, p2_score,
	output reg [1:0] game_state
	);
	
	reg [3:0] win = 4'b0101; //No. of goals to win

	always @ (posedge clk)
	begin
		if (!reset)
			game_state = 0;
		else 
		begin
			if ( p1_score == win)
				game_state = 2'b10;//p1 won
			else if ( p2_score == win)
				game_state = 2'b11;//p2 won
			else 
				game_state = 2'b01;//playing
		end
	end

endmodule
