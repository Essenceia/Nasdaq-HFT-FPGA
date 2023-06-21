# Test bench `hft_tb.v`

Our top level test bench drives the output of the AXI steam interface connecting into the
moldudp64 module and checks the resulting output of the itch decoder is correct.

Most of the work of driving the moldupd64 input wires as well as producing the expected itch output
states is done by a library coded in `C`.

## C test bench 

Within the `vpi` folder is the `C` portion of our test bench.
This code is compiled to a dynamically loaded module that interacts with our 
verilog test bench via the Verilog Programming Interface ( VPI ).

This code is responsible for :

- reading the nasdaq itch message file

- encapsulating a random number of these itch messages into a new moldudp64 packet

- breaking these packets down into AXI payloads

- driving them onto the AXI stream interface

- producing the expected output of the itch decoder for each itch message 


## Usage

For basic setup requirements see [quickstart](../README.md).

All following commands assumes the user is in the root directory.

### Run test bench

Normal test run command, no debug logs, no waves :
```
make run
```

( Optional ) Arguments :

- `debug=1` Add debug console logs

- `wave=1` Write waves to file

- `interactive=1` Stop simulator whenever an system verilog assert fires,
    used for interactive debugging

``` 
make run debug=1 wave=1 interactive=1
```

### Open waves

By default we are calling `gtkwave` as our wave viewer, if you wish to change this setting
modify `VIEW` in the top level `Makefile`.

Open wave viewer, only available with option `wave=1` using `gtkwave` by default.
```
make wave
```

### Debug C test bench code

Run gdb on C test bench :
```
make gdb
```

Run valgrind on C test bench :
```
make valgrind
```

### Clean test bench

Clean :
```
make clean
```

## Tools

Since the nasdaq provided binary file is a dump of itch broadcast messages we 
have long sequences of messages with low variety, such as on startup with a lot of 
`stock event` messages and `stock directy` messages.

In order to increase variety we use a small tool to create a new binary file with
a subset of randomly selected messages.

Tool can be found : https://github.com/Essenceia/Nasdaq_binaryfile_utils


## ITCH static library

We are including the `libitch.a` static library, the original code for this library
can be found at : https://github.com/Essenceia/TotalView-ITCH-5.0-C-lib 
