`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:11:02 08/20/2014
// Design Name:   main2
// Module Name:   C:/Users/me/Documents/Xlinix/count/testFix.v
// Project Name:  count
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main2
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testFix;

	// Inputs
	reg clk;

	// Outputs
	wire hsync;
	wire vsync;
	wire de;
	wire p_clk;
	wire [5:0] red ;
	wire [5:0] blue;
	wire [5:0] green;

	// Instantiate the Unit Under Test (UUT)
	main2 uut (
		.clk(clk), 
		.hsync(hsync), 
		.vsync(vsync), 
		.de(de), 
		.p_clk(p_clk), 
		.red(red), 
		.blue(blue), 
		.green(green)
	);

	initial begin
		// Initialize Inputs
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
		forever begin
      clk = #20 1; 
		clk = #20 0;
		end
		
		// Add stimulus here

	end
      
endmodule

