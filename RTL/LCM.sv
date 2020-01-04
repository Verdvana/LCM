//------------------------------------------------------------------------------
//
//Module Name:					LCM.v
//Department:					Xidian University
//Function Description:	        求最大公约数和最小公倍数
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2020-01-04
//
//-----------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		
//
//-----------------------------------------------------------------------------------


`timescale 1ns/1ns

module LCM #(
    parameter   DATA_WIDTH = 8          //数据位宽
)(
    //**********时钟&复位***********//
    input                       clk,    //时钟
    input                       rst_n,  //复位
    //**********控制信号***********//
    input                       en,     //使能
    //**********输入数据***********//
    input  [DATA_WIDTH-1:0]     a,      //第一个数
    input  [DATA_WIDTH-1:0]     b,      //第二个数
    //**********输出数据***********//
    output                      valid,  //输出数据有效信号
    output [DATA_WIDTH*2-1:0]   gcd,    //最大公约数
    output [DATA_WIDTH*2-1:0]   lcm     //最小公倍数
);


    //===================================================
    //使能上升沿检测

    reg en_r1,en_r2;

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            en_r1 <= '0;
            en_r2 <= '0;
        end
        else begin
            en_r1 <= en;
            en_r2 <= en_r1;
        end
    end

    wire enable;

    assign enable = en_r1 && ~en_r2;


    
    //===================================================
    //辗转相除计算最大公约数
    
    reg  [DATA_WIDTH-1:0] numer,denom;
    
    wire [DATA_WIDTH-1:0]quotient,remain;

    DIV#(
        .DATA_WIDTH(DATA_WIDTH)                     //数据位宽
    )u_DIV(
        .numer,      //被除数
        .denom,      //除数

        .quotient,   //商
        .remain      //余数
    );

    reg [DATA_WIDTH*2-1:0]   gcd_r;

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            numer <= '0;
            denom <= '0;   
		end
        else if(valid) begin
            numer <= '0;
            denom <= '0;
        end
        else if(enable) begin
            numer <= a;
            denom <= b;
        end
        else if(remain!='0)begin
            numer <= denom;
            denom <= remain;
        end
        else begin
            gcd_r <= denom;
        end
    end

    assign gcd = (valid)?gcd_r:'0;


    //===================================================
    //产生输出有效信号

    reg valid_r;

    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            valid_r <= '0;
        end
        else if((remain=='0)&&(denom!='0)&&(valid_r=='0)) begin
            valid_r <= '1;
        end
        else begin
            valid_r <= '0;
        end
    end

    assign valid = valid_r;

    //===================================================
    //计算最小公倍数

    wire [DATA_WIDTH*2-1:0]   lcm_r;
    wire [DATA_WIDTH*2-1:0]   product;

    assign product = a*b;
    
    DIV#(
        .DATA_WIDTH(DATA_WIDTH*2)                     //数据位宽
    )ulcm_DIV(
        .numer(product),      //被除数
        .denom(gcd),      //除数

        .quotient(lcm_r),   //商
        .remain()      //余数
    );

    assign lcm = (valid)?lcm_r:'0;
    

endmodule