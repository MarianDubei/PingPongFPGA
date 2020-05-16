module paddle(
	input clk_1ms,reset, 
	input button, button1, button2, button3,
	input [9:0] x, y,
	output paddle1_on,paddle2_on,
	output [11:0] rgb_paddle1, rgb_paddle2,
	output reg [9:0] x_paddle1 = L_position + (paddlewidth/2),
	output reg [9:0] y_paddle1 = V_active/2,
	output reg [9:0] x_paddle2 = H_active-(R_position + (paddlewidth/2)),
	output reg [9:0] y_paddle2 = V_active/2
	);

	localparam H_active = 640;
	localparam V_active = 480;
	
	localparam paddlewidth = 16;
	localparam paddleheight = 80;
	
	localparam L_position = 20;
	localparam R_position = 20;
		
	always @ (posedge clk_1ms)
	begin
		if(!reset)
		begin	
			x_paddle1 <= L_position + (paddlewidth/2);
			y_paddle1 <= V_active/2;
		end
		else if (!button && y_paddle1-(paddleheight/2) > 0)
			y_paddle1 <= y_paddle1-1;
		else if (!button1 && y_paddle1+(paddleheight/2) < V_active)
			y_paddle1 <= y_paddle1+1;
		else y_paddle1 <= y_paddle1;
	end
	
	assign paddle1_on = (x >= x_paddle1-(paddlewidth/2) && x <= x_paddle1+(paddlewidth/2) && y >= y_paddle1-(paddleheight/2) && y < y_paddle1+(paddleheight/2))?1:0;

	assign rgb_paddle1 = 12'b111100000000; 
	
	//Second padlle
	always @ (posedge clk_1ms)
	begin
		if(!reset)
		begin	
			x_paddle2 <= H_active-(R_position + (paddlewidth/2));
			y_paddle2 <= V_active/2;
		end
		else if (!button2 && y_paddle2-(paddleheight/2) > 0)
			y_paddle2 <= y_paddle2-1;
		else if (!button3 && y_paddle2+(paddleheight/2) < V_active )
			y_paddle2 <= y_paddle2+1;
		else y_paddle2 <= y_paddle2;
	end
	
	assign paddle2_on = (x >= x_paddle2-(paddlewidth/2) && x <= x_paddle2+(paddlewidth/2) && y >= y_paddle2-(paddleheight/2) && y < y_paddle2+(paddleheight/2))?1:0;

	assign rgb_paddle2 = 12'b000000001111; //orange =12'bb111101110000
	
endmodule
