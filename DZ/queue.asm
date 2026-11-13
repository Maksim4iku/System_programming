format elf64

public queue_init
public queue_push
public queue_pop
public queue_fill_random
public queue_get_odds
public queue_count_ending_1
public queue_count_primes

section '.data' writable
    urandom_path db "/dev/urandom", 0

section '.bss' writable
    q_begin  rq 1
    q_end    rq 1
    q_head   rq 1
    q_tail   rq 1
    q_cap    rq 1
    q_size   rq 1
    rand_fd  rq 1

section '.text' executable

urandom_open:
    mov rdi, urandom_path
    xor rsi, rsi
    xor rdx, rdx
    mov rax, 2
    syscall
    cmp rax, 0
    jl .fail
    mov [rand_fd], rax
    mov rax, 1
    ret
.fail:
    xor rax, rax
    ret

urandom_close:
    mov rdi, [rand_fd]
    mov rax, 3
    syscall
    ret

urandom_u64:
    sub rsp, 16
    mov rdi, [rand_fd]
    mov rsi, rsp
    mov rdx, 8
    xor rax, rax
    syscall
    cmp rax, 8
    jne .bad
    mov rax, [rsp]
    add rsp, 16
    ret
.bad:
    xor rax, rax
    add rsp, 16
    ret

queue_init:
    push rbx
    mov [q_cap], rdi
    mov qword [q_head], 0
    mov qword [q_tail], 0
    mov qword [q_size], 0

    call urandom_open
    test rax, rax
    jz .fail

    xor rdi, rdi
    mov rax, 12
    syscall
    cmp rax, 0
    jl .fail_close
    mov [q_begin], rax
    mov [q_end], rax

    mov rdi, [q_cap]
    shl rdi, 3
    add rdi, [q_begin]
    mov rax, 12
    syscall
    cmp rax, 0
    jl .fail_close
    mov [q_end], rax

    mov rax, 1
    pop rbx
    ret

.fail_close:
    call urandom_close
.fail:
    xor rax, rax
    pop rbx
    ret

queue_push:
    mov rax, [q_size]
    cmp rax, [q_cap]
    jae .full

    mov rcx, [q_tail]
    mov rdx, [q_begin]
    lea rdx, [rdx + rcx*8]
    mov [rdx], rdi

    inc rcx
    cmp rcx, [q_cap]
    jb .no_wrap
    xor rcx, rcx
.no_wrap:
    mov [q_tail], rcx
    inc qword [q_size]
    mov rax, 1
    ret
.full:
    xor rax, rax
    ret

queue_pop:
    mov rax, [q_size]
    test rax, rax
    jz .empty

    mov rcx, [q_head]
    mov rdx, [q_begin]
    lea rdx, [rdx + rcx*8]
    mov r8, [rdx]
    mov [rdi], r8

    inc rcx
    cmp rcx, [q_cap]
    jb .no_wrap
    xor rcx, rcx
.no_wrap:
    mov [q_head], rcx
    dec qword [q_size]
    mov rax, 1
    ret
.empty:
    xor rax, rax
    ret

queue_fill_random:
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi
    mov r13, rsi
    xor r14, r14

    test r13, r13
    jz .done

.loop:
    cmp r14, r12
    jae .done

    mov rax, [q_size]
    cmp rax, [q_cap]
    jae .done

    call urandom_u64
    xor rdx, rdx
    mov rcx, r13
    div rcx
    mov rdi, rdx
    call queue_push
    test rax, rax
    jz .done
    inc r14
    jmp .loop

.done:
    mov rax, r14
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

queue_get_odds:
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r12, rdi
    mov r13, rsi
    xor r14, r14
    xor r15, r15
    mov rbx, [q_size]

.loop:
    cmp r15, rbx
    jae .done
    cmp r14, r13
    jae .done

    mov rax, [q_head]
    add rax, r15
    xor rdx, rdx
    mov rcx, [q_cap]
    div rcx

    mov rax, [q_begin]
    lea rax, [rax + rdx*8]
    mov rax, [rax]

    test rax, 1
    jz .next
    mov [r12 + r14*8], rax
    inc r14
.next:
    inc r15
    jmp .loop

.done:
    mov rax, r14
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

queue_count_ending_1:
    push rbx
    push r12
    push r13

    xor r12, r12
    xor r13, r13
    mov rbx, [q_size]

.loop:
    cmp r13, rbx
    jae .done

    mov rax, [q_head]
    add rax, r13
    xor rdx, rdx
    mov rcx, [q_cap]
    div rcx

    mov rax, [q_begin]
    lea rax, [rax + rdx*8]
    mov rax, [rax]

    mov rcx, 10
    xor rdx, rdx
    div rcx
    cmp rdx, 1
    jne .next
    inc r12
.next:
    inc r13
    jmp .loop

.done:
    mov rax, r12
    pop r13
    pop r12
    pop rbx
    ret

is_prime:
    mov rax, rdi
    cmp rax, 2
    jl .no
    je .yes
    test rax, 1
    jz .no
    mov rcx, 3
.loop:
    mov r8, rcx
    imul r8, rcx
    cmp r8, rax
    ja .yes
    mov r8, rax
    xor rdx, rdx
    div rcx
    test rdx, rdx
    jz .no
    mov rax, rdi
    add rcx, 2
    jmp .loop
.yes:
    mov rax, 1
    ret
.no:
    xor rax, rax
    ret

queue_count_primes:
    push rbx
    push r12
    push r13

    xor r12, r12
    xor r13, r13
    mov rbx, [q_size]

.loop:
    cmp r13, rbx
    jae .done

    mov rax, [q_head]
    add rax, r13
    xor rdx, rdx
    mov rcx, [q_cap]
    div rcx

    mov rax, [q_begin]
    lea rax, [rax + rdx*8]
    mov rdi, [rax]
    call is_prime
    add r12, rax
    inc r13
    jmp .loop

.done:
    mov rax, r12
    pop r13
    pop r12
    pop rbx
    ret
