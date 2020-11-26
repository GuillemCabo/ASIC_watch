//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: 0 - 5 counter. 1 minute increments
// //           It interfaces with 7-segment driver xx:xm
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

module count10m (
    input wire rstn_i, // active low
    input wire clk1m_i, // 1/60 Hz 
    output reg clk10m_o, // 1/600 Hz registered
    input wire [3:0] ival_i, // Initial value
    output wire [3:0] segment_o // fully encoded, one-hot decoder needed
);

reg [3:0] count_int;
always @(posedge clk1m_i, negedge rstn_i) begin : count_4bit
            if (!rstn_i) begin
                count_int <= ival_i;
            end else begin
                if (count_int < 9) begin 
                    count_int <= count_int+1; 
                end else begin
                    count_int <= 0; 
                end
            end
end

assign segment_o = count_int;

//xx:mx counter clock
always @(posedge clk1m_i, negedge rstn_i) begin: clk_xhxx
            if (!rstn_i) begin
                clk10m_o <= 1;
            end else begin
                if (count_int==4 || count_int==9) begin 
                    clk10m_o <= ~clk10m_o;
                end else begin
                    clk10m_o <= clk10m_o;
                end
            end
end


endmodule




