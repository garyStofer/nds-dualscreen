/*
Verilog code for Nintendo DS to external Dual LCD display adapter using Xilinx Spartan 3A device from
http://www.knjn.com/FPGA-RS232.html

This file is the only verilog file used in the project.
Device pin configuration is defined in file contraints.ucf
This project is opened and built with Xilinx ISE webpack edition(P.28xd)
The resulting programming file main2.bit is used by the program FPGAconfig provided by KNJN to program 
the FPGA and its associated boot PROM. 

License: GNU GPL

Overview: 

*/


module main2(
    input clk,		// The clock input to the DCM/DLL --  25Mhz from Oscillator
	 input nds_pix_clk,
	 input nds_hsync,
	 input nds_vsync,
	 input [17:0] nds_data,
	 inout ext,
	 inout ext2,
    output hsync_out,	// The horizontal Sync signal for the output displays 
	 output vsync_out,	// The vertical Sync signal for the output displays
	 output reg DE,		// The Data Enable for the output displays
	 output reg clk_A,	// The pixelclock to the output display, 27Mhz from the DCM/DLL
	 output clk_B,	 		// Same, but invetred for second display
	 output reg [17:0] nec_data , // Color Red data bits 5:0, green 11:6, blue 17:12
	 output MyTest
 	);
	
	reg [17:0] line_buffer_A  [264:0];
	reg [17:0] line_buffer_a2 [264:0];
	reg [17:0] line_buffer_B  [264:0];
	reg [17:0] line_buffer_b2 [264:0];

	
	reg [8:0] nds_pix_cnt;
	reg nds_line_cnt;
	reg [8:0] x;
	reg h;
	reg togg_l;

 
 
	wire p;				// this is the 54 Mhz clock  output from the DCM_DLL that gets divided by 2
	reg NEC_pix_clk;	//  used in this module to count pixels and enable data onto te color busses
	reg [10:0] pix_cnt_out;	// A counter to keep track of the current pixel position on a line
	reg h_sync_out;
	reg v_sync_out;
	wire locked;
		
	reg [9:0] line_cnt_out;// A counter to keep track of the current line of the display
	

	assign MyTest = 0;
  	
// Instantiate the DCM/DLL module as defined in the .xaw wizzard output file 
	DCM_DLL PixClockDll (.CLKIN_IN(clk),.CLKFX_OUT(p),.LOCKED_OUT(locked)
	 // ,.CLKFX180_OUT(pix_clk) 
	 //,.CLKIN_IBUFG_OUT(p_clk) 
    );	  
      
	// This is for simulation only -- no bearing on synthesis 	
	initial begin
	nds_pix_cnt = 0;
	nds_line_cnt = 0;
	pix_cnt_out = 0; 
	line_cnt_out = 0;
	togg_l =0;
	DE = 0;
	//pix_clk_out = 1;
	//clk_A =0;
	//#100;	// Wait 100 ns for global reset to finish
 	end
	
	// increment input line counter
	always @ (negedge nds_hsync ) begin
		if (!nds_vsync)
			nds_line_cnt <= 0;
		else
			nds_line_cnt <= nds_line_cnt + 1;  // a single bit since we only need to know even or odd lines
	end
		
	// sync and increment input pixel counter	
	always @ (posedge nds_pix_clk ) begin
		if ( !nds_hsync && h) 
		begin
			nds_pix_cnt <= 0;
			h <= 0;
		end
		else begin
			if(nds_line_cnt)
				line_buffer_A[nds_pix_cnt] <= nds_data;	//index 5 is the first pixel
			else
				line_buffer_a2[nds_pix_cnt] <= nds_data;
				
			nds_pix_cnt <= nds_pix_cnt + 1;
		end
		if(nds_hsync && !h) begin
			h <= 1;
		end		
	end
	
	always @ (negedge nds_pix_clk ) begin

		if(nds_line_cnt)
			line_buffer_B[nds_pix_cnt] <= nds_data;
		else
			line_buffer_b2[nds_pix_cnt] <= nds_data;
	end	

