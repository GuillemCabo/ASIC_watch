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
    //input wire clk_system_i, //  10 MHz
    input wire sysclk_i, // 32.768 KHz shared with SoC
    input wire smode_i, // safe mode
    input wire sclk_i,// safe clock GPIO 32.768 KHz
    input wire rstn_i, // active low
    input wire dvalid_i, // Data from wishbone is valid
    input wire [11:0] cfg_i, // initial values for counters
    output wire [6:0] segment_hxxx,
    output wire [6:0] segment_xhxx,
    output wire [6:0] segment_xxmx,
    output wire [6:0] segment_xxxm
);

//Clock selector
wire clk_crystal_i;
assign clk_crystal_i = (smode_i)? sclk_i : sysclk_i;

//Set initial value of clock
wire [3:0] cfg_xxxm;
wire [2:0] cfg_xxmx;
wire [4:0] cfg_hhxx;
reg [11:0] cfg_int;

//If we are in safe mdoe we ignore the wishbone configuration
assign cfg_xxxm = (smode_i)? 0 : cfg_int[3:0];
assign cfg_xxmx = (smode_i)? 0 : cfg_int[6:4];
assign cfg_hhxx = (smode_i)? 0 : cfg_int[11:7];

reg rstn_int;
reg past_smode;

// Keep track of smode changes
always @(posedge clk_crystal_i, negedge rstn_i) begin : gen_past_smode
    if (!rstn_i) begin
        past_smode <= 0; 
    end else begin
        past_smode <= smode_i; 
    end
end

// Issue a reset pulse if Safemode is activated, or a read is performed

always @(posedge clk_crystal_i, negedge rstn_i) begin  
    if (!rstn_i) begin
        rstn_int <= 0; 
    end else begin
        if ((dvalid_i & (!smode_i)) | (past_smode != smode_i)) begin
            rstn_int <= 0; 
        end else begin
            rstn_int <= 1; 
        end
    end
end

//Update configuration after reset or valid wishbone write
always @(posedge clk_crystal_i, negedge rstn_i) begin : gen_rstn_int
    if (!rstn_i) begin
        cfg_int <= 0;
    end else begin
        if (dvalid_i & (!smode_i)) begin
            cfg_int <= cfg_i; 
        end else begin
            cfg_int <= cfg_int; 
        end
    end
end

// Clock dividers

wire clk2s_int;//1 second
wire clk1m_int;//1 minute
wire clk10m_int;//10 minutes
wire clk1h_int;//1 h

crystal2hz inst_div32768 (
    .rstn_i(rstn_int),
    .clk_i(clk_crystal_i),
    .clk_o(clk2s_int)
);

count60s inst_div60(
    .rstn_i(rstn_int),
    .clk_i(clk2s_int),
    .clk60s_o(clk1m_int)
);
// Counters for the displays and clock dividers
   // Signals from counters to segment decoders
wire [3:0] val_hxxx;
wire [3:0] val_xhxx;
wire [3:0] val_xxmx;
wire [3:0] val_xxxm;


count10m inst_count10m (
    .rstn_i(rstn_int),
    .clk1m_i(clk1m_int),
    .clk10m_o(clk10m_int),
    .ival_i(cfg_xxxm),
    .segment_o(val_xxxm)
);

count60m inst_count60m (
    .rstn_i(rstn_int),
    .clk10m_i(clk10m_int),
    .ival_i(cfg_xxmx),
    .clk60m_o(clk1h_int),
    .segment_o(val_xxmx)
);

count24h inst_count24h (
    .rstn_i(rstn_int),
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
