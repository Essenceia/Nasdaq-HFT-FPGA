BUILD=build
INC=inc
IVERILOG=/home/pitchu/AUR/iverilog
FLAGS = -std=gnu99 -Wall -Wextra -Wconversion -Wshadow -Wundef -fno-common -Wno-unused-parameter -Wno-type-limits -fpic
CC = cc $(if $(debug),-DDEBUG -g)
LD = cc
LIB=-L. -litch
test: moldudp64.o test.o tv.o axis.o libitch.a
	$(LD) -o test -g test.o moldudp64.o tv.o axis.o $(LIB)

test.o:test.c
	$(CC) -I$(INC) -c test.c $(FLAGS)

moldudp64.o: moldudp64.c moldudp64.h
	$(CC) -c moldudp64.c $(FLAGS)

axis.o: axis.c axis.h
	$(CC) -c axis.c $(FLAGS)
 
tv.o: tv.c tv.h
	$(CC) -I$(INC) -I$(IVERILOG) -c tv.c $(FLAGS)

tb_utils.o: tb_utils.c tb_utils.h
	$(CC) -I$(INC) -I$(IVERILOG) -c tb_utils.c $(FLAGS)

tb.o: tb.c tb.h
	$(CC) -I$(INC) -I$(IVERILOG) -c tb.c $(FLAGS)

tb_itch.o: tb_itch.c tb_itch.h
	$(CC) -I$(INC) -I$(IVERILOG) -c tb_itch.c $(FLAGS)
  
tb.vpi: tb.o tb_utils.o tb_itch.o tv.o moldudp64.o axis.o libitch.a
	$(LD) -shared -o tb.vpi tb.o  tv.o axis.o moldudp64.o tb_utils.o tb_itch.o $(LIB) -lvpi

clean:
	rm -f test	
	rm -f *.o
	rm -f vgcore.*	

TB_DIR=tb
