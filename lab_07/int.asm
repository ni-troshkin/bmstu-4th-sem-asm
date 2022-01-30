.model tiny

code segment
    assume cs:code
    org 100h

main:
    jmp init
    old_8h dd ?
    is_installed dw 2222
	speed db 7Fh                       ; текущий параметр команды F3
	sec db 0                           ; здесь будет храниться секунда предыдущего прерывания

change_speed proc
	call wait_KBin
	mov al, 0F3h                       ; команда - изменить параметры автоповтора клавиатуры
	out 60h, al
	call wait_KBin
	mov al, speed                      ; передаем параметры команды (в т.ч. скорость)
	out 60h, al
	
	sub speed, 1                       ; перейти на следующую скорость
	test speed, 01011111b              ; дошли до самой быстрой скорости и изменился бит 5
	jnz return
	mov speed, 01111111b               ; вернуть бит 5 в состояние 1

return:	
	ret
change_speed endp

; ожидание возможности ввода команды для клавиатуры
wait_KBin proc
	in al, 64h                          ; прочитать слово состояния
	test al, 0010b                      ; равен ли бит 1 единице?
	jnz wait_KBin                       ; нет - ждем дальше, иначе выходим
	ret
wait_KBin endp

my_int_8h proc
	push ax                             ; сохранение регистров
    push bx
    push cx
    push dx
    push es
    push ds
	
    pushf
	call cs:old_8h                      ; вызов старого обработчика

	mov ah, 2
	int 1Ah                             ; получить текущее время
	cmp sec, dh
	mov sec, dh                         ; сравнить с сохраненным и сохранить
	je int_end                          ; если равны, секунда не прошла, конец
	call change_speed                   ; установить новую скорость автоповтора ввода

int_end:
	pop ds
    pop es                              ; восстановление старых значений регистров
    pop dx
    pop cx
    pop bx
    pop ax
    iret
my_int_8h endp

init:
    mov ax, 3508h                      ; получаем адрес текущего обработчика
    int 21h

    cmp es:is_installed, 2222          ; cmp es, первоначальный cs (там где сохранен main)
    je uninstall                       ; => установлен наш обработчик, тогда его убираем

    mov word ptr old_8h, bx            ; сохраняем адрес старого обработчика
    mov word ptr old_8h + 2, es

    mov ax, 2508h
	mov dx, cs
	mov ds, dx
    mov dx, offset my_int_8h           ; устанавливаем наш обработчик
    int 21h

    mov dx, offset inst_msg
    mov ah, 9
    int 21h

    mov dx, offset init                ; выходим, оставляя все до init в памяти
    int 27h

uninstall:
    push es                            ; сохраняем сегментные регистры
    push ds

	mov es:speed, 0
	call change_speed

    mov dx, word ptr es:old_8h
    mov ds, word ptr es:old_8h + 2
    mov ax, 2508h                      ; устанавливаем старый обработчик
    int 21h

    pop ds                             ; восстанавливаем значения регистров
    pop es

    mov ah, 49h                        ; освобождение памяти
    int 21h

    mov dx, offset uninst_msg
    mov ah, 9h
    int 21h

    mov ax, 4C00h                      ; выход
    int 21h

    inst_msg   db 'Autofill installed!$'
    uninst_msg db 'Autofill uninstalled!$'

code ends

end main
