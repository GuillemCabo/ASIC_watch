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
reg sysclk_i; //32.768 KHz
reg sclk_i; //32.768 KHz
reg rstn_i; // active low
reg smode_i; //Safemode
reg dvalid_i; // Wisbone data valid and correct adress
reg [11:0] cfg_i; //wishbone data

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
    initial sysclk_i = 1;
    always #CLK_HALF_PERIOD sysclk_i = !sysclk_i;
    initial sclk_i = 1;
    always #CLK_HALF_PERIOD sclk_i = !sclk_i;

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
            smode_i<='{default:0};
            dvalid_i <='{default:0};
            cfg_i <='{default:0};
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

//Run n seconds - Safe mode active and random valid input data 
task automatic safe_srun(input longint seconds);
        begin
            integer i;
            longint a = seconds*32768;
            smode_i<=1;
            $display("*** safe srun %0d.",a);
            tb_test_name="safe_srun";
            for(i=0;i<a;i++) begin
            #CLK_PERIOD;
            dvalid_i <= $random();
            cfg_i <= $random(); 
            end
            $display("Done");
        end
    endtask
//Run n seconds - Without safe mode and random valid input data
task automatic rand_srun(input longint seconds);
        begin
            integer i;
            longint a = seconds*32768;
            smode_i<=0;
            $display("*** random srun %0d.",a);
            tb_test_name="rand_srun";
            for(i=0;i<a;i++) begin
            #CLK_PERIOD;
            dvalid_i <= $random();
            cfg_i <= $random(); 
            end
            $display("Done");
        end
    endtask

//Run n seconds - Safe mode active, force 60s clock
reg tb_fclock_i = 1;
always #CLK_HALF_PERIOD tb_fclock_i = !tb_fclock_i;

//Force internal signals when re aare in force_srun tests mode
    //This speeds up symulation bypassing the crystal and 60s dividers
always @ (posedge sysclk_i) begin
if (tb_test_name=="force_srun") begin
        force dut_watch_hhmm.inst_div60.clk60s_o = tb_fclock_i;
    end else begin
        release dut_watch_hhmm.inst_div60.clk60s_o;
    end
end;

task automatic force_srun(input longint seconds);
        begin
            integer i;
            longint a = seconds*32768;
            $display("*** force srun %0d.",a);
            tb_test_name="force_srun";
            smode_i<=1;
            //Issue a reset to clear values
            #CLK_PERIOD;
            rstn_i <=0;
            #CLK_PERIOD;
            rstn_i <=1;
            #CLK_PERIOD;
            rstn_i <=0;
            #CLK_PERIOD;
            rstn_i <=1;
            #CLK_PERIOD;
            
            
            for(i=0;i<a;i++) begin
            #CLK_PERIOD;
            dvalid_i <= $random();
            cfg_i <= $random(); 
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
            reset_dut();
            safe_srun(3);
            reset_dut();
            rand_srun(3);
            reset_dut();
            force_srun(3);
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
