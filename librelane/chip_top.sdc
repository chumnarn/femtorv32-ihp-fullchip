current_design $::env(DESIGN_NAME)
set_units -time ns

# 20 MHz baseline clock.  The clock is created at the pad-to-core output pin,
# matching the official IHP full-chip template approach.
create_clock -name sys_clk -period $::env(CLOCK_PERIOD) [get_pins clk_pad/p2c]
set_clock_uncertainty 0.25 [get_clocks sys_clk]

# Async reset does not participate in synchronous timing closure.
set_false_path -from [get_ports rst_n_PAD]

# External interface budgets; adjust when board/package timing is known.
set_input_delay  2.0 -clock sys_clk [get_ports uart_rx_PAD]
set_output_delay 4.0 -clock sys_clk [get_ports uart_tx_PAD]
set_output_delay 4.0 -clock sys_clk [get_ports {led_PAD[*]}]
