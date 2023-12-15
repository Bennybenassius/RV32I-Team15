#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "iostream"
#include<unistd.h>

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

    for (i=0; i<100000; i++) {
        //dump variables into VCD file and toggle clock
        for(clk=0; clk<2; clk++) {
            tfp->dump(2*i+clk);
            top->clk = !top->clk;
            top->eval();
        }

        top -> rst = i>2 ? 0 : 1;
        //Send values of a0 to vBuddy. Toggle between the 16 bits output

        // vbdHex(1, top->a0 & 0xF); //7-segment display
        // vbdHex(2, (top->a0 >> 4) & 0xF);
        // vbdHex(3, (top->a0 >> 8) & 0xF);
        // vbdHex(4, (top->a0 >> 12) & 0xF);

        // F1 program output
        top->trigger = 1;

        std::cout << top->a0 << ", "<< i  << std::endl;
        if ( (top->a0) > 200){
            sleep(1);
        }
        /* // reference program output
        if (i > 790000) {
            vbdPlot(int (top->a0), 0, 255);
            vbdCycle(i);
        } */


        //end vbuddy
        if (Verilated::gotFinish()) exit(0);
    }
    tfp->close();
    exit(0);
}

/*
init: 1293


*/