A Xilinx Spartand 3A FPGA connected to a Nintendo DS Phat console is programmed so that it captures the video output of the console and scales it up 4 fold to drive two large 640x480 LCD panels ( NEC NL64448AC33-29 )

The Pluto IIx from http://www.knjn.com/FPGA-RS232.html was used as the controller since it allows programming through an USB to UART adapter such as an FTDI FT232 instead of via JTAG adapter.
Two external power supplies 12V and 5V provide power to the FPGA and LCD back lights and also power the charge input on the NDS.

The original lower screen on the NDS is retained together with it's touch screen for menu navigation and selection.