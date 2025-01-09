# 5-Stage-Pipelined-CPU

Over the course of my computer architecture class (EE 469), I built a fully functional pipelined ARM microprocessor. This CPU was built using System Verilog and every component was rigorously simulated and tested in ModelSim. Additionally, although this processor can be simplified by using RTL, it was built to almost exclusively be strucural (only using explicit gates and boolean equations) for the purposes of the class and also to enhance learning. 

This repository is broken down into 4 labs. Each lab builds a new system using components from the previous lab and by Lab4, a fully functional 5-stage pipelined ARM processor will be completed.

# Lab1 - Register File

Lab1 builds a 32x64 register file (32, 64-bit registers). The registers are built using D-flip-flops (each register is an array of 64 D-flip-flops that hold a 1-bit value each). A 5:32 enabled decoder and two 32x64 to 64 multiplexors are used as well to implement all read/write logic to the register file.
<img src="https://github.com/user-attachments/assets/02135b47-69e3-418d-8d48-e6198b3b2923" alt="image" width="500"/>

