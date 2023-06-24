# Vivado setup

To setup project for vivado and run all the implem
upto the timing in an out of context flow :

```
make fpga
```
By default we are targetting `BASE_FPGA` whoes value is set
to `xc7a100tfgg484-2`. 

If you can afford something a little more fancy you might
be intrested in the `FANCY_FPGA` targetting `xcku025-ffva1156-2-i` an ultrascale. 

To invoke use :
```
make fancy_fpga
```

To clean project, will destroy everything:
```
make clean
```

