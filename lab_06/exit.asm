; EXIT
public exit
exit_code segment para public 'code'
	exit proc far
		mov ax, 4c00h
		int 21h
	exit endp
exit_code ends
end