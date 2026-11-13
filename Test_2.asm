format ELF64
public _start

include "func.asm"

section '.bss' writable
    buffer rb 32
    step dq 0

section '.text' executable

_start:
    pop rcx
    cmp rcx, 2
    jl .usage

    mov rsi, [rsp+8]
    call str_number
    mov [step], rax
    mov r9, 1
    xor r10, r10
    xor r8, r8

.loop:
    add r10, r9
    imul r9, r9, 10
    inc r9
    inc r8
    cmp r8, [step]
    jle .loop
    mov rax, r10
    lea rsi, [buffer]
    call number_str
    call print_str
    call new_line
    call exit

.usage:
    call exit