// ------------------------------------ output stuff --------------------------------
	// in order to have a 90 degree shifted clock relative to te data we need to run the DLL
	// at twice the clock F and create cloks based on the positive and negative edge
	always @ (posedge p ) begin// LCD clocks-in on neg edge of CLK, since we service two displays 
		if ( !locked)
			clk_A <= 0;
		else
			clk_A <= !clk_A; // Clock A is 27Mhz now
	end

	// with one databus and control lines serving two displays we have to invert the phase of the clock for the second screen
	assign clk_B = !clk_A;		
		
	always @ (negedge p ) begin		// this creates the 90 degree out of phase internal  27mhz clock that governs the databus and the sync control lines
		if (clk_A )
			NEC_pix_clk <= 0;
		else
			NEC_pix_clk <= !NEC_pix_clk;	
	end
	
	BUFG BUFG_pix_clk_out (
      .O(buf_NEC_pix_clk), // Clock buffer output
      .I(NEC_pix_clk)      // Clock buffer input
   );
	
	BUFG BUFG_h_sync (		// BUFG: Global Clock Buffer (source by an internal signal)
      .O(buf_h_sync_out),  // Clock buffer output
      .I(h_sync_out)      	// Clock buffer input
   );
	
	
	// Create the NEC V-Sync and sync the frame to the NDS frame			
	// Count the horizontal lines and create the vertical sync
	always @ (negedge buf_h_sync_out or negedge nds_vsync )	begin	
		 if ( ! nds_vsync ) begin	// This is the frame sync from the NDS syncing the frame of the output
		 		line_cnt_out <=0;
		 end 
		 else  begin
			if (line_cnt_out > 535 ) 			// 525 is the raw vertical line count of the NEC display. This should never happen, it's just in case we miss the nds vsync
				line_cnt_out <=0;
			else
				line_cnt_out <= line_cnt_out +1; 
				
			if (line_cnt_out < 1 )// create the vertical sync for the first vertical line. 
				v_sync_out <= 0;
			else
				v_sync_out <=1;
		end	
		
	end

	
	assign vsync_out = v_sync_out;	// Connect to output wire
  
	// Create the NEC H-Sync and syncronize it to the NDS H-Sync
	// counting the line pixels and creating the horizontal sync signal during the initial 96 pixelc counts
	always @(posedge buf_NEC_pix_clk  ) begin  // buf_NEC_pix_clk is 27mhz

		if (!nds_hsync && !togg_l) begin
			pix_cnt_out <= 0;
			togg_l <=1;
		end


		if (pix_cnt_out > 799 && togg_l )begin		// 800 is the raw number of pixels for the NEC display 
			pix_cnt_out <= 0;
			togg_l <=0;
		end else
			pix_cnt_out <= pix_cnt_out + 1;
		
		
		if (pix_cnt_out < 96)		// create the horizontal sync pulse
			h_sync_out <= 0;
		else
			h_sync_out <= 1; 
		
		// Create the Data Enable in the display window of the NEC display, this is 640x480 visible pixels 	
		if ( (line_cnt_out> 6 && line_cnt_out<487) && (pix_cnt_out>143 && pix_cnt_out <785) )
			DE <= 1;
		else
			DE <= 0;
	end
	
	//assign ext2 = nds_hsync;
	assign ext2 = togg_l;
	//assign ext2 = buf_NEC_pix_clk;
	assign hsync_out =h_sync_out;
	assign ext = line_cnt_out[0];


	// To simplify scaling up of the nintendo pixel data (256x192) we schrink the NEC display window 
	// to 512x384 by adding a mask around the area where the game display is going to be.
	// The nintendo pixel data then can be scaled up 2x in both directions.
	always @ ( negedge p ) 	// p is at 54 Mhz
	begin	
		x <= pix_cnt_out[9:1] - (104-4);	// this is pic cnt divided by 2, the -4 is the nds porch
	
		if (NEC_pix_clk)  //data for display A
		begin	
			if ((line_cnt_out < 10|| line_cnt_out > 393) || (pix_cnt_out < 209 || pix_cnt_out > 720))
				nec_data <= 18'h20820; // gray frame 
			else 	begin
				if (line_cnt_out[1])
					nec_data <= line_buffer_A[x];
				else
					nec_data <= line_buffer_a2[x]; 
			end	
		end	
		else 
		begin	// for display B
			if ((line_cnt_out < 10 || line_cnt_out > 393) || (pix_cnt_out < 210 || pix_cnt_out > 721))
					nec_data <= 18'h20820;	// gray frame 
			else
			begin
				if (line_cnt_out[1])
					nec_data <= line_buffer_B[x];
				else
					nec_data <= line_buffer_b2[x]; 
			end	
			
		end

	end // always

endmodule 