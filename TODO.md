- Add UDP ethernet capability
- Add formal 
- Add tb_end with memory free for vpi
- Compare itch values with struct
- Futur small use case to debug system behavior : filter out all packets exept MPID = OPTU
- Found memory leak in iverilog : look into leak source and eventually fix ?
- Generate a new nasdaq binary file from the current one with a random mix of instructions :
    currently reading file in order, to high concentration of startup specific messages at 
    begining of simulation; could be optimized
