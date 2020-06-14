`include "vgaHdmi.v"
`include "i2c/I2C_HDMI_Config.v"
module top (
	input clk, reset, button, button1, button2, button3,

	output HDMI_I2S0,  
	output HDMI_MCLK,  
	output HDMI_LRCLK, 
	output HDMI_SCLK,   
	output [23:0] HDMI_TX_D, 
	output HDMI_TX_VS,  
	output HDMI_TX_HS, 
	output HDMI_TX_DE, 
	output HDMI_TX_CLK, 
	input HDMI_TX_INT,
	inout HDMI_I2C_SDA,  
	output HDMI_I2C_SCL,
	output READY        
	);
	
	
	wire [9:0] x,y;
	wire clk_1ms;
	
	wire [23:0] rgb_paddle1, rgb_paddle2, rgb_ball;
	wire ball_on, paddle1_on, paddle2_on;
	wire [9:0] x_paddle1, x_paddle2, y_paddle1, y_paddle2;
	wire [3:0] p1_score, p2_score;
	wire [1:0] game_state;
	
	assign HDMI_I2S0  = 1'b z;
	assign HDMI_MCLK  = 1'b z;
	assign HDMI_LRCLK = 1'b z;
	assign HDMI_SCLK  = 1'b z;
	

	wire clock25, locked;
	wire reset_n;
	assign reset_n = ~reset; 

	pll_25 pll_25(
		.refclk(clk),
		.rst(reset_n),

		.outclk_0(clock25),
		.locked(locked)
	);

	vgaHdmi vgaHdmi (
		// input
		.clock      (clock25),
		.clock50    (clk),
		.reset      (~locked),
		// output
		.pixelH(x),
		.pixelV(y),
		.hsync      (HDMI_TX_HS),
		.vsync      (HDMI_TX_VS),
		.dataEnable (HDMI_TX_DE),
		.vgaClock   (HDMI_TX_CLK),
	);	
	
	render r1	(.clk(clk), .reset(reset), .x(x), .y(y), .video_on(HDMI_TX_DE), .rgb(HDMI_TX_D), .clk_1ms(clk_1ms),
					.paddle1_on(paddle1_on), .paddle2_on(paddle2_on), .ball_on(ball_on), 
					.rgb_paddle1(rgb_paddle1), .rgb_paddle2(rgb_paddle2), .rgb_ball(rgb_ball),
					.game_state(game_state));
	clock_divider c1 (.clk(clk), .clk_1ms(clk_1ms));
	ball b1 	(.clk(clk), .clk_1ms(clk_1ms), .reset(reset), .x(x), .y(y),  .ball_on(ball_on), .rgb_ball(rgb_ball),
				.x_paddle1(x_paddle1), .x_paddle2(x_paddle2), .y_paddle1(y_paddle1), .y_paddle2(y_paddle2),
				.p1_score(p1_score), .p2_score(p2_score), .game_state(game_state));
	paddle p1	(.clk_1ms(clk_1ms), .reset(reset), .x(x), .y(y),
					 .button(button), .button1(button1),  .button2(button2), .button3(button3),
					.paddle1_on(paddle1_on), .rgb_paddle1(rgb_paddle1), .paddle2_on(paddle2_on), .rgb_paddle2(rgb_paddle2),
					.x_paddle1(x_paddle1), .x_paddle2(x_paddle2), .y_paddle1(y_paddle1), .y_paddle2(y_paddle2) );
	game_state(.clk(clk), .clk_1ms(clk_1ms), .reset(reset), .p1_score(p1_score), .p2_score(p2_score), .game_state(game_state));

	
	I2C_HDMI_Config #(
	.CLK_Freq (50000000), 
	.I2C_Freq (20000)    
	)

	I2C_HDMI_Config (
	.iCLK        (clk),
	.iRST_N      (reset),
	.I2C_SCLK    (HDMI_I2C_SCL),
	.I2C_SDAT    (HDMI_I2C_SDA),
	.HDMI_TX_INT (HDMI_TX_INT),
	.READY       (READY)
	);
	
endmodule
