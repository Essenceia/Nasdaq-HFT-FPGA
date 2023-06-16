- Add UDP ethernet capability
- Add formal 
- Compare itch values with struct
- Futur small use case to debug system behavior : filter out all packets exept MPID = OPTU
- Found memory leak in iverilog : look into leak source and eventually fix ?
- itch ptr being null might not be caused by end of file, continue looking for cause of bug.
- Enable seq and sid for debug, help identify messages `MOLD_MSG_IDS`, check if match in tb
- Send end of session messages for mold when sequence number for testing the
    feature and when seq gets to close to the max range of a uint64\_t
