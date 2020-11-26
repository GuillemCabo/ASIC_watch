/* -----------------------------------------------
* Project Name   : ASIC watch
* Author(s)      : Guillem cabo 
* Email(s)       : Cabo.guillem@gmail.com 
*/
//-----------------------------------------------------

// Function   : Simple directed tests for design
// Notes: Tested with Questasim10.7

`timescale 1 ps / 1 ps
`default_nettype none
`include "colors.vh"
//***Headers***
//***Test bench***
module tb_watch_hhmm();

//***TB parameters***
parameter CLK_PERIOD      = 30517578;
parameter CLK_HALF_PERIOD = CLK_PERIOD / 2;

//*** Drive signals***
reg clk_i; //32.768 KHz
reg rstn_i; // active low

//*** Read signals***
wire [6:0] segment_hxxx;
wire [6:0] segment_xhxx;
wire [6:0] segment_xxmx;
wire [6:0] segment_xxxm;

//store name of test for easier debug of waveform
reg[64*8:0] tb_test_name;
reg tb_fail = 0;

//***Module***
    watch_hhmm dut_watch_hhmm (
	    .* //name connect
    );

//***clk_gen***
    initial clk_i = 1;
    always #CLK_HALF_PERIOD clk_i = !clk_i;

//***task automatic reset_dut***
    task automatic reset_dut;
        begin
            tb_test_name="reset_dut";
            $display("*** Toggle reset.");
            rstn_i <= 1'b0; 
            #CLK_PERIOD;
            rstn_i <= 1'b1;
            #CLK_PERIOD;
            $display("Done");
        end
    endtask 

//***task automatic init_sim***
//Initialize TB registers to a known state. 
task automatic init_sim;
        begin
            $display("*** init sim.");
            rstn_i<='{default:0};
            $display("Done");
        end
    endtask

//***task automatic init_dump***
    task automatic init_dump;
        begin
            $dumpfile("MCCU_test.vcd");
            $dumpvars(0,dut_watch_hhmm);
        end
    endtask 

//Run n seconds
task automatic srun(input longint seconds);
        begin
            integer i;
            longint a = seconds*32768;
            $display("*** srun %0d.",a);
            for(i=0;i<a;i++) begin
            #CLK_PERIOD;
            end
            $display("Done");
        end
    endtask

//***task automatic test_sim***
    task automatic test_sim;
        begin
            int unsigned temp=1;
            $display("*** test_sim.");
            tb_test_name="test_sim";
            //**test***
            srun(90000);
            //check results
            if(temp!=1) begin
                tb_fail = 1; 
                $error("FAIL test_sim");
                `START_RED_PRINT
                $display("FAIL");
                `END_COLOR_PRINT
            end
            $display("Done");
        end
    endtask 

//***init_sim***
    initial begin
        init_sim();
        init_dump();
        reset_dut();
        test_sim();
        $finish;
    end

endmodule
`default_nettype wire
