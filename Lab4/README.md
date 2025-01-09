# Lab4 - 5-Stage Pipelined ARM CPU

Finally, Lab4 builds a 64-bit pipelined ARM processor. This allows us to introduce a lot of parallelism into the processor in order to massively increase throughput by running multiple instructions simulataneously. The five stages are broken down into the following: Instruction Fetch, Register Decode, Execute, Data Memory, and Writeback. For instructions that might not utilize all five stages, the processor inserts a NOOP in the appropriate stage in order to not stall the pipeline. In order to resolve control hazards, the processor utilizes a notion of branch prediction and branch delay slots. In order to resolve data hazards, the processor includes a forwarding unit that forwards data from and to the appropriate stages.

Pipelined CPU Schematic:

<img src="https://github.com/user-attachments/assets/4273329e-400f-40e3-b129-73d92b60cb7b" alt="image" width="1400"/> <br><br><br>

