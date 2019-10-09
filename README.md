# FPGA-Communication-Bus-With-Error-Detection
This project describes the design and implementation of data packet communication using CRC error detection method. In this project we considered the optimum clock rate for communication utilization. A common bus is used for communication purpose. Each point connected to the common bus has an individual address. Raw data is received from upper layers and converted to frame forms. Send process starts when the common bus is idle. Communication implemented in secure ways and receiver module notify the sender module wheater the packet received unmistaken and complete.

 _____________________________________________________________________
|Start bit| Sender Add.| Receiver Add.| Data Size| Data| CRC*| End bit|
______________________________________________________________________

The project is designed using ISE Xilinx. This repository contains verilog source code.

