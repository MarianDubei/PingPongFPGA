`include "vgaHdmi.v"
`include "i2c/I2C_HDMI_Config.v"

module TopModule(

  input clock50, reset_n, button, button1, button2, button3,

  // ** HDMI CONNECTIONS **
  // AUDIO
  output HDMI_I2S0,  
  output HDMI_MCLK,  
  output HDMI_LRCLK, 
  output HDMI_SCLK,  

  // VIDEO
  output [23:0] HDMI_TX_D, // RGBchannel
  output HDMI_TX_VS,  // vsync
  output HDMI_TX_HS,  // hsync
  output HDMI_TX_DE,  // dataEnable
  output HDMI_TX_CLK, // vgaClock

  // REGISTERS AND CONFIG LOGIC
  input HDMI_TX_INT,
  inout HDMI_I2C_SDA,  // HDMI i2c data
  output HDMI_I2C_SCL, // HDMI i2c clock
  output READY        // HDMI is ready signal from i2c module
  // ********************************** //
  );

	wire [23:0] rgb;
		
	
	wire [9:0] x,y;
	
	wire video_on;
	wire clk_1ms;
	
	wire [11:0] rgb_paddle1, rgb_paddle2, rgb_ball;
	wire ball_on, paddle1_on, paddle2_on;
	wire [9:0] x_paddle1, x_paddle2, y_paddle1, y_paddle2;
	wire [3:0] p1_score, p2_score;
	wire [1:0] game_state;
	
	wire clock25, locked;
	wire reset;
	assign reset = ~reset_n;
	assign HDMI_I2S0  = 1'b z;
	assign HDMI_MCLK  = 1'b z;
	assign HDMI_LRCLK = 1'b z;
	assign HDMI_SCLK  = 1'b z;

	// **VGA CLOCK**
	pll_25 pll_25(
	  .refclk(clock50),
	  .rst(reset),

	  .outclk_0(clock25),
	  .locked(locked)
	  );

	// **VGA MAIN CONTROLLER**
	vgaHdmi vgaHdmi (
	  // input
	  .clock      (clock25),
	  .clock50    (clock50),
	  .reset      (~locked),
	  .hsync      (HDMI_TX_HS),
	  .vsync      (HDMI_TX_VS),
	  .rgb		  (rgb),

	  // output
	  .dataEnable (HDMI_TX_DE),
	  .vgaClock   (HDMI_TX_CLK),
	  .RGBchannel (HDMI_TX_D),
	  .video_on (video_on),
	  .x(x), .y(y)
	);

	// **I2C Interface for ADV7513 initial config**
	I2C_HDMI_Config #(
	  .CLK_Freq (50000000),
	  .I2C_Freq (20000)    
	  )

	  I2C_HDMI_Config (
	  .iCLK        (clock50),
	  .iRST_N      (reset_n),
	  .I2C_SCLK    (HDMI_I2C_SCL),
	  .I2C_SDAT    (HDMI_I2C_SDA),
	  .HDMI_TX_INT (HDMI_TX_INT),
	  .READY       (READY)
	);

  	render r1	(.clk(clock50), .reset(reset), .x(x), .y(y), .video_on(video_on), .rgb(rgb), .clk_1ms(clk_1ms),
					.paddle1_on(paddle1_on), .paddle2_on(paddle2_on), .ball_on(ball_on), 
					.rgb_paddle1(rgb_paddle1), .rgb_paddle2(rgb_paddle2), .rgb_ball(rgb_ball),
					.game_state(game_state));
				
	clock_divider c1 (.clk(clock50), .clk_1ms(clk_1ms));
	
	ball b1 	(.clk(clock50), .clk_1ms(clk_1ms), .reset(reset), .x(x), .y(y),  .ball_on(ball_on), .rgb_ball(rgb_ball),
				.x_paddle1(x_paddle1), .x_paddle2(x_paddle2), .y_paddle1(y_paddle1), .y_paddle2(y_paddle2),
				.p1_score(p1_score), .p2_score(p2_score), .game_state(game_state));
	
	paddle p1	(.clk_1ms(clk_1ms), .reset(reset), .x(x), .y(y),
					 .button(button), .button1(button1),  .button2(button2), .button3(button3),
					.paddle1_on(paddle1_on), .rgb_paddle1(rgb_paddle1), .paddle2_on(paddle2_on), .rgb_paddle2(rgb_paddle2),
					.x_paddle1(x_paddle1), .x_paddle2(x_paddle2), .y_paddle1(y_paddle1), .y_paddle2(y_paddle2) );

	game_state(.clk(clock50), .clk_1ms(clk_1ms), .reset(reset), .p1_score(p1_score), .p2_score(p2_score), .game_state(game_state));
	  

endmodule