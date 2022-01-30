; OUTPUT HEX SIGNED NUMBER

public output_hex
extrn value: word

print_shex segment para public 'code'
	assume cs:print_shex
	
	output_hex proc far
		mov ax, value
		
		cmp value, 0
		jge abs_conversion
		
		xchg ax, bx
		mov ah, 2
		mov dl, '-'
		int 21h
		xchg ax, bx
		mov bx, -1
		mul bx	
		
	abs_conversion:
		mov bx, 0
		mov cx, 4
		mov di, 16
		to_hex:
			mov dx, 0
			div di
			
			add dl, '0'
			cmp dx, '9'
			jle digit_converted
			
			add dl, 'A' - '9' - 1
			
		digit_converted:
			inc bx
			push dx
			cmp ax, 0
			loopne to_hex
		
		mov cx, bx
		mov ah, 2
		print_hex:
			pop dx
			int 21h
			loop print_hex
		
		mov dl, 13
		int 21h
		mov dl, 10
		int 21h
		
		ret
	output_hex endp
print_shex ends
end