`timescale 1ns/1ns

module LCM_TB;

    reg         clk;
    reg         rst_n;

    reg         en;

    reg [7:0]   a,b;

    wire        valid;
    wire [15:0] gcd;
    wire [15:0] lcm;

    parameter DATA_WIDTH = 8;





    LCM #(
        .DATA_WIDTH(DATA_WIDTH)
    )u_LCM(
        .clk,
        .rst_n,

        .en,

        .a,
        .b,

        .valid,
        .gcd,
        .lcm
    );


    initial begin
        clk = '0;
        forever #(10) clk = ~clk;
    end

    initial begin
        rst_n = '0;
        en = '0;
        a = 8'd40;
        b = 8'd25;

        #20;

        rst_n = '1;
        
        #20;

        en = '1;

        #40;

        en = '0;

        # 100;

        en = '1;

        #40;

        en = '0;

        #2000;

        $stop;
    end

endmodule