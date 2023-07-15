- Add UDP ethernet capability
- Add formal 
- Futur small use case to debug system behavior : filter out all packets exept MPID = OPTU
    and attactch the print to my motivation letter 
- Found memory leak in iverilog : look into leak source and eventually fix ?
- Send end of session messages for mold when sequence number for testing the
    feature and when seq gets to close to the max range of a uint64\_t
- Add predictable random number generator and print it's value along fpos for wave creation
- Add ability to start dumping waves at a set time ( future debuging ) 
- Add system verilog structure to contain itch wave values ( convert field to little endian for readability )
- Better doc 
- Run new nightly
- Add tb feature to skip packets and compare expected skip start-end to mold missing packet detector
    ( used in re-replay ) 
- Axis master ?
- Connect re-replay feature to udp 
- Stop being cheap and go buy that fpga ... ( and the fiber switch ) :moneywithwings:
- Implement O+ ?
