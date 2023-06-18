# Hight frequency trading hardware RTL

The objective of this project is to have a fast, reliable and well verified hight frequency
trading low level compatible with nasdaq's itch/otch protocols.

This is an ongoing project.

Features currently under development :

- [X] Totalview ITCH 5.0 decoder
- [X] Totalview ITCH 5.0 Glimpse extension decoder
- [X] MoldUDP64 AXI stream receiver
- [X] UDP Multicast receiver
- [X] MoldUDP64 missing message detection
- [ ] Send MoldUDP64 missing message retransmission request
- [ ] SoupBinTCP AXI stream receiver
- [ ] TCP Glimpse request
- [ ] TCP Glimpse response

![Work in progress, img source :https://www.asxonline.com/content/dam/asxonline/public/documents/asx-trade-refresh-manuals/asx-trade-itch-message-specification.pdf !](/doc/wip.jpg)

Areas grayed out are our planned but not yet in progress features.

## Test bench

Testing is done by driving the AXI stream interface with the expected output of the
UDP packet decoder.
This AXIS stream contains MoldUDP64 packets themself containing ITCH messages.
The content for these ITCH messages are read from a file containing [Nasdaq ITCH marketdata dumps](https://emi.nasdaq.com/ITCH/Nasdaq%20ITCH/).
All of this is performed via a Verilog Programming Interface ( VPI ) coded in C.


To run :

Specify the location of your nasdaq itch market data dump in `tb/hft_tb.v`.
```
$tb_init("<path_to_file>");
```

Normal test run command, no debug logs, no waves :
```
make run
```

( Optional ) Arguments :

- `debug=1` Add debug console logs

- `wave=1` Write waves to file

- `interactive=1` Stop simulator when an system verilog assert fires,
    used for interactive debugging

``` 
make run debug=1 wave=1
```

Open wave viewer, only available with option `wave=1` using `gtkwave` by default.
```
make wave
```

Run gdb on C testbench :
```
make gdb
```

Run valgrind on C testbench :
```
make valgrind
```

Clean :
```
make clean
```
 
For additional information read the [README.md](tb/README.md) in the `tb` folder

### Tools

Since the nasdaq provided binary file is a dump of itch broadcast messages we 
have long sequences of messages with low variety, such as on startup with a lot of 
`stock event` messages and `stock directy` messages.

In order to increase variety we use a small tool to create a new binary file with
a subset of randomly selected messages.

Tool can be found : https://github.com/Essenceia/Nasdaq_binaryfile_utils

# License

This code is licensed under CC BY-NC 4.0, to obtain a commercial license
reach out to the author .
