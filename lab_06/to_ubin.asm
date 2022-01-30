; OUTPUT BIN UNSIGNED NUMBER

public output_bin
extrn value: word

print_ubin segment para public 'code'
	assume cs:print_ubin
	
	output_bin proc far
		mov bx, 0
		
		mov cx, 16                     ; max bin digits
		mov di, 2
		mov ax, value                  ; divide by 2, write mod
		to_bin:
			mov dx, 0
			div di
			add dl, '0'
			push dx
			inc bx
			cmp ax, 0
			loopne to_bin
	
		mov cx, bx
		mov ah, 2
		print_bin:
			pop dx
			int 21h
			loop print_bin

		mov dl, 13
		int 21h
		mov dl, 10
		int 21h
		ret
	output_bin endp
	
print_ubin ends
end