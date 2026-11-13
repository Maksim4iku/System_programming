format ELF64
public _start

section '.data' writable
    hex_digits db '0123456789ABCDEF'
    filename    db 'out.txt', 0
section '.bss' writable
    fd rd 1
    msg rb 32
    msghex rb 64
    buffer  rb 32
    bufferhex  rb 64
    newline db 10
    newlinehex rb 2
section '.text' executable

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
    mov eax, 2
    lea rdi, [filename]
    mov esi, 0x241
    mov edx, 0644o
    syscall
    mov [fd], eax
    lea rdi, [msg]
    lea rsi, [msghex]
    mov rdx, 32
    call to_hex
    mov eax, 1
    mov edi, [fd]
    lea rsi, [msghex]
    mov edx, 64
    syscall
    mov eax, 1
    mov edi, [fd]
    lea rsi, [newline]
    mov edx, 1
    syscall
    lea rdi, [buffer]
    lea rsi, [bufferhex]
    mov rdx, 32
    call to_hex

    mov eax, 1
    mov edi, [fd]
    lea rsi, [bufferhex]
    mov edx, 64
    syscall
    mov eax, 1
    mov edi, [fd]
    lea rsi, [newline]
    mov edx, 1
    syscall

    lea rdi, [newline]
    lea rsi, [newlinehex]
    mov rdx, 1
    call to_hex

    mov eax, 1
    mov edi, [fd]
    lea rsi, [newlinehex]
    mov edx, 2
    syscall
    mov eax, 1
    mov edi, [fd]
    lea rsi, [newline]
    mov edx, 1
    syscall
    mov eax, 3
    mov edi, [fd]
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
to_hex:
    push rbx
    push r12
    lea rbx, [hex_digits]
    mov r12, rdx
    xor rcx, rcx
.loop:
    cmp rcx, r12
    jae .done
    movzx eax, byte [rdi + rcx]
    mov edx, eax
    shr eax, 4
    and edx, 0x0F
    mov al, [rbx + rax]
    mov [rsi], al
    mov dl, [rbx + rdx]
    mov [rsi + 1], dl
    add rsi, 2
    inc rcx
    jmp .loop
.done:
    pop r12
    pop rbx
    ret
