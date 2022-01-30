CFLAGS = -Wall -Werror -Wno-unused-but-set-variable -O0

.PHONY: build usemno usem clean

app.exe:
	gcc -Wall -Werror -Wno-unused-but-set-variable -O0 -mno-80387 -c mnofpu.c
	gcc -Wall -Werror -Wno-unused-but-set-variable -O0 -m80387 -c mfpu.c
	gcc -Wall -Werror -Wno-unused-but-set-variable -O0 -masm=intel -c asm.c
	gcc -Wall -Werror -Wno-unused-but-set-variable -O0 -masm=intel -c countsin.c
	gcc -c main.c
	gcc -o app.exe mnofpu.o mfpu.o asm.o main.o countsin.o
# run: app.exe
# 	./$<

# build: app.exe

# usemno: CFLAGS += -mno-80387
# usemno: app.exe

# mnoasm: CFLAGS += -mno-80387
# mnoasm: mainmno.s

# usem: CFLAGS += -m80387
# usem: app.exe

# m_asm: CFLAGS += -m80387
# m_asm: main.s

# app.exe: main.o
# 	gcc -o $@ -O0 $<

# main.o: main.c
# 	gcc $(CFLAGS) -c $<

# main.s: main.c
# 	gcc $(CFLAGS) -S $<

# mainmno.s: main.c
# 	gcc $(CFLAGS) -o $@ -S $<

clean:
	rm -rf *.o *.exe *.s