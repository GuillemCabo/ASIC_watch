//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: Maps integers to 7 segment output.
//              Module is fully combinational
// Coder      : G.Cabo
// References :
//-----------------------------------------------------
`default_nettype none
`timescale 1 ns / 1 ps

`ifndef SYNT
    `ifdef FORMAL 
        `define ASSERTIONS
    `endif
`endif

module segment7 (
    input wire [3:0] val,
    output reg [6:0] segments
);

always @(*) begin : segment_driver
   case(val)
        //0
        4'h0: segments =7'b1110111;
        //1
        4'h1 : segments =7'b1000100;
        //2
        4'h2 : segments =7'b0111110;
        //3
        4'h3 : segments =7'b1101110;
        //4
        4'h4 : segments =7'b1001101;
        //5
        4'h5 : segments =7'b1101011;
        //6
        4'h6 : segments =7'b1111011;
        //7
        4'h7 : segments =7'b1001110;
        //8
        4'h8 : segments =7'b1111111;
        //9
        4'h9 : segments =7'b1001111;
        //G
        4'ha : segments =7'b1111110;
        //C
        4'hb : segments =7'b1100110;
        //P
        4'hc : segments =7'b0011111;
        //default
        default:segments =7'b0001000;
    endcase
end
endmodule

