BUILD=build
INC=inc
FLAGS = -std=gnu99 -Wall -Wextra -Wconversion -Wshadow -Wundef -fno-common  -Wno-unused-parameter -Wno-type-limits -g
CC = cc $(if $(debug),-DDEBUG -g)
LD = cc
LIB=-L. -litch
test: moldudp64.o test.o libitch.a
	$(LD) -o test -g test.o moldudp64.o $(LIB)

test.o:test.c
	$(CC) -I$(INC) -c test.c $(FLAGS)

moldudp64.o: moldudp64.c moldudp64.h
	$(CC) -c moldudp64.c $(FLAGS)

clean:
	rm -f test	
	rm -f *.o
	rm -f vgcore.*	

