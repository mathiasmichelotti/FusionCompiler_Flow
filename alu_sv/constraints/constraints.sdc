create_clock \
    -name clk \
    -period 10 \
    [get_ports i_clk]

set_clock_uncertainty 0.1 [get_clocks clk]

set_input_delay 2 \
    -clock clk \
    [get_ports {
        i_sel_op[*]
        i_op_a[*]
        i_op_b[*]
    }]

set_output_delay 2 \
    -clock clk \
    [get_ports o_res[*]]