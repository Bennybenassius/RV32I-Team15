rm -rf obj_dir
rm -f top.vcd

verilator -Wall --cc --trace top.sv --exe no_v_top_tb.cpp

make -j -C obj_dir/ -f Vtop.mk Vtop
obj_dir/Vtop