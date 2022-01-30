; Лабораторная работа №5, Трошкин Н., ИУ7-46Б

; в прямоугольной символьной матрице в каждом столбце 
; заменить заглавную латинскую букву,
; имеющую наибольший номер в алфавите, на #

extrn replace_by_sharp: far

stk segment para stack 'stack'
	db 200 dup(0)
stk ends

msgs segment para public 'data'
	inv_rows_msg db "Enter number of rows (1 to 9): $"
		
	inv_cols_msg db "Enter number of columns (1 to 9): $"
	
	output_res_msg db "The resulting matrix:"
	
	new_line db 10
			db 13
			db '$'

	inv_elems_msg db "Please enter the whole matrix:$"

	error_rows_msg db "Error: Invalid number of rows$"
	error_cols_msg db "Error: Invalid number of columns$"
	
msgs ends

matrix segment para common 'data'
	matr db 81 dup(0)
	rows dw 0
	cols dw 0
	; MAX_ROWS dw 9
	MAX_COLS dw 9
matrix ends

input segment para public 'code'
	assume cs:input, ss:stk, ds:msgs, es:matrix

show_msg:    ; echo string
	mov ah, 9
	int 21h
	ret	

input_sym:	 ; input symbol
	mov ah, 1
	int 21h
	ret

output_sym:   ; echo symbol
	mov ah, 2
	int 21h
	ret

end_line:    ; echo \n
	mov dx, offset new_line
	call show_msg
	ret

read_num_rows:
	mov dx, offset inv_rows_msg
	call show_msg
	call input_sym  	; enter & convert number of rows
	
	mov ah, 0
	sub al, '0'
	mov rows, ax
	
	call end_line
	ret

read_num_cols:
	mov dx, offset inv_cols_msg
	call show_msg
	call input_sym          ; enter & convert number of cols
	
	mov ah, 0
	sub al, '0'
	mov cols, ax
	
	call end_line
	ret



read_row:   ; read one row into matrix
	mov di, cx    ; save cx previous value
	mov cx, cols
	mov si, 0
	
	read_sym_loop:   ; read symbol into matrix
		call input_sym
		mov matr[bx][si], al
		inc si
		loop read_sym_loop
	
	mov cx, di   ; restore cx previous value
	ret
	
read_matrix:
	mov dx, offset inv_elems_msg
	call show_msg
	call end_line
	
	mov cx, rows
	mov bx, 0
	
	read_row_loop:
		call read_row
		add bx, MAX_COLS
		call end_line
		loop read_row_loop
		
	ret

output_row:
	mov si, 0
	mov di, cx
	mov cx, cols
	
	output_sym_loop:
		mov dl, matr[bx][si]
		call output_sym
		inc si
		loop output_sym_loop
	
	mov cx, di
	ret

output_matrix:
	call end_line
	mov dx, offset output_res_msg
	call show_msg
	call end_line
	
	mov cx, rows
	mov bx, 0

	output_row_loop:
		call output_row
		add bx, MAX_COLS
		call end_line
		loop output_row_loop
	
	ret


main:
	mov ax, msgs     ; put segments into seg registers
	mov ds, ax
	
	mov ax, matrix
	mov es, ax
	
	call read_num_rows

	cmp rows, 1              ; rows number check
	jl err_row
	cmp rows, 9
	jg err_row

	call read_num_cols

	cmp cols, 1             ; cols number check
	jl err_col
	cmp cols, 9
	jg err_col
	
	call read_matrix
	call replace_by_sharp
	call output_matrix
	jmp exit


err_row:
	call end_line
	mov dx, offset error_rows_msg
	call show_msg
	call end_line
	jmp exit

err_col:
	call end_line
	mov dx, offset error_cols_msg
	call show_msg
	call end_line
		
exit:	
	mov ax, 4c00h
	int 21h
input ends

public rows
public cols
public matr
public MAX_COLS

end main