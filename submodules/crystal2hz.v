//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: Clock down  from external crystal to 1Hz
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

module crystal2hz (
    input wire rstn_i, // active low
    input wire clk_i, // 32.768 KHz
    output reg clk_o //1Hz
);

//free running counter
reg [14:0] count_int;
always @(posedge clk_i, negedge rstn_i) begin : count_15bit
            if (!rstn_i) begin
                count_int <= 0;
            end else begin
                count_int <= count_int+1;  
            end
end;

//Clock divider
always @(posedge clk_i, negedge rstn_i) begin: clk_div
            if (!rstn_i) begin
                clk_o <= 0;
            end else begin
                if (&count_int == 1 ) begin // if and reduction is 1
                    clk_o <= ~clk_o;
                end else begin
                    clk_o <= clk_o;
                end
            end
end;


endmodule


