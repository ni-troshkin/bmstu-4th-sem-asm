code_seg segment para public 'code'
	mov al, 3
	mov dl, 2
	div dl
	add al, '0'
	mov ah, 2
	mov dl, al
	int 21h
	mov ax, 4c00h
	int 21h
code_seg ends
end