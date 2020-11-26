//-----------------------------------------------------
// ProjectName: ASIC watch 
// Description: 0 - 23 counter. 1 h increments
//              It interfaces with 7-segment driver hh:xx
//              Since we have to account for hx:xx to update xh:xx both are
//              in the same module
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

module count24h (
    input wire rstn_i, // active low
    input wire clk60m_i, // 1/3600 Hz 
    input wire [4:0] ival_i, // Initial value
    output reg [3:0] segment0_o, // fully encoded, one-hot decoder needed
                                    //xh:xx
    output reg [3:0] segment1_o // fully encoded, one-hot decoder needed
                                    //hx:xx
);

reg [4:0] count_int;
always @(posedge clk60m_i, negedge rstn_i) begin : count_5bit
    if (!rstn_i) begin
        count_int <= ival_i;
    end else begin
        if (count_int < 23) begin 
            count_int <= count_int+1; 
        end else begin
            count_int <= 0; 
        end
    end
end


// -- Get xhxx integer value for 7-segment driver
//get only meaningful bits
wire [4:0] xhxx_count;
assign xhxx_count = count_int[4:0];

//A complete LUT would do the same job
always @(*) begin : xhxx_gen
    // for counter values 0 - 9: Counter value match segment output
    if (xhxx_count <= 5'h9) begin
        segment0_o = xhxx_count;
    end else begin
    // for counter values 10 - 24: Bit 0 matches the one in  0-9 range
        //  I don't see a patern for the others. I let tools OPT 
        segment0_o[0] = xhxx_count[0];
        // lookup for the remaining fields
        case (count_int[3:1])
            //10 & 11
            3'b101 : segment0_o[3:1] = 3'b000;
            //12 & 13
            3'b110 : segment0_o[3:1] = 3'b001 ;
            //14 & 15
            3'b111 : segment0_o[3:1] = 3'b010 ;
            //16 & 17
            3'b000 : segment0_o[3:1] = 3'b011 ;
            //18 & 19
            3'b001 : segment0_o[3:1] = 3'b100 ;
            //20 & 21
            3'b010 : segment0_o[3:1] = 3'b000 ;
            //22 & 23
            3'b011 : segment0_o[3:1] = 3'b001 ;
            //24
            3'b100 : segment0_o[3:1] = 3'b010 ;
        endcase
    end
end
//

// -- Get hxxx integer value for 7-segment driver
// Fill unused bits

always @(*) begin : hxxx_gen
    segment1_o[3:2] = 2'b0;
    if (count_int < 10  ) begin
        segment1_o[1:0] = 2'b00;
    end else begin
        if (count_int > 19) begin
            segment1_o[1:0] = 2'b10;
        end else begin
            segment1_o[1:0] = 2'b01;
        end
    end
end

endmodule




