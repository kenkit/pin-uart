/* Generated Verilog ... */
`resetall
`timescale 1ns / 1ps
`default_nettype none

module fpga (
    input wire clk,
    output wire PA3,
    output wire PA4,
    output wire PA5,
    output wire PA6,
    output wire PA7,
    output wire PA8,
    output wire PA9,
    output wire PA10,
    output wire PA11,
    output wire PA12,
    output wire PA13,
    output wire PA14,
    output wire PA15,
    output wire PB1,
    output wire PB2,
    output wire PB3,
    output wire PB4,
    output wire PB5,
    output wire PB6,
    output wire PB7,
    output wire PB8,
    output wire PB9,
    output wire PB10,
    output wire PB11,
    output wire PB12,
    output wire PB13,
    output wire PB14,
    output wire PB15,
    output wire PB16,
    output wire PC1,
    output wire PC2,
    output wire PC3,
    output wire PC4,
    output wire PC5,
    output wire PC6,
    output wire PC7,
    output wire PC8,
    output wire PC9,
    output wire PC10,
    output wire PC11,
    output wire PC12,
    output wire PC13,
    output wire PC14,
    output wire PC15,
    output wire PC16,
    output wire PD1,
    output wire PD3,
    output wire PD4,
    output wire PD5,
    output wire PD6,
    output wire PD7,
    output wire PD8,
    output wire PD9,
    output wire PD10,
    output wire PD11,
    output wire PD12,
    output wire PD13,
    output wire PD14,
    output wire PD16,
    output wire PE1,
    output wire PE2,
    output wire PE3,
    output wire PE4,
    output wire PE5,
    output wire PE6,
    output wire PE7,
    output wire PE8,
    output wire PE9,
    output wire PE10,
    output wire PE11,
    output wire PE12,
    output wire PE13,
    output wire PE14,
    output wire PE15,
    output wire PE16,
    output wire PF1,
    output wire PF2,
    output wire PF3,
    output wire PF4,
    output wire PF5,
    output wire PF12,
    output wire PF13,
    output wire PF14,
    output wire PF15,
    output wire PF16,
    output wire PG1,
    output wire PG2,
    output wire PG3,
    output wire PG4,
    output wire PG5,
    output wire PG12,
    output wire PG13,
    output wire PG14,
    output wire PG15,
    output wire PG16,
    output wire PH2,
    output wire PH3,
    output wire PH4,
    output wire PH5,
    output wire PH12,
    output wire PH13,
    output wire PH14,
    output wire PH15,
    output wire PJ1,
    output wire PJ2,
    output wire PJ3,
    output wire PJ4,
    output wire PJ5,
    output wire PJ12,
    output wire PJ13,
    output wire PJ14,
    output wire PJ15,
    output wire PJ16,
    output wire PK1,
    output wire PK2,
    output wire PK3,
    output wire PK4,
    output wire PK5,
    output wire PK12,
    output wire PK13,
    output wire PK14,
    output wire PK15,
    output wire PK16,
    output wire PL1,
    output wire PL2,
    output wire PL3,
    output wire PL4,
    output wire PL5,
    output wire PL12,
    output wire PL13,
    output wire PL14,
    output wire PL15,
    output wire PL16,
    output wire PM1,
    output wire PM2,
    output wire PM3,
    output wire PM4,
    output wire PM5,
    output wire PM6,
    output wire PM7,
    output wire PM8,
    output wire PM9,
    output wire PM11,
    output wire PM12,
    output wire PM13,
    output wire PM14,
    output wire PM15,
    output wire PM16,
    output wire PN1,
    output wire PN3,
    output wire PN4,
    output wire PN5,
    output wire PN6,
    output wire PN7,
    output wire PN8,
    output wire PN11,
    output wire PN12,
    output wire PN13,
    output wire PN14,
    output wire PN16,
    output wire PP1,
    output wire PP2,
    output wire PP3,
    output wire PP4,
    output wire PP5,
    output wire PP6,
    output wire PP7,
    output wire PP8,
    output wire PP11,
    output wire PP12,
    output wire PP13,
    output wire PP14,
    output wire PP15,
    output wire PP16,
    output wire PR1,
    output wire PR2,
    output wire PR3,
    output wire PR4,
    output wire PR5,
    output wire PR6,
    output wire PR7,
    output wire PR8,
    output wire PR12,
    output wire PR13,
    output wire PR14,
    output wire PR15,
    output wire PR16,
    output wire PT2,
    output wire PT3,
    output wire PT4,
    output wire PT6,
    output wire PT7,
    output wire PT8,
    output wire PT13,
    output wire PT14,
    output wire PT15
);

wire clk_int;
// External clock input
assign clk_int = clk;

localparam CLK_FREQ = 50000000;
localparam BAUD = 115200;
localparam PIN_COUNT = 196;
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

pin_uart #(.NAME("A3")) pin_PA3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[0%GROUP_COUNT]), .out(PA3));
pin_uart #(.NAME("A4")) pin_PA4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[1%GROUP_COUNT]), .out(PA4));
pin_uart #(.NAME("A5")) pin_PA5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[2%GROUP_COUNT]), .out(PA5));
pin_uart #(.NAME("A6")) pin_PA6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[3%GROUP_COUNT]), .out(PA6));
pin_uart #(.NAME("A7")) pin_PA7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[4%GROUP_COUNT]), .out(PA7));
pin_uart #(.NAME("A8")) pin_PA8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[5%GROUP_COUNT]), .out(PA8));
pin_uart #(.NAME("A9")) pin_PA9_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[6%GROUP_COUNT]), .out(PA9));
pin_uart #(.NAME("A10")) pin_PA10_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[7%GROUP_COUNT]), .out(PA10));
pin_uart #(.NAME("A11")) pin_PA11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[8%GROUP_COUNT]), .out(PA11));
pin_uart #(.NAME("A12")) pin_PA12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[9%GROUP_COUNT]), .out(PA12));
pin_uart #(.NAME("A13")) pin_PA13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[10%GROUP_COUNT]), .out(PA13));
pin_uart #(.NAME("A14")) pin_PA14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[11%GROUP_COUNT]), .out(PA14));
pin_uart #(.NAME("A15")) pin_PA15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[12%GROUP_COUNT]), .out(PA15));
pin_uart #(.NAME("B1")) pin_PB1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[13%GROUP_COUNT]), .out(PB1));
pin_uart #(.NAME("B2")) pin_PB2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[14%GROUP_COUNT]), .out(PB2));
pin_uart #(.NAME("B3")) pin_PB3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[15%GROUP_COUNT]), .out(PB3));
pin_uart #(.NAME("B4")) pin_PB4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[16%GROUP_COUNT]), .out(PB4));
pin_uart #(.NAME("B5")) pin_PB5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[17%GROUP_COUNT]), .out(PB5));
pin_uart #(.NAME("B6")) pin_PB6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[18%GROUP_COUNT]), .out(PB6));
pin_uart #(.NAME("B7")) pin_PB7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[19%GROUP_COUNT]), .out(PB7));
pin_uart #(.NAME("B8")) pin_PB8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[20%GROUP_COUNT]), .out(PB8));
pin_uart #(.NAME("B9")) pin_PB9_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[21%GROUP_COUNT]), .out(PB9));
pin_uart #(.NAME("B10")) pin_PB10_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[22%GROUP_COUNT]), .out(PB10));
pin_uart #(.NAME("B11")) pin_PB11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[23%GROUP_COUNT]), .out(PB11));
pin_uart #(.NAME("B12")) pin_PB12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[24%GROUP_COUNT]), .out(PB12));
pin_uart #(.NAME("B13")) pin_PB13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[25%GROUP_COUNT]), .out(PB13));
pin_uart #(.NAME("B14")) pin_PB14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[26%GROUP_COUNT]), .out(PB14));
pin_uart #(.NAME("B15")) pin_PB15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[27%GROUP_COUNT]), .out(PB15));
pin_uart #(.NAME("B16")) pin_PB16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[28%GROUP_COUNT]), .out(PB16));
pin_uart #(.NAME("C1")) pin_PC1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[29%GROUP_COUNT]), .out(PC1));
pin_uart #(.NAME("C2")) pin_PC2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[30%GROUP_COUNT]), .out(PC2));
pin_uart #(.NAME("C3")) pin_PC3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[31%GROUP_COUNT]), .out(PC3));
pin_uart #(.NAME("C4")) pin_PC4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[32%GROUP_COUNT]), .out(PC4));
pin_uart #(.NAME("C5")) pin_PC5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[33%GROUP_COUNT]), .out(PC5));
pin_uart #(.NAME("C6")) pin_PC6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[34%GROUP_COUNT]), .out(PC6));
pin_uart #(.NAME("C7")) pin_PC7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[35%GROUP_COUNT]), .out(PC7));
pin_uart #(.NAME("C8")) pin_PC8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[36%GROUP_COUNT]), .out(PC8));
pin_uart #(.NAME("C9")) pin_PC9_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[37%GROUP_COUNT]), .out(PC9));
pin_uart #(.NAME("C10")) pin_PC10_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[38%GROUP_COUNT]), .out(PC10));
pin_uart #(.NAME("C11")) pin_PC11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[39%GROUP_COUNT]), .out(PC11));
pin_uart #(.NAME("C12")) pin_PC12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[40%GROUP_COUNT]), .out(PC12));
pin_uart #(.NAME("C13")) pin_PC13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[41%GROUP_COUNT]), .out(PC13));
pin_uart #(.NAME("C14")) pin_PC14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[42%GROUP_COUNT]), .out(PC14));
pin_uart #(.NAME("C15")) pin_PC15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[43%GROUP_COUNT]), .out(PC15));
pin_uart #(.NAME("C16")) pin_PC16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[44%GROUP_COUNT]), .out(PC16));
pin_uart #(.NAME("D1")) pin_PD1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[45%GROUP_COUNT]), .out(PD1));
pin_uart #(.NAME("D3")) pin_PD3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[46%GROUP_COUNT]), .out(PD3));
pin_uart #(.NAME("D4")) pin_PD4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[47%GROUP_COUNT]), .out(PD4));
pin_uart #(.NAME("D5")) pin_PD5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[48%GROUP_COUNT]), .out(PD5));
pin_uart #(.NAME("D6")) pin_PD6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[49%GROUP_COUNT]), .out(PD6));
pin_uart #(.NAME("D7")) pin_PD7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[50%GROUP_COUNT]), .out(PD7));
pin_uart #(.NAME("D8")) pin_PD8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[51%GROUP_COUNT]), .out(PD8));
pin_uart #(.NAME("D9")) pin_PD9_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[52%GROUP_COUNT]), .out(PD9));
pin_uart #(.NAME("D10")) pin_PD10_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[53%GROUP_COUNT]), .out(PD10));
pin_uart #(.NAME("D11")) pin_PD11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[54%GROUP_COUNT]), .out(PD11));
pin_uart #(.NAME("D12")) pin_PD12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[55%GROUP_COUNT]), .out(PD12));
pin_uart #(.NAME("D13")) pin_PD13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[56%GROUP_COUNT]), .out(PD13));
pin_uart #(.NAME("D14")) pin_PD14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[57%GROUP_COUNT]), .out(PD14));
pin_uart #(.NAME("D16")) pin_PD16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[58%GROUP_COUNT]), .out(PD16));
pin_uart #(.NAME("E1")) pin_PE1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[59%GROUP_COUNT]), .out(PE1));
pin_uart #(.NAME("E2")) pin_PE2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[60%GROUP_COUNT]), .out(PE2));
pin_uart #(.NAME("E3")) pin_PE3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[61%GROUP_COUNT]), .out(PE3));
pin_uart #(.NAME("E4")) pin_PE4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[62%GROUP_COUNT]), .out(PE4));
pin_uart #(.NAME("E5")) pin_PE5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[63%GROUP_COUNT]), .out(PE5));
pin_uart #(.NAME("E6")) pin_PE6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[64%GROUP_COUNT]), .out(PE6));
pin_uart #(.NAME("E7")) pin_PE7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[65%GROUP_COUNT]), .out(PE7));
pin_uart #(.NAME("E8")) pin_PE8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[66%GROUP_COUNT]), .out(PE8));
pin_uart #(.NAME("E9")) pin_PE9_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[67%GROUP_COUNT]), .out(PE9));
pin_uart #(.NAME("E10")) pin_PE10_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[68%GROUP_COUNT]), .out(PE10));
pin_uart #(.NAME("E11")) pin_PE11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[69%GROUP_COUNT]), .out(PE11));
pin_uart #(.NAME("E12")) pin_PE12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[70%GROUP_COUNT]), .out(PE12));
pin_uart #(.NAME("E13")) pin_PE13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[71%GROUP_COUNT]), .out(PE13));
pin_uart #(.NAME("E14")) pin_PE14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[72%GROUP_COUNT]), .out(PE14));
pin_uart #(.NAME("E15")) pin_PE15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[73%GROUP_COUNT]), .out(PE15));
pin_uart #(.NAME("E16")) pin_PE16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[74%GROUP_COUNT]), .out(PE16));
pin_uart #(.NAME("F1")) pin_PF1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[75%GROUP_COUNT]), .out(PF1));
pin_uart #(.NAME("F2")) pin_PF2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[76%GROUP_COUNT]), .out(PF2));
pin_uart #(.NAME("F3")) pin_PF3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[77%GROUP_COUNT]), .out(PF3));
pin_uart #(.NAME("F4")) pin_PF4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[78%GROUP_COUNT]), .out(PF4));
pin_uart #(.NAME("F5")) pin_PF5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[79%GROUP_COUNT]), .out(PF5));
pin_uart #(.NAME("F12")) pin_PF12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[80%GROUP_COUNT]), .out(PF12));
pin_uart #(.NAME("F13")) pin_PF13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[81%GROUP_COUNT]), .out(PF13));
pin_uart #(.NAME("F14")) pin_PF14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[82%GROUP_COUNT]), .out(PF14));
pin_uart #(.NAME("F15")) pin_PF15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[83%GROUP_COUNT]), .out(PF15));
pin_uart #(.NAME("F16")) pin_PF16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[84%GROUP_COUNT]), .out(PF16));
pin_uart #(.NAME("G1")) pin_PG1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[85%GROUP_COUNT]), .out(PG1));
pin_uart #(.NAME("G2")) pin_PG2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[86%GROUP_COUNT]), .out(PG2));
pin_uart #(.NAME("G3")) pin_PG3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[87%GROUP_COUNT]), .out(PG3));
pin_uart #(.NAME("G4")) pin_PG4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[88%GROUP_COUNT]), .out(PG4));
pin_uart #(.NAME("G5")) pin_PG5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[89%GROUP_COUNT]), .out(PG5));
pin_uart #(.NAME("G12")) pin_PG12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[90%GROUP_COUNT]), .out(PG12));
pin_uart #(.NAME("G13")) pin_PG13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[91%GROUP_COUNT]), .out(PG13));
pin_uart #(.NAME("G14")) pin_PG14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[92%GROUP_COUNT]), .out(PG14));
pin_uart #(.NAME("G15")) pin_PG15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[93%GROUP_COUNT]), .out(PG15));
pin_uart #(.NAME("G16")) pin_PG16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[94%GROUP_COUNT]), .out(PG16));
pin_uart #(.NAME("H2")) pin_PH2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[95%GROUP_COUNT]), .out(PH2));
pin_uart #(.NAME("H3")) pin_PH3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[96%GROUP_COUNT]), .out(PH3));
pin_uart #(.NAME("H4")) pin_PH4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[97%GROUP_COUNT]), .out(PH4));
pin_uart #(.NAME("H5")) pin_PH5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[98%GROUP_COUNT]), .out(PH5));
pin_uart #(.NAME("H12")) pin_PH12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[99%GROUP_COUNT]), .out(PH12));
pin_uart #(.NAME("H13")) pin_PH13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[100%GROUP_COUNT]), .out(PH13));
pin_uart #(.NAME("H14")) pin_PH14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[101%GROUP_COUNT]), .out(PH14));
pin_uart #(.NAME("H15")) pin_PH15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[102%GROUP_COUNT]), .out(PH15));
pin_uart #(.NAME("J1")) pin_PJ1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[103%GROUP_COUNT]), .out(PJ1));
pin_uart #(.NAME("J2")) pin_PJ2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[104%GROUP_COUNT]), .out(PJ2));
pin_uart #(.NAME("J3")) pin_PJ3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[105%GROUP_COUNT]), .out(PJ3));
pin_uart #(.NAME("J4")) pin_PJ4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[106%GROUP_COUNT]), .out(PJ4));
pin_uart #(.NAME("J5")) pin_PJ5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[107%GROUP_COUNT]), .out(PJ5));
pin_uart #(.NAME("J12")) pin_PJ12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[108%GROUP_COUNT]), .out(PJ12));
pin_uart #(.NAME("J13")) pin_PJ13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[109%GROUP_COUNT]), .out(PJ13));
pin_uart #(.NAME("J14")) pin_PJ14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[110%GROUP_COUNT]), .out(PJ14));
pin_uart #(.NAME("J15")) pin_PJ15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[111%GROUP_COUNT]), .out(PJ15));
pin_uart #(.NAME("J16")) pin_PJ16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[112%GROUP_COUNT]), .out(PJ16));
pin_uart #(.NAME("K1")) pin_PK1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[113%GROUP_COUNT]), .out(PK1));
pin_uart #(.NAME("K2")) pin_PK2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[114%GROUP_COUNT]), .out(PK2));
pin_uart #(.NAME("K3")) pin_PK3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[115%GROUP_COUNT]), .out(PK3));
pin_uart #(.NAME("K4")) pin_PK4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[116%GROUP_COUNT]), .out(PK4));
pin_uart #(.NAME("K5")) pin_PK5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[117%GROUP_COUNT]), .out(PK5));
pin_uart #(.NAME("K12")) pin_PK12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[118%GROUP_COUNT]), .out(PK12));
pin_uart #(.NAME("K13")) pin_PK13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[119%GROUP_COUNT]), .out(PK13));
pin_uart #(.NAME("K14")) pin_PK14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[120%GROUP_COUNT]), .out(PK14));
pin_uart #(.NAME("K15")) pin_PK15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[121%GROUP_COUNT]), .out(PK15));
pin_uart #(.NAME("K16")) pin_PK16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[122%GROUP_COUNT]), .out(PK16));
pin_uart #(.NAME("L1")) pin_PL1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[123%GROUP_COUNT]), .out(PL1));
pin_uart #(.NAME("L2")) pin_PL2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[124%GROUP_COUNT]), .out(PL2));
pin_uart #(.NAME("L3")) pin_PL3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[125%GROUP_COUNT]), .out(PL3));
pin_uart #(.NAME("L4")) pin_PL4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[126%GROUP_COUNT]), .out(PL4));
pin_uart #(.NAME("L5")) pin_PL5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[127%GROUP_COUNT]), .out(PL5));
pin_uart #(.NAME("L12")) pin_PL12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[128%GROUP_COUNT]), .out(PL12));
pin_uart #(.NAME("L13")) pin_PL13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[129%GROUP_COUNT]), .out(PL13));
pin_uart #(.NAME("L14")) pin_PL14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[130%GROUP_COUNT]), .out(PL14));
pin_uart #(.NAME("L15")) pin_PL15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[131%GROUP_COUNT]), .out(PL15));
pin_uart #(.NAME("L16")) pin_PL16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[132%GROUP_COUNT]), .out(PL16));
pin_uart #(.NAME("M1")) pin_PM1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[133%GROUP_COUNT]), .out(PM1));
pin_uart #(.NAME("M2")) pin_PM2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[134%GROUP_COUNT]), .out(PM2));
pin_uart #(.NAME("M3")) pin_PM3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[135%GROUP_COUNT]), .out(PM3));
pin_uart #(.NAME("M4")) pin_PM4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[136%GROUP_COUNT]), .out(PM4));
pin_uart #(.NAME("M5")) pin_PM5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[137%GROUP_COUNT]), .out(PM5));
pin_uart #(.NAME("M6")) pin_PM6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[138%GROUP_COUNT]), .out(PM6));
pin_uart #(.NAME("M7")) pin_PM7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[139%GROUP_COUNT]), .out(PM7));
pin_uart #(.NAME("M8")) pin_PM8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[140%GROUP_COUNT]), .out(PM8));
pin_uart #(.NAME("M9")) pin_PM9_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[141%GROUP_COUNT]), .out(PM9));
pin_uart #(.NAME("M11")) pin_PM11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[142%GROUP_COUNT]), .out(PM11));
pin_uart #(.NAME("M12")) pin_PM12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[143%GROUP_COUNT]), .out(PM12));
pin_uart #(.NAME("M13")) pin_PM13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[144%GROUP_COUNT]), .out(PM13));
pin_uart #(.NAME("M14")) pin_PM14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[145%GROUP_COUNT]), .out(PM14));
pin_uart #(.NAME("M15")) pin_PM15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[146%GROUP_COUNT]), .out(PM15));
pin_uart #(.NAME("M16")) pin_PM16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[147%GROUP_COUNT]), .out(PM16));
pin_uart #(.NAME("N1")) pin_PN1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[148%GROUP_COUNT]), .out(PN1));
pin_uart #(.NAME("N3")) pin_PN3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[149%GROUP_COUNT]), .out(PN3));
pin_uart #(.NAME("N4")) pin_PN4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[150%GROUP_COUNT]), .out(PN4));
pin_uart #(.NAME("N5")) pin_PN5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[151%GROUP_COUNT]), .out(PN5));
pin_uart #(.NAME("N6")) pin_PN6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[152%GROUP_COUNT]), .out(PN6));
pin_uart #(.NAME("N7")) pin_PN7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[153%GROUP_COUNT]), .out(PN7));
pin_uart #(.NAME("N8")) pin_PN8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[154%GROUP_COUNT]), .out(PN8));
pin_uart #(.NAME("N11")) pin_PN11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[155%GROUP_COUNT]), .out(PN11));
pin_uart #(.NAME("N12")) pin_PN12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[156%GROUP_COUNT]), .out(PN12));
pin_uart #(.NAME("N13")) pin_PN13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[157%GROUP_COUNT]), .out(PN13));
pin_uart #(.NAME("N14")) pin_PN14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[158%GROUP_COUNT]), .out(PN14));
pin_uart #(.NAME("N16")) pin_PN16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[159%GROUP_COUNT]), .out(PN16));
pin_uart #(.NAME("P1")) pin_PP1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[160%GROUP_COUNT]), .out(PP1));
pin_uart #(.NAME("P2")) pin_PP2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[161%GROUP_COUNT]), .out(PP2));
pin_uart #(.NAME("P3")) pin_PP3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[162%GROUP_COUNT]), .out(PP3));
pin_uart #(.NAME("P4")) pin_PP4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[163%GROUP_COUNT]), .out(PP4));
pin_uart #(.NAME("P5")) pin_PP5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[164%GROUP_COUNT]), .out(PP5));
pin_uart #(.NAME("P6")) pin_PP6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[165%GROUP_COUNT]), .out(PP6));
pin_uart #(.NAME("P7")) pin_PP7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[166%GROUP_COUNT]), .out(PP7));
pin_uart #(.NAME("P8")) pin_PP8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[167%GROUP_COUNT]), .out(PP8));
pin_uart #(.NAME("P11")) pin_PP11_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[168%GROUP_COUNT]), .out(PP11));
pin_uart #(.NAME("P12")) pin_PP12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[169%GROUP_COUNT]), .out(PP12));
pin_uart #(.NAME("P13")) pin_PP13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[170%GROUP_COUNT]), .out(PP13));
pin_uart #(.NAME("P14")) pin_PP14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[171%GROUP_COUNT]), .out(PP14));
pin_uart #(.NAME("P15")) pin_PP15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[172%GROUP_COUNT]), .out(PP15));
pin_uart #(.NAME("P16")) pin_PP16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[173%GROUP_COUNT]), .out(PP16));
pin_uart #(.NAME("R1")) pin_PR1_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[174%GROUP_COUNT]), .out(PR1));
pin_uart #(.NAME("R2")) pin_PR2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[175%GROUP_COUNT]), .out(PR2));
pin_uart #(.NAME("R3")) pin_PR3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[176%GROUP_COUNT]), .out(PR3));
pin_uart #(.NAME("R4")) pin_PR4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[177%GROUP_COUNT]), .out(PR4));
pin_uart #(.NAME("R5")) pin_PR5_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[178%GROUP_COUNT]), .out(PR5));
pin_uart #(.NAME("R6")) pin_PR6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[179%GROUP_COUNT]), .out(PR6));
pin_uart #(.NAME("R7")) pin_PR7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[180%GROUP_COUNT]), .out(PR7));
pin_uart #(.NAME("R8")) pin_PR8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[181%GROUP_COUNT]), .out(PR8));
pin_uart #(.NAME("R12")) pin_PR12_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[182%GROUP_COUNT]), .out(PR12));
pin_uart #(.NAME("R13")) pin_PR13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[183%GROUP_COUNT]), .out(PR13));
pin_uart #(.NAME("R14")) pin_PR14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[184%GROUP_COUNT]), .out(PR14));
pin_uart #(.NAME("R15")) pin_PR15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[185%GROUP_COUNT]), .out(PR15));
pin_uart #(.NAME("R16")) pin_PR16_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[186%GROUP_COUNT]), .out(PR16));
pin_uart #(.NAME("T2")) pin_PT2_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[187%GROUP_COUNT]), .out(PT2));
pin_uart #(.NAME("T3")) pin_PT3_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[188%GROUP_COUNT]), .out(PT3));
pin_uart #(.NAME("T4")) pin_PT4_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[189%GROUP_COUNT]), .out(PT4));
pin_uart #(.NAME("T6")) pin_PT6_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[190%GROUP_COUNT]), .out(PT6));
pin_uart #(.NAME("T7")) pin_PT7_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[191%GROUP_COUNT]), .out(PT7));
pin_uart #(.NAME("T8")) pin_PT8_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[192%GROUP_COUNT]), .out(PT8));
pin_uart #(.NAME("T13")) pin_PT13_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[193%GROUP_COUNT]), .out(PT13));
pin_uart #(.NAME("T14")) pin_PT14_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[194%GROUP_COUNT]), .out(PT14));
pin_uart #(.NAME("T15")) pin_PT15_uart_inst (.clk(clk_int), .rst(shift_rst_reg), .shift(shift_reg[195%GROUP_COUNT]), .out(PT15));

endmodule
`resetall
