ifndef debug
#debug :=
endif

ifndef
#wave :=
endif

ifndef
#interactive :=
endif


TB_DIR=tb
VPI_DIR=$(TB_DIR)/vpi
BUILD=build
CONF=conf
FLAGS=-Wall -g2012 -gassertions -gstrict-expr-width
DEFINES=-DMISS_DET -DHEARTBEAT -DMOLD_MSG_IDS -DDEBUG_ID $(if $(debug), -DDEBUG_ID) $(if $(wave), -DWAVE) $(if $(interactive), -DINTERACTIVE )
IMPLEM_DEFINES=$(if $(wave), -DWAVE) $(if $(interactive), -DINTERACTIVE )
DEBUG_FLAG=$(if $(debug), debug=1)
WAVE_FILE=wave.vcd
WAVE_CONF=wave.conf
VIEW=gtkwave

ITCH_DIR=itch
INC = -I$(ITCH_DIR)

all: top run

# Test bench 
top: top.v moldudp64 itch
	iverilog $(FLAGS) -s hft $(DEFINES) -o $(BUILD)/hft $(INC) top.v -y moldudp64/ -y itch/

test: $(TB_DIR)/hft_tb.v top
	iverilog $(FLAGS) -s hft_tb $(DEFINES) -o $(BUILD)/hft_tb $(INC) top.v $(TB_DIR)/hft_tb.v -y moldudp64/ -y itch/

run: test vpi
	vvp -M $(VPI_DIR) -mtb $(BUILD)/hft_tb

# Implementation specific test bench 
implem_top: top.v moldudp64 itch
	iverilog $(FLAGS) -s hft $(IMPLEM_DEFINES) -o $(BUILD)/implem_hft top.v -y moldudp64/ -y itch/

# need to define debug if we want the test bench to work
implem_tb: $(TB_DIR)/hft_tb.v implem_top
	iverilog $(FLAGS) -s hft_tb -DDEBUG_ID $(IMPLEM_DEFINES) -o $(BUILD)/implem_hft_tb top.v $(TB_DIR)/hft_tb.v -y moldudp64/ -y itch/

implem_tb_run: implem_tb vpi
	vvp -M $(VPI_DIR) -mtb $(BUILD)/implem_hft_tb


vpi:
	cd $(VPI_DIR) && $(MAKE) tb.vpi $(DEBUG_FLAG) 

wave :
	$(VIEW) $(BUILD)/$(WAVE_FILE) $(CONF)/$(WAVE_CONF)

valgrind: test vpi
	valgrind vvp -M $(VPI_DIR) -mtb $(BUILD)/hft_tb

gdb: test vpi
	gdb --args vvp -M $(VPI_DIR) -mtb $(BUILD)/hft_tb
  
clean:
	cd $(VPI_DIR) && $(MAKE) clean
	rm -fr $(BUILD)/*
	rm -f *.o
	rm -f vgcore.*
