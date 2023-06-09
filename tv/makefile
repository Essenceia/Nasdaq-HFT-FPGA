GEN_DIR=gen
XML=nasdaq_totalview_itch.xml
SCRIPT=itch_msg_to_c.py


FLAGS = -std=gnu99 -Wall -Wextra -Wconversion -Wshadow -Wundef -fno-common  -Wno-unused-parameter -Wno-type-limits
CC = cc $(if $(debug),-DDEBUG -g)
LD = cc
.PHONY: gen	

test : test.o file.o itch.o
	$(LD) -o test -g test.o file.o itch.o

test.o : test.c
	$(CC) -c test.c $(FLAGS)

file.o: gen file.h file.c
	$(CC) -c file.c $(FLAGS)

gen : ${GEN_DIR}/${XML} ${GEN_DIR}/${SCRIPT}
	cd ${GEN_DIR} ; python ${SCRIPT} ${XML}


itch.o: type.h itch_s.h gen 
	$(CC) -c itch.c $(FLAGS) 

lib: itch.o file.o
	ar rcs itch.a itch.o file.o 

clean:
	rm -f ${GEN_DIR}/*.h
	rm -f *.o	
	rm -f *.a	
	rm -f test

