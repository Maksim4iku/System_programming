format elf64
public _start

section '.data' writable
    read_buffer   rb 101
    write_buffer  rb 101
    input_name    dq 0
    output_name   dq 0
    step          dq 0
    counter       dq 0
    bytes_read    dq 0

section '.text' executable

_start:
    pop rcx
    cmp rcx, 4
    jl .l1

    mov rax, [rsp+8]
    mov [input_name], rax
    mov rax, [rsp+16]
    mov [output_name], rax

    mov rsi, [rsp+24]
    call parse_number
    mov [step], rax
    cmp rax, 0
    jle .l1

    mov rdi, [input_name]
    mov rax, 2
    mov rsi, 0
    xor rdx, rdx
    syscall
    cmp rax, 0
    jl .l1
    mov r8, rax


    mov rdi, [output_name]
    mov rax, 2
    mov rsi, 577
    mov rdx, 644o
    syscall
    cmp rax, 0
    jl .close_in_err
    mov r9, rax
.loop_read:
    mov rax, 0
    mov rdi, r8
    mov rsi, read_buffer
    mov rdx, 100
    syscall

    cmp rax, 0
    jle .flush_and_close

    mov [bytes_read], rax
    xor rbx, rbx
    xor r10, r10

.process_byte:
    cmp rbx, rax
    jge .write_block
    mov rcx, [counter]
    inc rcx
    mov [counter], rcx
    mov rax, rcx
    xor rdx, rdx
    div qword [step]
    test rdx, rdx
    jnz .skip_byte
    mov dl, [read_buffer + rbx]
    mov [write_buffer + r10], dl
    inc r10

.skip_byte:
    inc rbx
    mov rax, [bytes_read]
    jmp .process_byte

.write_block:
    test r10, r10
    jz .loop_read

    mov rax, 1
    mov rdi, r9
    mov rsi, write_buffer
    mov rdx, r10
    syscall

    jmp .loop_read

.flush_and_close:
    mov rdi, r8
    mov rax, 3
    syscall

    mov rdi, r9
    mov rax, 3
    syscall

    jmp .l1

.close_in_err:
    mov rdi, r8
    mov rax, 3
    syscall
    jmp .l1

.l1:
    call exit
parse_number:
    xor rax, rax
    xor rcx, rcx
.loop:
    movzx rcx, byte [rsi]
    cmp rcx, '0'
    jb .done
    cmp rcx, '9'
    ja .done
    imul rax, rax, 10
    sub rcx, '0'
    add rax, rcx
    inc rsi
    jmp .loop
.done:
    ret
exit:
    mov rax, 60
    xor rdi, rdi
    syscall
