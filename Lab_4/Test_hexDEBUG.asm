format ELF64 executable 3
entry _start

segment readable writeable
    msg rb 32
    msghex rb 64
    buffer  rb 32
    bufferhex  rb 64
    newline db 10
    newlinehex rb 2

segment readable executable

_start:
    xor rax, rax
    xor rdi, rdi
    lea rsi, [msg]
    mov rdx, 32
    syscall

    lea rdi, [msg]
    call atoi
    mov r12, rax

    xor r13, r13
    mov r14, 1

.loop:
    cmp r14, r12
    jg  .done

    mov rax, r14
    imul rax, r14

    test r14, 1
    jz  .even
    add r13, rax
    jmp .next
.even:
    sub r13, rax

.next:
    inc r14
    jmp .loop

.done:
    mov rdi, r13
    call print_int

    mov eax, 1
    mov edi, 1
    lea rsi, [newline]
    mov edx, 1
    syscall

    mov eax, 60
    xor edi, edi
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
    push rbx
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
    pop rbx
    ret
