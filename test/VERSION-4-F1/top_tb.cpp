#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

#define MAX_SIM_CYC 1000000

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

    //init vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("RV32I CACHE");
    vbdSetMode(1);

    //init simulation inputs
    top->clk = 1;
    top->rst = 1;

    // uncomment this section to run F1
    for (i=0; i<MAX_SIM_CYC; i++) {
        //dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++) {
            tfp->dump(2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }

        top -> rst = i>2 ? 0 : 1;

        // F1 program output
        top->trigger = vbdFlag();
        vbdBar(top->a0 & 0xff);
        vbdCycle(i);

        //end vbuddy
        if (Verilated::gotFinish()) exit(0);
    }

    /* // uncomment this section to run reference program
    for (i=0; i<MAX_SIM_CYC; i++) {
        //dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++) {
            tfp->dump(2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }

        top -> rst = i>2 ? 0 : 1;

        // reference program output
        if (i > 900000) {
            vbdPlot(int (top->a0), 0, 255);
            vbdCycle(i);
        }
        
        //end vbuddy
        if (Verilated::gotFinish()) exit(0);
    } */

    vbdClose();
    tfp->close();
    exit(0);
}