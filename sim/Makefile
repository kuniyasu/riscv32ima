WARNS  = -Wall

INCS   = -I /usr/local/tachyon/open-src-cvc.700c/pli_incs
CPATH  = ./src
VPATH  = ./tb

CFLAGS = -fPIC -Wall -g $(INCS)
LFLAGS = -G -shared

CC      = gcc
CVC     = cvc64
OBJ     = simv

run : cvc

tb.o: $(CPATH)/tb.c
    $(CC) $(CFLAGS) -c $(CPATH)/tb.c

tb.so: tb.o
    $(LD) $(LFLAGS) tb.o -o tb.so

cvc: tb.so
    ${CVC} -q -sv -sv_lib tb.so ${VPATH}/tb.sv -o $(OBJ)

run: cvc
    ./$(OBJ)

clean:
    rm -rf *.o *.so *.log simv
		
