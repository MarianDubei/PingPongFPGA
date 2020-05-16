//This module is supposed to render all the graphics to the vga output
//Also note that it is RGB not bgr

module render(
	input clk, reset,
	input [9:0] x, y,//position of point
	input video_on,
	output [11:0]rgb,
	input clk_1ms,
	input paddle1_on, paddle2_on, ball_on, 
	input [11:0]rgb_paddle1, rgb_paddle2, rgb_ball,
	input [1:0] game_state
	);
	
	reg [23:0] rgb_reg;

	
	localparam H_ACTIVE	= 640;
	localparam V_ACTIVE	= 480;
	localparam zero		= 0;
	
	localparam X_blocksize = 50; //IF this is less than 2, vga doesnt display due to wrong criteria
	localparam Y_blocksize = 50;
	//position of teh centre block at any given instant
	reg [9:0] x_block = H_ACTIVE/2, y_block=V_ACTIVE/2;
	
	//This posedge might be delaying the x,y to 1 pixel error
	//Please note that (posedge reset) logic is not working
	//Also note that it is RGB
	always @(posedge clk)
	begin
	if (!reset)
		rgb_reg <= 0;//black screen or start screen?
	else
		begin
			if (game_state == 2'b01)
			begin
				if (paddle1_on)
					rgb_reg <= rgb_paddle1;
				else if (paddle2_on)//writing paddle 2 first will draw it over ball
					rgb_reg <= rgb_paddle2;
				else if (ball_on )
					rgb_reg <= rgb_ball;
				else if (x==100 || y==100)
					rgb_reg <= 24'b111111111111111111111111;
				else 
					rgb_reg <= 12'b000000000000;//background
			end
			else if (game_state == 2'b10)
				rgb_reg <= rgb_paddle1;
			else if (game_state == 2'b11)
				rgb_reg <= rgb_paddle2;
			else rgb_reg <= 0;
		end
	end
	assign rgb = rgb_reg;
	
endmodule