; ассемблер 04 - многомодульные программы
; Составить программу из двух модулей. В первом ввести цифру N, 
; затем передать управление с помощью дальнего перехода во второй 
; и там вывести N раз букву A

EXTRN output: far
PUBLIC N

STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

DATA SEGMENT para 'DATA'
	InviteMsg db "Enter a digit: $"
	N db '0'
DATA ENDS

INPUT SEGMENT para 'CODE'
	assume DS:DATA, CS:INPUT

main:
	mov	ax, DATA
	mov	ds, ax
	
	mov ah, 09
	mov dx, OFFSET InviteMsg
	int 21h
	
	mov ah, 01h
	int 21h
	mov N, al

	jmp output
INPUT ENDS

END main