; Лабораторная работа №6
extrn input_hex: far
extrn exit: far
extrn output_hex: far
extrn output_oct: far
extrn output_bin: far

public value

stk segment para stack 'stack'
	db 200 dup(0)
stk ends

menu_data segment para public 'data'
	value dw 0
	menu db 13, 10, "Please enter the number of function:", 13, 10,
			"0 - Exit", 13, 10,
			"1 - Enter new signed hex number", 13, 10,
			"2 - Type signed hex number", 13, 10,
			"3 - Type unsigned binary number", 13, 10,
			"4 - Type signed octal number", 13, 10, '$'
	error_msg db 13, 10, "Wrong function number", 13, 10, '$'
	
	func_ptrs dd exit, input_hex, 
	             output_hex, output_bin, output_oct
menu_data ends

menu_code segment para public 'code'
	assume cs:menu_code, ds:menu_data

main:
	mov ax, menu_data
	mov ds, ax

show_menu:
	mov ah, 9                          ; show menu
	mov dx, offset menu
	int 21h
	
	mov ah, 1                          ; enter num of func
	int 21h
	
	cmp al, '0'                        ; check num of func
	jl show_error
	cmp al, '4'
	jg show_error
	
	mov ah, 0                          ; convert sym -> func index
	sub al, '0'
	mov dx, 4
	mul dx
	
	mov bx, ax                         ; save func index
	
	mov ah, 2                          ; print new line
	mov dl, 13
	int 21h
	mov dl, 10
	int 21h

	call func_ptrs[bx]

	jmp show_menu

show_error:
	mov ah, 9                          ; wrong function error
	mov dx, offset error_msg
	int 21h
	jmp show_menu

menu_code ends

end main