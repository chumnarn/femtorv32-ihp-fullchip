// SPDX-License-Identifier: Apache-2.0
// FemtoRV32 + 64 KiB IHP SRAM full-chip pad wrapper for IHP SG13G2.
`default_nettype none

module chip_top (
`ifdef USE_POWER_PINS
    inout wire IOVDD,
    inout wire IOVSS,
    inout wire VDD,
    inout wire VSS,
`endif
    inout wire       clk_PAD,
    inout wire       rst_n_PAD,
    inout wire       uart_rx_PAD,
    inout wire       uart_tx_PAD,
    inout wire [3:0] led_PAD
);
    wire clk_i;
    wire rst_n_i;
    wire uart_rx_i;
    wire uart_tx_o;
    wire [3:0] led_o;

    // Two pads per supply rail provide a balanced baseline pad ring.
    generate
        for (genvar i=0; i<2; i++) begin : vdd_pads
            (* keep *) sg13g2_IOPadVdd vdd_pad (
`ifdef USE_POWER_PINS
                .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
            );
        end
        for (genvar i=0; i<2; i++) begin : vss_pads
            (* keep *) sg13g2_IOPadVss vss_pad (
`ifdef USE_POWER_PINS
                .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
            );
        end
        for (genvar i=0; i<2; i++) begin : iovdd_pads
            (* keep *) sg13g2_IOPadIOVdd iovdd_pad (
`ifdef USE_POWER_PINS
                .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
            );
        end
        for (genvar i=0; i<2; i++) begin : iovss_pads
            (* keep *) sg13g2_IOPadIOVss iovss_pad (
`ifdef USE_POWER_PINS
                .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS)
`endif
            );
        end
    endgenerate

    sg13g2_IOPadIn clk_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
        .p2c(clk_i), .pad(clk_PAD)
    );

    sg13g2_IOPadIn rst_n_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
        .p2c(rst_n_i), .pad(rst_n_PAD)
    );

    sg13g2_IOPadIn uart_rx_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
        .p2c(uart_rx_i), .pad(uart_rx_PAD)
    );

    sg13g2_IOPadOut4mA uart_tx_pad (
`ifdef USE_POWER_PINS
        .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
        .c2p(uart_tx_o), .pad(uart_tx_PAD)
    );

    generate
        for (genvar i=0; i<4; i++) begin : leds
            sg13g2_IOPadOut4mA led_pad (
`ifdef USE_POWER_PINS
                .iovdd(IOVDD), .iovss(IOVSS), .vdd(VDD), .vss(VSS),
`endif
                .c2p(led_o[i]), .pad(led_PAD[i])
            );
        end
    endgenerate

chip_core i_chip_core (
    .clk     (clk_i),
    .rst_n   (rst_n_i),
    .led     (led_o),
    .uart_tx (uart_tx_o),
    .uart_rx (uart_rx_i)
);
endmodule

`default_nettype wire
