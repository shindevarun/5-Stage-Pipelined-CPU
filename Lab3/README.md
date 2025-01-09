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

