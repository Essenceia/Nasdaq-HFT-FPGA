SETUP_SCRIPT=setup.tcl
VIVADO_TCL=vivado -mode batch -source 

BASE_FPGA=xc7a100tfgg484-2
# my fancy fpga is an ultrascale, i am working with a garage budget
FANCY_FPGA=xcku025-ffva1156-2-i

BUILD=build

files:
	mkdir -p ${BUILD} 

# setup vivado if it hasn't been done yet
fpga: files
	${VIVADO_TCL} ${SETUP_SCRIPT} -tclargs ${BASE_FPGA} 

fancy_fpga: files
	${VIVADO_TCL} ${SETUP_SCRIPT} -tclargs ${FANCY_FPGA} 

clean:
	rm -f vivado*
	rm -fr *hft_fpga
	rm -fr build
	rm -f *.rpt
	rm -fr hd_visual
	rm -fr *.txt
