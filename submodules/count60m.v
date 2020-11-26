//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: 0 - 5 counter. 10 min increments
//              It interfaces with 7-segment driver xx:mx
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

module count60m (
    input wire rstn_i, // active low
    input wire clk10m_i, // 1/600 Hz 
    output reg clk60m_o, // 1/3600 Hz registered
    input wire [2:0] ival_i, // Initial value
    output wire [3:0] segment_o // fully encoded, one-hot decoder needed
);

reg [2:0] count_int;
always @(posedge clk10m_i, negedge rstn_i) begin : count_3bit
            if (!rstn_i) begin
                count_int <= ival_i;
            end else begin
                if (count_int < 6) begin 
                    count_int <= count_int+1; 
                end else begin
                    count_int <= 0; 
                end
            end
end;

assign segment_o = {1'b0,count_int};// since max value 6. 4th bit is unused

//xx:mx counter clock
always @(posedge clk10m_i, negedge rstn_i) begin: clk_xxmx
            if (!rstn_i) begin
                clk60m_o <= 0;
            end else begin
                if (count_int == 6 ) begin 
                    clk60m_o <= ~clk60m_o;
                end else begin
                    clk60m_o <= clk60m_o;
                end
            end
end


endmodule




