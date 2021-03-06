////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2012 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /    Vendor: Xilinx 
// \   \   \/     Version : 14.2
//  \   \         Application : xaw2verilog
//  /   /         Filename : DCM_DLL.v
// /___/   /\     Timestamp : 08/01/2014 17:19:18
// \   \  /  \ 
//  \___\/\___\ 
//
//Command: xaw2verilog -st C:\Users\me\Documents\Xlinix\count\ipcore_dir\.\DCM_DLL.xaw C:\Users\me\Documents\Xlinix\count\ipcore_dir\.\DCM_DLL
//Design Name: DCM_DLL
//Device: xc3s50a-4vq100
//
// Module DCM_DLL
// Generated by Xilinx Architecture Wizard
// Written for synthesis tool: XST
// Period Jitter (unit interval) for block DCM_SP_INST = 0.05 UI
// Period Jitter (Peak-to-Peak) for block DCM_SP_INST = 2.14 ns
`timescale 1ns / 1ps

module DCM_DLL(CLKIN_IN, 
               CLKFX_OUT, 
               CLKIN_IBUFG_OUT);

    input CLKIN_IN;
   output CLKFX_OUT;
   output CLKIN_IBUFG_OUT;
   
   wire CLKFX_BUF;
   wire CLKIN_IBUFG;
   wire GND_BIT;
   
   assign GND_BIT = 0;
   assign CLKIN_IBUFG_OUT = CLKIN_IBUFG;
   BUFG  CLKFX_BUFG_INST (.I(CLKFX_BUF), 
                         .O(CLKFX_OUT));
   IBUFG  CLKIN_IBUFG_INST (.I(CLKIN_IN), 
                           .O(CLKIN_IBUFG));
   DCM_SP #( .CLK_FEEDBACK("NONE"), .CLKDV_DIVIDE(2.0), .CLKFX_DIVIDE(25), 
         .CLKFX_MULTIPLY(24), .CLKIN_DIVIDE_BY_2("FALSE"), 
         .CLKIN_PERIOD(40.000), .CLKOUT_PHASE_SHIFT("NONE"), 
         .DESKEW_ADJUST("SYSTEM_SYNCHRONOUS"), .DFS_FREQUENCY_MODE("LOW"), 
         .DLL_FREQUENCY_MODE("LOW"), .DUTY_CYCLE_CORRECTION("TRUE"), 
         .FACTORY_JF(16'hC080), .PHASE_SHIFT(0), .STARTUP_WAIT("FALSE") ) 
         DCM_SP_INST (.CLKFB(GND_BIT), 
                       .CLKIN(CLKIN_IBUFG), 
                       .DSSEN(GND_BIT), 
                       .PSCLK(GND_BIT), 
                       .PSEN(GND_BIT), 
                       .PSINCDEC(GND_BIT), 
                       .RST(GND_BIT), 
                       .CLKDV(), 
                       .CLKFX(CLKFX_BUF), 
                       .CLKFX180(), 
                       .CLK0(), 
                       .CLK2X(), 
                       .CLK2X180(), 
                       .CLK90(), 
                       .CLK180(), 
                       .CLK270(), 
                       .LOCKED(), 
                       .PSDONE(), 
                       .STATUS());
endmodule
