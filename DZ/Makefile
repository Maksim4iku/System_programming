ASM      = queue.asm
ASM_OBJ  = queue.o
C_SRC    = main.c
C_OBJ    = main.o
TARGET   = myprog

asm: $(ASM)
	fasm $(ASM) $(ASM_OBJ)

c: $(C_SRC)
	gcc -c -Wall -O2 $(C_SRC) -o $(C_OBJ)

build: asm c
	gcc $(C_OBJ) $(ASM_OBJ) -o $(TARGET)

run: build
	./$(TARGET)

clean:
	rm -f *.o $(TARGET)
