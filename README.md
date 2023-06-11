# Hight frequency trading hardware RTL

The objective of this project is to have a fast, reiliable and well verified hight frequence
trading low level compatible with nasdaq's itch/otch protocols.

This is an ungoing project.

Features currently under developpement :

- [X] Totalview ITCH 5.0 decoder
- [X] Totalview ITCH 5.0 Glimpse extention decoder
- [X] MoldUDP64 AXI stream reciever
- [X] UDP Multicast reciver
- [X] MoldUDP64 missing message detection
- [ ] UDP missing message request
- [ ] SoupBinTCP AXI stream reciever
- [ ] TCP Glimpse request
- [ ] TCP Glimpse response

![Work in progress, img source :https://www.asxonline.com/content/dam/asxonline/public/documents/asx-trade-refresh-manuals/asx-trade-itch-message-specification.pdf !](/doc/wip.jpg)

Areas grayed out are our planned but not yet in progress features.

## Test bench

Testing is done by driving the AXI stream interface with the expected output of the
UDP packet decoder.
This AXIS stream contains MoldUDP64 packets themselfs containing ITCH messages.
The content for these ITCH messages are read from a file containing [Nasdaq ITCH marketdata dumps](https://emi.nasdaq.com/ITCH/Nasdaq%20ITCH/).
All of this is performed via a Verilog Programing Interface ( VPI ) coded in C.


To run :

Specify the location of your nasdaq itch market data dump in `tb/hft_tb.v`.
```
$tb_init("<path_to_file>");
```

Use the command line :
```
make run
```

For additional information read the [README.md](tb/README.md) in the `tb` folder


# License

This code is licensed under CC BY-NC 4.0, to obtain a commercial license
reach out to the author .
