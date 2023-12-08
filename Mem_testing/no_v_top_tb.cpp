#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env) {
    int i;
    int clk;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop* top = new Vtop;
    VerilatedVcdC* tfp = new VerilatedVcdC;
    //init trace dump
    Verilated::traceEverOn(true);
    top->trace (tfp,99);
    tfp->open("top.vcd");

    //init simulation inputs
    top->clk = 1;
    top->rst = 1;

    for (i=0; i<1000; i++) {
        //dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++) {
            tfp->dump(2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }

        top -> rst = clk>2 ? 0 : 1;

        if (Verilated::gotFinish()) exit(0);
    }

    tfp->close();
    exit(0);
}