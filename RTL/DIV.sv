//------------------------------------------------------------------------------
//
//Module Name:					DIV.v
//Department:					Xidian University
//Function Description:	        整数除法器
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana	Verdvana	Verdvana		  			2020-01-03
//
//-----------------------------------------------------------------------------------
//
//Version	Modified History
//V1.0		
//
//-----------------------------------------------------------------------------------


module DIV #(
    DATA_WIDTH  = 8                     //数据位宽
)(
    input  [DATA_WIDTH-1:0] numer,      //被除数
    input  [DATA_WIDTH-1:0] denom,      //除数

    output [DATA_WIDTH-1:0] quotient,   //商
    output [DATA_WIDTH-1:0] remain      //余数
);

    reg [DATA_WIDTH*2-1:0] numer_r;
    reg [DATA_WIDTH*2-1:0] denom_r;

    reg quotient_e [DATA_WIDTH];

    always_comb begin
        numer_r = {{DATA_WIDTH{1'b0}},numer};   //左边补齐0
        denom_r = denom << DATA_WIDTH;          //右边补齐0
    end

    reg [DATA_WIDTH*2-1:0] numer_e [DATA_WIDTH+1];
    reg [DATA_WIDTH*2-1:0] denom_e [DATA_WIDTH+1];

    assign numer_e[0] = numer_r;
    assign denom_e[0] = denom_r >> 1;

    generate
    genvar i;
    for(i=0;i<DATA_WIDTH;i++)
        begin:shift
            always_comb begin
                if( numer_e[i] >= denom_e[i])begin
                    quotient_e[DATA_WIDTH-1-i] = 1'b1;
                    numer_e[i+1] =  numer_e[i]-denom_e[i];
                    denom_e[i+1] = denom_e[i] >> 1;
                end
                else begin
                    quotient_e[DATA_WIDTH-1-i] = 1'b0;
                    numer_e[i+1] =numer_e[i];
                    denom_e[i+1] = denom_e[i] >> 1;
                end

            end
				
				assign quotient[i] = quotient_e[i]; //得出商
        end
    endgenerate

    assign remain = numer_e[DATA_WIDTH];    //取余数


endmodule