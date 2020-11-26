//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: 0 - 59 counter. 1 second increments
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

module count60s (
    input wire rstn_i, // active low
    input wire clk_i, //1 Hz 
    output reg clk60s_o // 1/60 Hz registered
);

//free running counter
reg [5:0] count_int;
always @(posedge clk_i, negedge rstn_i) begin : count_6bit
            if (!rstn_i) begin
                count_int <= 0;
            end else begin
                if (count_int < 59) begin 
                    count_int <= count_int+1; 
                end else begin
                    count_int <= 0; 
                end
            end
end;

always @(posedge clk_i, negedge rstn_i) begin: clk_xxxm
            if (!rstn_i) begin
                clk60s_o <= 0;
            end else begin
                if (count_int == 59 ) begin 
                    clk60s_o <= ~clk60s_o;
                end else begin
                    clk60s_o <= clk60s_o;
                end
            end
end


endmodule




