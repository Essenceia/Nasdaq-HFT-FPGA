# VPI module

Contains C test bench code, used for driving the rtl test bench.
Reads the binary file containing a day of nasdaq's itch packets, packages these
itch messages into moldudp64 packets then breaks then down into an axis stream.
We compare the outupt of the itch rtl decoder module out the other end.

## ITCH static library

We are including the `libitch.a` static library, the original code for this library
can be found at : https://github.com/Essenceia/TotalView-ITCH-5.0-C-lib 
