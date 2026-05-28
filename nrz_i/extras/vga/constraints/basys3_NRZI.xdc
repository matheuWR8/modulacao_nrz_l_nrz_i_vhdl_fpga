## ============================================================
## basys_nrzi.xdc  -  Basys3 / xc7a35tcpg236-1
## Projeto: Modulação NRZ-I com 16 chaves e 16 LEDs
## ============================================================


## ── CLOCK 100 MHz ────────────────────────────────────────────
set_property PACKAGE_PIN W5 [get_ports {clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {clk}]


## ── BOTÃO BTNC (U18) - toggle de reset ───────────────────────
## 1º clique: reset = '0' → captura chaves e inicia modulação
## 2º clique: reset = '1' → pausa modulação para nova entrada
set_property PACKAGE_PIN U18 [get_ports {btn}]
set_property IOSTANDARD LVCMOS33 [get_ports {btn}]


## LED EXTRA PARA SAÍDA SERIAL NRZI
set_property PACKAGE_PIN U2 [get_ports nrzi_out]
set_property IOSTANDARD LVCMOS33 [get_ports nrzi_out]


## ── SWITCHES SW0..SW15 → o_swv[0..15] ───────────────────────
## SW0 
set_property PACKAGE_PIN V17 [get_ports {o_swv[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[0]}]

## SW1
set_property PACKAGE_PIN V16 [get_ports {o_swv[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[1]}]

## SW2
set_property PACKAGE_PIN W16 [get_ports {o_swv[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[2]}]

## SW3
set_property PACKAGE_PIN W17 [get_ports {o_swv[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[3]}]

## SW4
set_property PACKAGE_PIN W15 [get_ports {o_swv[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[4]}]

## SW5
set_property PACKAGE_PIN V15 [get_ports {o_swv[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[5]}]

## SW6
set_property PACKAGE_PIN W14 [get_ports {o_swv[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[6]}]

## SW7
set_property PACKAGE_PIN W13 [get_ports {o_swv[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[7]}]

## SW8
set_property PACKAGE_PIN V2 [get_ports {o_swv[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[8]}]

## SW9
set_property PACKAGE_PIN T3 [get_ports {o_swv[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[9]}]

## SW10
set_property PACKAGE_PIN T2 [get_ports {o_swv[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[10]}]

## SW11
set_property PACKAGE_PIN R3 [get_ports {o_swv[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[11]}]

## SW12
set_property PACKAGE_PIN W2 [get_ports {o_swv[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[12]}]

## SW13
set_property PACKAGE_PIN U1 [get_ports {o_swv[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[13]}]

## SW14
set_property PACKAGE_PIN T1 [get_ports {o_swv[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[14]}]

## SW15
set_property PACKAGE_PIN R2 [get_ports {o_swv[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_swv[15]}]


## ── LEDs LD0..LD15 → leds_out[0..15] ────────────────────────
## LD0
set_property PACKAGE_PIN U16 [get_ports {leds_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[0]}]

## LD1
set_property PACKAGE_PIN E19 [get_ports {leds_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[1]}]

## LD2
set_property PACKAGE_PIN U19 [get_ports {leds_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[2]}]

## LD3
set_property PACKAGE_PIN V19 [get_ports {leds_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[3]}]

## LD4
set_property PACKAGE_PIN W18 [get_ports {leds_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[4]}]

## LD5
set_property PACKAGE_PIN U15 [get_ports {leds_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[5]}]

## LD6
set_property PACKAGE_PIN U14 [get_ports {leds_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[6]}]

## LD7
set_property PACKAGE_PIN V14 [get_ports {leds_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[7]}]

## LD8
set_property PACKAGE_PIN V13 [get_ports {leds_out[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[8]}]

## LD9
set_property PACKAGE_PIN V3 [get_ports {leds_out[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[9]}]

## LD10
set_property PACKAGE_PIN W3 [get_ports {leds_out[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[10]}]

## LD11
set_property PACKAGE_PIN U3 [get_ports {leds_out[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[11]}]

## LD12
set_property PACKAGE_PIN P3 [get_ports {leds_out[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[12]}]

## LD13
set_property PACKAGE_PIN N3 [get_ports {leds_out[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[13]}]

## LD14
set_property PACKAGE_PIN P1 [get_ports {leds_out[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[14]}]

## LD15
set_property PACKAGE_PIN L1 [get_ports {leds_out[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[15]}]



## VGA

set_property PACKAGE_PIN P19 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]

set_property PACKAGE_PIN R19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

set_property PACKAGE_PIN J17 [get_ports {vgaGreen[0]}]
set_property PACKAGE_PIN H17 [get_ports {vgaGreen[1]}]
set_property PACKAGE_PIN G17 [get_ports {vgaGreen[2]}]
set_property PACKAGE_PIN D17 [get_ports {vgaGreen[3]}]

set_property PACKAGE_PIN G19 [get_ports {vgaRed[0]}]
set_property PACKAGE_PIN H19 [get_ports {vgaRed[1]}]
set_property PACKAGE_PIN J19 [get_ports {vgaRed[2]}]
set_property PACKAGE_PIN N19 [get_ports {vgaRed[3]}]

set_property PACKAGE_PIN N18 [get_ports {vgaBlue[0]}]
set_property PACKAGE_PIN L18 [get_ports {vgaBlue[1]}]
set_property PACKAGE_PIN K18 [get_ports {vgaBlue[2]}]
set_property PACKAGE_PIN J18 [get_ports {vgaBlue[3]}]


set_property IOSTANDARD LVCMOS33 [get_ports vgaGreen[*]]
set_property IOSTANDARD LVCMOS33 [get_ports vgaRed[*]]
set_property IOSTANDARD LVCMOS33 [get_ports vgaBlue[*]]
