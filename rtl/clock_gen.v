`resetall
`timescale 1ns / 1ps
`default_nettype none

module clock_gen #(
    parameter ARCH = "xilinx"
)(
    output wire clk_out
);

`ifdef ARCH_ECP5
    OSCG #(.DIV(8)) osc_inst (.OSC(clk_out));
`elsif ARCH_ICE40
    SB_HFOSC #(.CLKHF_DIV("0b00")) hfosc_inst (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(clk_out));
`elsif ARCH_ARTIX7
    wire cfgmclk;
    STARTUPE2 startupe2_inst (.CFGMCLK(cfgmclk));
    BUFG clk_bufg_inst (.I(cfgmclk), .O(clk_out));
`else
    // Default to STARTUPE3 for UltraScale/UltraScale+
    wire cfgmclk;
    STARTUPE3 startupe3_inst (.CFGMCLK(cfgmclk));
    BUFG clk_bufg_inst (.I(cfgmclk), .O(clk_out));
`endif

endmodule
`resetall
