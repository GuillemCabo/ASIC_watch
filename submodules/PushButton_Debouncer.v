module PushButton_Debouncer(
    input wire clk,
    input wire PB,  // "PB" is the glitchy, asynchronous to clk, active low push-button signal

    output wire PB_up   // 1 for one clock cycle when the push-button goes up (i.e. just released)
   // output reg PB_state // 1 as long as the push-button is active (down)
);

reg PB_state=1;
wire PB_down;  // 1 for one clock cycle when the push-button goes down (i.e. just pushed)

// two stage synchronization : 2 FFs
reg PB_sync_0;  always @(posedge clk) PB_sync_0 <= ~PB;  // invert PB to make PB_sync_0 active high
reg PB_sync_1;  always @(posedge clk) PB_sync_1 <= PB_sync_0;

// 7 bits @ 32KHz gives a 4.0 ms window
reg [6:0] PB_cnt=0;

// When the push-button is pushed or released, we increment the counter
// The counter has to be maxed out before we decide that the push-button state has changed
wire PB_idle = (PB_state==PB_sync_1);
wire PB_cnt_max = &PB_cnt;	// true when all bits of PB_cnt are 1's

always @(posedge clk)
if(PB_idle)
    PB_cnt <= 0;  // nothing's going on
else
begin
    PB_cnt <= PB_cnt + 6'd1;  // something's going on, increment the counter
    if(PB_cnt_max) PB_state <= ~PB_state;  // if the counter is maxed out, PB changed!
end

assign PB_down = ~PB_idle & PB_cnt_max & ~PB_state;
assign PB_up   = ~PB_idle & PB_cnt_max &  PB_state;
endmodule