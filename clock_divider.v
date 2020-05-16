
module clock_divider(
    input clk,
    output reg clk_1ms = 0
    );
    //No. of seconds*100Mhz/2 
    reg [27:0] i = 0;
    
	 always @ (posedge clk)
    begin
        if (i == 124999)// not 1ms
        begin
            i <= 0;
            clk_1ms = ~clk_1ms;
        end
        else i <= i+1;
    end
    
endmodule

