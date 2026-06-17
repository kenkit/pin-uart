/* Generated Verilog ... */
`resetall
`timescale 1ns / 1ps
`default_nettype none

module fpga (
    input wire clk,
    output wire PA1,
    output wire PA13,
    output wire PA14,
    output wire PA15,
    output wire PA16,
    output wire PA18,
    output wire PA19,
    output wire PA20,
    output wire PA21,
    output wire PB1,
    output wire PB2,
    output wire PB13,
    output wire PB15,
    output wire PB16,
    output wire PB17,
    output wire PB18,
    output wire PB20,
    output wire PB21,
    output wire PB22,
    output wire PC2,
    output wire PC13,
    output wire PC14,
    output wire PC15,
    output wire PC17,
    output wire PC18,
    output wire PC19,
    output wire PC20,
    output wire PC22,
    output wire PD1,
    output wire PD2,
    output wire PD14,
    output wire PD15,
    output wire PD16,
    output wire PD17,
    output wire PD19,
    output wire PD20,
    output wire PD21,
    output wire PD22,
    output wire PE1,
    output wire PE2,
    output wire PE13,
    output wire PE14,
    output wire PE16,
    output wire PE17,
    output wire PE18,
    output wire PE19,
    output wire PE21,
    output wire PE22,
    output wire PF1,
    output wire PF3,
    output wire PF4,
    output wire PF13,
    output wire PF14,
    output wire PF15,
    output wire PF16,
    output wire PF18,
    output wire PF19,
    output wire PF20,
    output wire PF21,
    output wire PG1,
    output wire PG2,
    output wire PG3,
    output wire PG4,
    output wire PG13
);

wire clk_int;
// External clock input
assign clk_int = clk;

localparam CLK_FREQ = 100000000;
localparam BAUD = 115200;
localparam PIN_COUNT = 64;
localparam GROUP_COUNT = 32;

reg shift_rst_reg = 1'b0;
reg [31:0] group_select_reg = 0;
reg [GROUP_COUNT-1:0] shift_reg = 0;
reg [31:0] prescale_reg = CLK_FREQ / BAUD;
reg [5:0] shift_count_reg = 0;

always @(posedge clk_int) begin
    shift_rst_reg <= 1'b0;
    shift_reg <= 0;
    if (prescale_reg) begin
        prescale_reg <= prescale_reg - 1;
    end else begin
        prescale_reg <= CLK_FREQ / BAUD;
        if (shift_count_reg) begin
            shift_count_reg <= shift_count_reg - 1;
            shift_reg[group_select_reg % GROUP_COUNT] <= 1'b1;
        end else begin
            shift_count_reg <= 6'h3f;
            shift_rst_reg <= 1'b1;
            group_select_reg <= group_select_reg + 1;
        end
    end
end

pin_uart #(.NAME("A1")) pin_PA1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[0%GROUP_COUNT]), .out(PA1));
pin_uart #(.NAME("A13")) pin_PA13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[1%GROUP_COUNT]), .out(PA13));
pin_uart #(.NAME("A14")) pin_PA14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[2%GROUP_COUNT]), .out(PA14));
pin_uart #(.NAME("A15")) pin_PA15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[3%GROUP_COUNT]), .out(PA15));
pin_uart #(.NAME("A16")) pin_PA16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[4%GROUP_COUNT]), .out(PA16));
pin_uart #(.NAME("A18")) pin_PA18_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[5%GROUP_COUNT]), .out(PA18));
pin_uart #(.NAME("A19")) pin_PA19_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[6%GROUP_COUNT]), .out(PA19));
pin_uart #(.NAME("A20")) pin_PA20_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[7%GROUP_COUNT]), .out(PA20));
pin_uart #(.NAME("A21")) pin_PA21_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[8%GROUP_COUNT]), .out(PA21));
pin_uart #(.NAME("B1")) pin_PB1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[9%GROUP_COUNT]), .out(PB1));
pin_uart #(.NAME("B2")) pin_PB2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[10%GROUP_COUNT]), .out(PB2));
pin_uart #(.NAME("B13")) pin_PB13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[11%GROUP_COUNT]), .out(PB13));
pin_uart #(.NAME("B15")) pin_PB15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[12%GROUP_COUNT]), .out(PB15));
pin_uart #(.NAME("B16")) pin_PB16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[13%GROUP_COUNT]), .out(PB16));
pin_uart #(.NAME("B17")) pin_PB17_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[14%GROUP_COUNT]), .out(PB17));
pin_uart #(.NAME("B18")) pin_PB18_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[15%GROUP_COUNT]), .out(PB18));
pin_uart #(.NAME("B20")) pin_PB20_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[16%GROUP_COUNT]), .out(PB20));
pin_uart #(.NAME("B21")) pin_PB21_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[17%GROUP_COUNT]), .out(PB21));
pin_uart #(.NAME("B22")) pin_PB22_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[18%GROUP_COUNT]), .out(PB22));
pin_uart #(.NAME("C2")) pin_PC2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[19%GROUP_COUNT]), .out(PC2));
pin_uart #(.NAME("C13")) pin_PC13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[20%GROUP_COUNT]), .out(PC13));
pin_uart #(.NAME("C14")) pin_PC14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[21%GROUP_COUNT]), .out(PC14));
pin_uart #(.NAME("C15")) pin_PC15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[22%GROUP_COUNT]), .out(PC15));
pin_uart #(.NAME("C17")) pin_PC17_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[23%GROUP_COUNT]), .out(PC17));
pin_uart #(.NAME("C18")) pin_PC18_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[24%GROUP_COUNT]), .out(PC18));
pin_uart #(.NAME("C19")) pin_PC19_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[25%GROUP_COUNT]), .out(PC19));
pin_uart #(.NAME("C20")) pin_PC20_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[26%GROUP_COUNT]), .out(PC20));
pin_uart #(.NAME("C22")) pin_PC22_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[27%GROUP_COUNT]), .out(PC22));
pin_uart #(.NAME("D1")) pin_PD1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[28%GROUP_COUNT]), .out(PD1));
pin_uart #(.NAME("D2")) pin_PD2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[29%GROUP_COUNT]), .out(PD2));
pin_uart #(.NAME("D14")) pin_PD14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[30%GROUP_COUNT]), .out(PD14));
pin_uart #(.NAME("D15")) pin_PD15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[31%GROUP_COUNT]), .out(PD15));
pin_uart #(.NAME("D16")) pin_PD16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[32%GROUP_COUNT]), .out(PD16));
pin_uart #(.NAME("D17")) pin_PD17_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[33%GROUP_COUNT]), .out(PD17));
pin_uart #(.NAME("D19")) pin_PD19_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[34%GROUP_COUNT]), .out(PD19));
pin_uart #(.NAME("D20")) pin_PD20_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[35%GROUP_COUNT]), .out(PD20));
pin_uart #(.NAME("D21")) pin_PD21_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[36%GROUP_COUNT]), .out(PD21));
pin_uart #(.NAME("D22")) pin_PD22_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[37%GROUP_COUNT]), .out(PD22));
pin_uart #(.NAME("E1")) pin_PE1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[38%GROUP_COUNT]), .out(PE1));
pin_uart #(.NAME("E2")) pin_PE2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[39%GROUP_COUNT]), .out(PE2));
pin_uart #(.NAME("E13")) pin_PE13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[40%GROUP_COUNT]), .out(PE13));
pin_uart #(.NAME("E14")) pin_PE14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[41%GROUP_COUNT]), .out(PE14));
pin_uart #(.NAME("E16")) pin_PE16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[42%GROUP_COUNT]), .out(PE16));
pin_uart #(.NAME("E17")) pin_PE17_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[43%GROUP_COUNT]), .out(PE17));
pin_uart #(.NAME("E18")) pin_PE18_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[44%GROUP_COUNT]), .out(PE18));
pin_uart #(.NAME("E19")) pin_PE19_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[45%GROUP_COUNT]), .out(PE19));
pin_uart #(.NAME("E21")) pin_PE21_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[46%GROUP_COUNT]), .out(PE21));
pin_uart #(.NAME("E22")) pin_PE22_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[47%GROUP_COUNT]), .out(PE22));
pin_uart #(.NAME("F1")) pin_PF1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[48%GROUP_COUNT]), .out(PF1));
pin_uart #(.NAME("F3")) pin_PF3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[49%GROUP_COUNT]), .out(PF3));
pin_uart #(.NAME("F4")) pin_PF4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[50%GROUP_COUNT]), .out(PF4));
pin_uart #(.NAME("F13")) pin_PF13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[51%GROUP_COUNT]), .out(PF13));
pin_uart #(.NAME("F14")) pin_PF14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[52%GROUP_COUNT]), .out(PF14));
pin_uart #(.NAME("F15")) pin_PF15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[53%GROUP_COUNT]), .out(PF15));
pin_uart #(.NAME("F16")) pin_PF16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[54%GROUP_COUNT]), .out(PF16));
pin_uart #(.NAME("F18")) pin_PF18_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[55%GROUP_COUNT]), .out(PF18));
pin_uart #(.NAME("F19")) pin_PF19_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[56%GROUP_COUNT]), .out(PF19));
pin_uart #(.NAME("F20")) pin_PF20_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[57%GROUP_COUNT]), .out(PF20));
pin_uart #(.NAME("F21")) pin_PF21_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[58%GROUP_COUNT]), .out(PF21));
pin_uart #(.NAME("G1")) pin_PG1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[59%GROUP_COUNT]), .out(PG1));
pin_uart #(.NAME("G2")) pin_PG2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[60%GROUP_COUNT]), .out(PG2));
pin_uart #(.NAME("G3")) pin_PG3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[61%GROUP_COUNT]), .out(PG3));
pin_uart #(.NAME("G4")) pin_PG4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[62%GROUP_COUNT]), .out(PG4));
pin_uart #(.NAME("G13")) pin_PG13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[63%GROUP_COUNT]), .out(PG13));

endmodule
`resetall
