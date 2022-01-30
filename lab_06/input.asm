; INPUT SIGNED HEX_NUMBER
public input_hex
extrn value: word

input_msgs segment para public 'data'
	invite db 13, 10, 
	          "Please enter a hex number from -8000 to 7FFF: $"
	error_digit_msg db 13, 10, "Invalid value$"
input_msgs ends

input segment para public 'code'
	assume cs:input, es:input_msgs

input_hex proc far
	mov ax, input_msgs
	mov es, ax
	
	mov cx, 16                         ; get es - ds
	mov dx, ds
	sub ax, dx

	mul cx
	mov dx, offset invite
	add dx, ax                         ; get offset from ds
	mov ah, 9                          ; show invitation
	int 21h
	
	mov cx, 5
	mov bx, 0                          ; symbols counter
	mov dl, 0                          ; flag 'is_negative'
	mov ah, 1
	input_symbols:
		int 21h
		cmp al, 13                     ; ENTER - break
		je end_loop
		
		cmp al, '-'                    ; check minus
		jne check_digit
		
		cmp bx, 0                      ; ok if minus first
		je set_is_neg
		
		jmp error_digit                ; error if not
	
	check_digit:
		cmp al, '0'                    ; < '0' - error
		jl error_digit
		
		cmp al, 'F'                    ; > 'F' - error
		jg error_digit
		
		cmp al, '9'                    ; '0' - '9' - ok
		jle save_digit
		
		cmp al, 'A'                    ; ('9'+1) - ('A'-1) - error
		jl error_digit
		
		jmp save_digit
	
	set_is_neg:
		mov dl, 1
	save_digit:		
		push ax
		inc bx                         ; shift index
		loop input_symbols
	
end_loop:
	cmp bx, 0                          ; empty entry - error
	je error_digit
	
	cmp bx, 5
	jl convert
	
	cmp dl, 1                          ; 5 digits in number - err
	jne error_digit

convert:
	mov value, 0
	
	mov cx, bx                         ; how many symbols read
	mov ax, 1                          ; factor 16^n
	mov si, 16                         ; mul ax -> 16^(n + 1)

str_to_num:
	pop dx
	dec bx
	cmp dl, '-'                        ; minus - needs inversion
	je minus_found
	sub dl, '0'                        ; 'digit' -> digit
			
	cmp dl, 10h
	jl digit_converted
	sub dl, 'A' - '9' - 1              ; correction for 'a'-'f'

digit_converted:
	mov di, ax                         ; save ax
	mov dh, 0
	mul dx                             ; ax * digit = digit * 16^n
	add value, ax                      ; add to real value
	mov ax, di                         ; restore ax
	mul si                             ; ax *= 16
	loop str_to_num
	
	jmp return

minus_found:                           ; value *= -1
	mov ax, value
	mov si, -1
	mul si
	mov value, ax
	
	jmp return

error_digit:
	mov ax, es
	mov dx, ds
	sub ax, dx
	mov cx, 16
	mul cx
	
	mov dx, offset error_digit_msg     ; show error
	add dx, ax                         ; get offset from ds:0000
	mov ah, 9
	int 21h

	cmp bx, 0
	je return
	mov cx, bx
	clear_stack:
		pop dx
		loop clear_stack

return:
	ret

input_hex endp
	
input ends

end