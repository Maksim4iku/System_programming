format ELF64 executable 3
entry _start
segment readable writeable
    buffer  rb 32
    newline db 10
    dash    db " - "
    usage   db "Usage: ./ascii_code <single_character>", 10
    usage_len = $ - usage

segment readable executable
_start:
    mov rax, [rsp]
    cmp rax, 2
    jl  .error

    mov rsi, [rsp + 16]
    movzx eax, byte [rsi]
    test eax, eax
    jz   .error

    mov r8d, eax
    mov r9, rsi

    mov eax, 1
    mov edi, 1
    mov rsi, r9
    mov edx, 1
    syscall

    mov eax, 1
    mov edi, 1
    lea rsi, [dash]
    mov edx, 3
    syscall

    mov eax, r8d
    lea rdi, [buffer + 31]
    mov byte [rdi], 0
    dec rdi

    mov ebx, 10
.convert:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test eax, eax
    jnz .convert

    inc rdi

    mov rdx, buffer + 31
    sub rdx, rdi
    mov rsi, rdi
    mov edi, 1
    mov eax, 1
    syscall
    mov eax, 1
    mov edi, 1
    lea rsi, [newline]
    mov edx, 1
    syscall
    mov eax, 60
    xor edi, edi
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
