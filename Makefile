TB_DIR=tb
VPI_DIR=$(TB_DIR)/vpi
BUILD=build
CONF=conf
FLAGS=-Wall -g2012 -gassertions -gstrict-expr-width
DEFINES=-DMISS_DET -DHEARTBEAT -DMOLD_MSG_IDS
WAVE_FILE=wave.vcd
WAVE_CONF=wave.conf
VIEW=gtkwave

all: top run

top: top.v moldudp64 itch
	iverilog $(FLAGS) -s hft $(DEFINES) -o $(BUILD)/hft top.v -y moldudp64/ -y itch/

test: $(TB_DIR)/hft_tb.v top
	iverilog $(FLAGS) -s hft_tb $(DEFINES) -o $(BUILD)/hft_tb top.v $(TB_DIR)/hft_tb.v -y moldudp64/ -y itch/

run: test vpi
	vvp -M $(VPI_DIR) -mtb $(BUILD)/hft_tb

vpi:
	cd $(VPI_DIR) && $(MAKE) tb.vpi

wave : run
	$(VIEW) $(BUILD)/$(WAVE_FILE) $(CONF)/$(WAVE_CONF)

clean:
	rm -fr $(BUILD)/*
