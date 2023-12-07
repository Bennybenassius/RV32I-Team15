#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

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

    //init vbuddy
    if (vbdOpen()!=1) return(-1);
    vbdHeader("RV32I CPU");
    vbdSetMode(1);

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
        //Send values of a0 to vBuddy. Toggle between the 16 bits output

        // vbdHex(1, top->a0 & 0xF); //7-segment display
        // vbdHex(2, (top->a0 >> 4) & 0xF);
        // vbdHex(3, (top->a0 >> 8) & 0xF);
        // vbdHex(4, (top->a0 >> 12) & 0xF);
        top->trigger = vbdFlag();
        vbdBar(top->a0);
        vbdCycle(i);

        //end vbuddy
        if (Verilated::gotFinish()) exit(0);
    }

    vbdClose();
    tfp->close();
    exit(0);
}