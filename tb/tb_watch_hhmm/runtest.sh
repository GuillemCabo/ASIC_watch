#$1
TOP=../..
      
vlib watch_hhmm
vmap work $PWD/watch_hhmm
vlog +acc=rn +incdir+$TOP/hdl/ $TOP/hdl/watch_hhmm.v $TOP/submodules/*.v  tb_watch_hhmm.sv ./colors.vh
vmake watch_hhmm/ > Makefile

if [ -z "$1" ]
then
      vsim work.tb_watch_hhmm -do "view wave -new" -do "do wave.do" -do "run -all"
else
      vsim work.tb_watch_hhmm $1 -do "do save_wave.do; exit"
fi
