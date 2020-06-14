create_clock -name "clk" -period 20.000ns [get_ports clk]
create_clock -name "i2c_20k_clock" -period 50000.000ns [get_keepers *mI2C_CTRL_CLK]

derive_pll_clocks
derive_clock_uncertainty