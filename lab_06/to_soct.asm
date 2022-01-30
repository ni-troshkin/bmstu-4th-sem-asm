; OUTPUT OCT SIGNED NUMBER

public output_oct
extrn value: word

print_soct segment para public 'code'
	assume cs:print_soct
	
	output_oct proc far
		mov ax, value
		cmp value, 0
		jge abs_conversion             ; if <0 - getting abs(value)
		
		xchg ax, bx
		mov ah, 2
		mov dl, '-'                    ; print '-'
		int 21h
		xchg ax, bx
		mov bx, -1                     ; get absolute value
		mul bx
		
	abs_conversion:
		mov bx, 0                      ; digits counter
		
		mov cx, 6                      ; max digits in oct
		mov di, 8                      ; to oct -> divide by 8
		to_oct:
			mov dx, 0
			div di
			add dl, '0'
			push dx                    ; save symbol in stack
			inc bx
			cmp ax, 0
			loopne to_oct
		
		mov cx, bx
		mov ah, 2
		print_oct:
			pop dx                     ; getting symbols from stack
			int 21h
			loop print_oct
		
		mov dl, 13
		int 21h
		mov dl, 10
		int 21h
		ret
	output_oct endp
print_soct ends
end