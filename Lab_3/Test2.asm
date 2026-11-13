format ELF64

buffer      rb 32
newline     db 10
usage       db "Usage: ./expr a b c", 10
usage_len   = $ - usage
msg_div0    db "Error: division by zero", 10
msg_div0_len = $ - msg_div0

public _start

_start:
    mov rax, [rsp]
    cmp rax, 4
    jl  .error

    mov rdi, [rsp + 16]
    call atoi
    mov r12, rax

    mov rdi, [rsp + 24]
    call atoi
    mov r13, rax

    mov rdi, [rsp + 32]
    call atoi
    mov r14, rax

    test r14, r14
    jz   .div_zero

    mov rax, r12
    sub rax, r14
    imul rax, r13
    cqo
    idiv r14
    imul rax, r12

    mov rdi, rax
    call print_int

    mov eax, 1
    mov edi, 1
    lea rsi, [newline]
    mov edx, 1
    syscall

    mov eax, 60
    xor edi, edi
    syscall

.div_zero:
    mov eax, 1
    mov edi, 1
    lea rsi, [msg_div0]
    mov edx, msg_div0_len
    syscall
    mov eax, 60
    mov edi, 1
    syscall

.error:
    mov eax, 1
    mov edi, 1
    lea rsi, [usage]
    mov edx, usage_len
    syscall
    mov eax, 60
    mov edi, 1
    syscall

atoi:
    xor rax, rax
    xor rcx, rcx

    movzx edx, byte [rdi]
    cmp dl, '-'
    jne .loop
    mov rcx, 1
    inc rdi

.loop:
    movzx edx, byte [rdi]
    cmp dl, '0'
    jb  .done
    cmp dl, '9'
    ja  .done

    imul rax, rax, 10
    sub dl, '0'
    movzx edx, dl
    add rax, rdx
    inc rdi
    jmp .loop

.done:
    test rcx, rcx
    jz  .ret
    neg rax
.ret:
    ret
print_int:
    mov rax, rdi
    lea rsi, [buffer + 31]
    mov byte [rsi], 0
    dec rsi

    xor r8, r8
    test rax, rax
    jns .convert
    mov r8, 1
    neg rax

.convert:
    mov ebx, 10
.loop_div:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test eax, eax
    jnz .loop_div
    test r8, r8
    jz  .write
    mov byte [rsi], '-'
    dec rsi

.write:
    inc rsi
    mov rdx, buffer + 31
    sub rdx, rsi
    mov eax, 1
    mov edi, 1
    syscall
    ret
