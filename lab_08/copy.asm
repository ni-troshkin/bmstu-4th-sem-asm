global copyStr
section .text

copyStr:
    push rcx
    push rax

    mov rcx, rdx
    inc rcx

    cmp rsi, rdi
    je return
    jg copy
    
    mov rax, rdi
    sub rax, rsi
    cmp rax, rcx
    jge copy

reverse_copy:
    std
    add rdi, rcx
    add rsi, rcx
    dec rdi
    dec rsi

copy:
    rep movsb
    cld

return:
    pop rax
    pop rcx
    ret
