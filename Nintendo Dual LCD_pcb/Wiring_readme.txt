The pin connections from the Pluto IIx board to the NDS and the two NEC screens can be learned from the pin assignments 
in the constraints.ucf file. 

The Pluto IIx board, its inputs and outputs run at 3.3V regulated down from it's 5V input.
The NEC screens also run on 3.3V, however the regulator on the Pluto board can not supply enough 
power for both NEC screens. A seperate 3.3V regulator has been added to the Pluto board to supply 
the NEC screens. Assorted bypass capacitors where added to suppress noise in both power supplies.

The NDS is directly connected to the FPGAs inputs with short wiring
The NEC screens are conneected through 120 Ohm resistors near the FPGA to suppress refelctions in the long wiring to the  screens. 
All signals except the two pixel clocks of both displays are connected in parallel. I.e. one FPGA output drives two pins, one on each LCD. 

