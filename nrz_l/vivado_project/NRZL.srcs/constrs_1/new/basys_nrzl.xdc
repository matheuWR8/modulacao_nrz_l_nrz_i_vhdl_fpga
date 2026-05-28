## CLOCK 100 MHz
set_property PACKAGE_PIN W5 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}]

## BUTTON BTNC

set_property PACKAGE_PIN U18 [get_ports btn]
set_property IOSTANDARD LVCMOS33 [get_ports btn]

## LED EXTRA PARA SAÍDA SERIAL NRZL
set_property PACKAGE_PIN U2 [get_ports nrzl_out]
set_property IOSTANDARD LVCMOS33 [get_ports nrzl_out]

## Switches

set_property PACKAGE_PIN R2 [get_ports {o_swv[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[0]}]

set_property PACKAGE_PIN T1 [get_ports {o_swv[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[1]}]

set_property PACKAGE_PIN U1 [get_ports {o_swv[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[2]}]

set_property PACKAGE_PIN W2 [get_ports {o_swv[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[3]}]

set_property PACKAGE_PIN R3 [get_ports {o_swv[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[4]}]

set_property PACKAGE_PIN T2 [get_ports {o_swv[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[5]}]

set_property PACKAGE_PIN T3 [get_ports {o_swv[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[6]}]

set_property PACKAGE_PIN V2 [get_ports {o_swv[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[7]}]

set_property PACKAGE_PIN W13 [get_ports {o_swv[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[8]}]

set_property PACKAGE_PIN W14 [get_ports {o_swv[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[9]}]

set_property PACKAGE_PIN V15 [get_ports {o_swv[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[10]}]

set_property PACKAGE_PIN W15 [get_ports {o_swv[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[11]}]

set_property PACKAGE_PIN W17 [get_ports {o_swv[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[12]}]

set_property PACKAGE_PIN W16 [get_ports {o_swv[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[13]}]

set_property PACKAGE_PIN V16 [get_ports {o_swv[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[14]}]

set_property PACKAGE_PIN V17 [get_ports {o_swv[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[15]}]


## LEDs
set_property PACKAGE_PIN U16 [get_ports {leds_out[15]}]
set_property PACKAGE_PIN E19 [get_ports {leds_out[14]}]
set_property PACKAGE_PIN U19 [get_ports {leds_out[13]}]
set_property PACKAGE_PIN V19 [get_ports {leds_out[12]}]

set_property PACKAGE_PIN W18 [get_ports {leds_out[11]}]
set_property PACKAGE_PIN U15 [get_ports {leds_out[10]}]
set_property PACKAGE_PIN U14 [get_ports {leds_out[9]}]
set_property PACKAGE_PIN V14 [get_ports {leds_out[8]}]

set_property PACKAGE_PIN V13 [get_ports {leds_out[7]}]
set_property PACKAGE_PIN V3 [get_ports {leds_out[6]}]
set_property PACKAGE_PIN W3 [get_ports {leds_out[5]}]
set_property PACKAGE_PIN U3 [get_ports {leds_out[4]}]

set_property PACKAGE_PIN P3 [get_ports {leds_out[3]}]
set_property PACKAGE_PIN N3 [get_ports {leds_out[2]}]
set_property PACKAGE_PIN P1 [get_ports {leds_out[1]}]
set_property PACKAGE_PIN L1 [get_ports {leds_out[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[*]}]
