WARNS  = -Wall

INCS   = -I ../../open-src-cvc.700c/pli_incs

CFLAGS = -fPIC -Wall -g $(INCS)
LFLAGS = -G -shared

CC      = gcc
CVC     = ../bin/cvc64
OBJ     = simv

RISCV_CC  = riscv32-unknown-elf-gcc
RISCV_CPP = riscv32-unknown-elf-g++
RISCV_LD  = riscv32-unknown-elf-ld


elf32memory.o: elf32memory.c
	$(CC) $(CFLAGS) -c ./elf32memory.c

elf32memory.so: elf32memory.o
	$(LD) $(LFLAGS) elf32memory.o -o elf32memory.so

cvc: elf32memory.so
	${CVC} -q -sv -f sim_list.f -f list.f -sv_lib elf32memory.so -o $(OBJ)

run: cvc
	./$(OBJ)

clean:
	rm -rf *.o *.so *.log simv
