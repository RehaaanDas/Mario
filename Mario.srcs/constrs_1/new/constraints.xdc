create_clock -name sys_clk -period 10.0 [get_ports CLK] -waveform {0 5};
set_clock_uncertainty -setup 0.2 -hold 0.1 [get_clocks sys_clk]