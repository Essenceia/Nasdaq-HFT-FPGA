# HFT FPGA RTL

The objective of this project is to have a fast, reliable and well verified hight frequency
trading low level compatible with NADSAQ ITCH/OUCH protocols.


```
                                                                +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
                              +----------+                      |                                                                                     FPGA                                                                                     |
                              |  Switch  |                      |                                                                                                                                                     +----------------------+ |
+----------------------+      |          |                 +----+---+       +-----------------+            +-------------+                 +----------------------+                +----------------------+           |                      | |
|                      |      |          |   UDP multicast |        |       |                 | UDP packet |             |  Mold messages  |                      |  ITCH packets  |                      |           |  Trading algorithm   | |
|  NASDAQ ITCH server  +------+-----+----+---------------->|  Eth0  +------>|  UDP (rx only)  +----------->|  MoldUDP64  +---------------->|  Totalview ITCH 5.0  +--------------->|  ITCH packet filter  +---------> |                      | |
|                      |      |     |    |                 |        |       |                 |            |             |                 |                      |                |                      |           |                      | |
+----------------------+      |     |    |                 +----+---+       +-----------------+            +-------+-----+                 +----------------------+                +----------------------+           |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
                              |     |    |                      |                                                  |                                                                                                  |                      | |
+----------------------+      |     |    |                      |                                                  |                                                                                                  |                      | |
|                      +------+-----+    |                 +----+---+       +-----------------+Mold missing message|                                                                                                  |                      | |
|    NASDAQ ITCH       |      |          |        UDP      |        |       |                 |    replay request  |                                                                                                  |                      | |
|  Re-request server   |<-----+----------+-----------------+  Eth1  |<------+  UDP (tx only)  |<-------------------+                                                                                                  |                      | |
|                      |      |          |                 |        |       |                 |                                                                                                                       |                      | |
+----------------------+      |          |                 +----+---+       +-----------------+                                                                                                                       |                      | |
                              +----------+                      |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
                                                                |                                                                                                                                                     |                      | |
 +----------------------+                                  +----+---+            +-------+              +------------------+                    +-------------+                                                       |                      | |
 |                      |                          TCP     |        |            |       |              |                  |                    |             |                                                       |                      | |
 |  NASDAQ OUCH server  |<-------------------------------->|  Eth2  |<---------->|  TCP  |<------------>|  SoupBinTCP 3.0  |<------------------>|  OUCH 5.0   |<----------------------------------------------------->|                      | |
 |                      |                                  |        |            |       |              |                  |                    |             |                                                       |                      | |
 +----------------------+                                  +----+---+            +-------+              +------------------+                    +-------------+                                                       |                      | |
                                                                |                                                                                                                                                     +----------------------+ |
                                                                |                                                                                                                                                                              |
                                                                +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

## Test bench

Our top level testbench is driven by a C library via the VPI interface.
This library reads the binary file containing a day of nasdaq's itch packets, packages these
itch messages into moldudp64 packets then breaks then down into an axis stream.
We compare the outupt of the itch rtl decoder module out the other end.

For more information and quick start instructions see [tb/README.md](tb/README.md)

### Quickstart

Requirement :
- `iverilog` 

1. Obtain a nasdaq binary file dump of totalview 5.0 itch messages.
    
    Link to the official nasdaq server : [Nasdaq ITCH marketdata dumps](https://emi.nasdaq.com/ITCH/Nasdaq%20ITCH/) 
    
    Archive should be named `<date>.NASDAQ_ITCH50.gz` 

2. In `tb/hft_tb.v` specify the location of your nasdaq itch market data dump :
    ```
    t = $tb_init("<path_to_file>");
    ```

3. In `tb/vpi/Makefile` specify path to iverilog :
    ```
    IVERILOG=<path_to_iverilog>
    ```

4. ( Default ) Build and run testbench with no waves :
    ```
    make run
    ```

4. ( Optional ) Dump waves during simulation :
    ```
    make run wave=1
    ```
    Open waves, by default we are using `gtkwave` :
    ```
    make wave
    ```
 
For more in depth usage and additional options see [tb/README.md](tb/README.md).

## Roadmap

Features currently under development :

- [X] Totalview ITCH 5.0 decoder
- [X] Totalview ITCH 5.0 Glimpse extension decoder
- [X] MoldUDP64 AXI stream receiver
- [X] UDP Multicast receiver
- [X] MoldUDP64 missing message detection
- [ ] Send MoldUDP64 missing message retransmission request
- [ ] low latency UDP
- [ ] low latency TCP
- [ ] SoupBinTCP AXI stream receiver
- [ ] OUCH 5.0 encoder
- [ ] TCP Glimpse request
- [ ] TCP Glimpse response



# License

This code is licensed under CC BY-NC 4.0, all rights belong to Julia Desmazes.
