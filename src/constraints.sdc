create_clock -name {clock} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clock}]
derive_pll_clocks -create_base_clocks
