onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Coral /tb_watch_hhmm/dut_watch_hhmm/inst_div60/rstn_i
add wave -noupdate -color Coral /tb_watch_hhmm/dut_watch_hhmm/inst_div60/clk_i
add wave -noupdate -color Coral /tb_watch_hhmm/dut_watch_hhmm/inst_div60/clk60s_o
add wave -noupdate -color Coral /tb_watch_hhmm/dut_watch_hhmm/inst_div60/count_int
add wave -noupdate -color Orange /tb_watch_hhmm/dut_watch_hhmm/inst_count10m/rstn_i
add wave -noupdate -color Orange /tb_watch_hhmm/dut_watch_hhmm/inst_count10m/clk1m_i
add wave -noupdate -color Orange /tb_watch_hhmm/dut_watch_hhmm/inst_count10m/clk10m_o
add wave -noupdate -color Orange /tb_watch_hhmm/dut_watch_hhmm/inst_count10m/ival_i
add wave -noupdate -color Orange /tb_watch_hhmm/dut_watch_hhmm/inst_count10m/segment_o
add wave -noupdate -color Orange /tb_watch_hhmm/dut_watch_hhmm/inst_count10m/count_int
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/inst_count60m/rstn_i
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/inst_count60m/clk10m_i
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/inst_count60m/clk60m_o
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/inst_count60m/ival_i
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/inst_count60m/segment_o
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/inst_count60m/count_int
add wave -noupdate -color {Medium Spring Green} /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/rstn_i
add wave -noupdate -color {Medium Spring Green} /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/clk60m_i
add wave -noupdate -color {Medium Spring Green} /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/ival_i
add wave -noupdate -color {Medium Spring Green} /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/segment0_o
add wave -noupdate -color {Medium Spring Green} /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/segment1_o
add wave -noupdate -color {Medium Spring Green} -radix unsigned /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/count_int
add wave -noupdate -color {Medium Spring Green} -radix unsigned /tb_watch_hhmm/dut_watch_hhmm/inst_count24h/xhxx_count
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/segment_hxxx
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/segment_xhxx
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/segment_xxmx
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/segment_xxxm
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/val_hxxx
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/val_xhxx
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/val_xxmx
add wave -noupdate /tb_watch_hhmm/dut_watch_hhmm/val_xxxm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5783 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 366
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {7955 ps}
bookmark add wave bookmark0 {{0 ps} {7350005909349600 ps}} 0
