BUILD=build
INC=inc
IVERILOG=/home/pitchu/AUR/iverilog
FLAGS = -std=gnu99 -Wall -Wextra -Wconversion -Wshadow -Wundef -fno-common  -Wno-unused-parameter -Wno-type-limits -g -fpic
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
	$(CC) -I$(INC) -c tv.c $(FLAGS)

tb.o: tb.c tb.h
	$(CC) -I$(INC) -I$(IVERILOG) -c tb.c $(FLAGS)
 
tb.vpi: tb.o tv.o moldudp64.o axis.o libitch.a
	$(LD) -shared -o tb.vpi tb.o tv.o axis.o moldudp64.o $(LIB) -lvpi

clean:
	rm -f test	
	rm -f *.o
	rm -f vgcore.*	

TB_DIR=tb