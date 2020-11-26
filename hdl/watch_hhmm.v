//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: Top level of the desing
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

module watch_hhmm (
    input wire clk_i, //32.768 KHz
    input wire rstn_i, // active low
//    input wire bt0, //TODO
//    input wire bt1, //TODO
    output wire [6:0] segment_hxxx,
    output wire [6:0] segment_xhxx,
    output wire [6:0] segment_xxmx,
    output wire [6:0] segment_xxxm
);

wire clk1s_int;//1 second
wire clk1m_int;//1 minute
wire clk10m_int;//10 minutes
wire clk1h_int;//1 h

// Clock divider
crystal2hz inst_div32768 (
    .rstn_i(rstn_i), 
    .clk_i(clk_i), 
    .clk_o(clk1s_int)
);

count60s inst_div60(
    .rstn_i(rstn_i),
    .clk_i(clk1s_int), 
    .clk60s_o(clk1m_int) 
);
//Hardcoded inital value for display counters
    //TODO: add state machine to configure this through buttons
wire [3:0] cfg_xxxm;
wire [2:0] cfg_xxmx;
wire [4:0] cfg_hhxx;
assign cfg_xxxm = 4'b0;
assign cfg_xxmx = 3'b0;
assign cfg_hhxx = 5'b0;

// Counters for the displays and clock dividers
   // Signals from counters to segment decoders 
wire [3:0] val_hxxx;
wire [3:0] val_xhxx;
wire [3:0] val_xxmx;
wire [3:0] val_xxxm;

count10m inst_count10m (
    .rstn_i(rstn_i),
    .clk1m_i(clk1m_int), 
    .clk10m_o(clk10m_int),
    .ival_i(cfg_xxxm),
    .segment_o(val_xxxm)
);

count60m inst_count60m (
    .rstn_i(rstn_i),
    .clk10m_i(clk10m_int),
    .clk60m_o(clk1h_int),
    .ival_i(cfg_xxmx),
    .segment_o(val_xxmx)
);

count24h inst_count24h (
    .rstn_i(rstn_i),
    .clk60m_i(clk1h_int),
    .ival_i(cfg_hhxx),
    .segment0_o(val_xhxx), 
    .segment1_o(val_hxxx) 
);


// -- Drivers for 7-segment displays
segment7 inst_driverhxxx(
    .val(val_hxxx),
    .segments(segment_hxxx)
);

segment7 inst_driverxhxx(
    .val(val_xhxx),
    .segments(segment_xhxx)
);

segment7 inst_driverxxmx(
    .val(val_xxmx),
    .segments(segment_xxmx)
);

segment7 inst_driverxxxm(
    .val(val_xxxm),
    .segments(segment_xxxm)
);


endmodule


