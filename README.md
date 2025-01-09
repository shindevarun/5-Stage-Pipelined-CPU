# 5-Stage-Pipelined-CPU

Over the course of my computer architecture class (EE 469), I built a fully functional pipelined ARM microprocessor. This CPU was built using System Verilog and every component was rigorously simulated and tested in ModelSim. Additionally, although this processor can be simplified by using RTL, it was built to almost exclusively be strucural (only using explicit gates and boolean equations) for the purposes of the class and also to enhance learning. 

This repository is broken down a series of 4 labs. Each lab builds a new system in the overall processor design, often using components from the previous lab(s), and by Lab4, a fully functional 5-stage pipelined ARM processor will be completed. <br><br>

# Lab1 - Register File

Lab1 builds a 32x64 register file (32, 64-bit registers). The registers are built using D-flip-flops (each register is an array of 64 D-flip-flops that hold a 1-bit value each). A 5:32 enabled decoder and two 32x64 to 64 multiplexors are used as well to implement all read/write logic to the register file.

<img src="https://github.com/user-attachments/assets/02135b47-69e3-418d-8d48-e6198b3b2923" alt="image" width="500"/> <br><br>

# Lab2 - Arithmetic Logic Unit (ALU)

Lab2 builds a 64-bit ALU. This ALU can do the following operations while taking in 2 64-bit values, A, B:
- A + B
- A - B
- Bitwise A & B
- Bitwise A | B
- Bitwise A xor B
- B bypass

Additionally, it also produces 4 output flags to indicate when an operation results is a negative, zero, overflow, and carry-out.

<img src="https://github.com/user-attachments/assets/f9deabd2-dc1e-4693-8dac-27e5a4238c55" alt="image" width="500"/> <br><br>

# Lab3 - Single-Cycle ARM CPU

Lab3 builds a 64-bit single-cycle ARM processor. This processor pulls instructions from instruction memory, decodes the instructions, and then executes those instructions using the register file and ALU built in the two previous labs. This processor is capable of executing the following instruction set:

- ADDI (Adds a constant to a register value)
- ADDS (Adds two register values and sets flags)
- B (Adds a sign-extended Imm26 value to the program counter + 4 for branching)
- B.LT (Updates program counter using flag register for branching)
- CBZ (Updates program counter for branching using conditional logic)
- LDUR (Loads a value from data memory into a register)
- LSL (Logical shift left a register value)
- LSR (Logical shift right a register value)
- MUL (Multiplies 2 register values)
- STUR (Stores a register value into data memory)
- SUBS (Subtracts two register values and sets flags)


Instruction and Data path:

<img src="https://github.com/user-attachments/assets/fa6eefc8-bcab-4643-b45d-dfb738eb610d" alt="image" width="800"/> <br><br>

# Lab4 - 5-Stage Pipelined ARM CPU

Finally, Lab4 builds a 64-bit pipelined ARM processor. This allows us to introduce a lot of parallelism into the processor in order to massively increase throughput by running multiple instructions simulataneously. The five stages are broken down into the following: Instruction Fetch, Register Decode, Execute, Data Memory, and Writeback. For instructions that might not utilize all five stages, the processor inserts a NOOP in the appropriate stage in order to not stall the pipeline. In order to resolve control hazards, the processor utilizes a notion of branch prediction and branch delay slots. In order to resolve data hazards, the processor includes a forwarding unit that forwards data from and to the appropriate stages.

Pipelined CPU Schematic:

<img src="https://github.com/user-attachments/assets/4273329e-400f-40e3-b129-73d92b60cb7b" alt="image" width="1000"/> 




