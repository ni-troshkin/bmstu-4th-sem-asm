EXTRN N: byte
PUBLIC output

PRINT SEGMENT para 'CODE'
	assume CS:PRINT
output:
	mov cx, 0
	mov cl, N
	sub cx, '0'

	mov ah, 02
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h
	
	cmp cx, 0
	je  exit
	
	mov dl, 'A'
print_sym:
	int 21h
	loop print_sym

exit:
	mov ah, 4Ch
	int 21h
PRINT ENDS

END