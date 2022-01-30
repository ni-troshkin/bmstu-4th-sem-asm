app.exe: copy.asm main.c
	nasm -f elf64 -o copy.o copy.asm
	gcc -masm=intel -c main.c
	gcc -o app.exe main.o copy.o

clean:
	rm -rf *.o *.exe