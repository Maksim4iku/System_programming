
exit:
    mov rax,1
    mov rbx,0
    int 0x80


print_str:
    push rax
    push rdi
    push rdx
    push rcx
    mov rax, rsi
    call len_str
    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    syscall
    pop rcx
    pop rdx
    pop rdi
    pop rax
    ret

new_line:
   push rax
   push rdi
   push rsi
   push rdx
   push rcx
   mov rax, 0xA
   push rax
   mov rdi, 1
   mov rsi, rsp
   mov rdx, 1
   mov rax, 1
   syscall
   pop rax
   pop rcx
   pop rdx
   pop rsi
   pop rdi
   pop rax
   ret

len_str:
  push rdx
  mov rdx, rax
  .iter:
  cmp byte [rax], 0
  je .next
  inc rax
  jmp .iter
  .next:
 sub rax, rdx
 pop rdx
 ret

str_number:
    push rcx
    push rbx

    xor rax,rax
    xor rcx,rcx
.loop:
    xor rbx, rbx
    mov bl, byte [rsi+rcx]
    cmp bl, 48
    jl .finished
    cmp bl, 57
    jg .finished

    sub bl, 48
    add rax, rbx
    mov rbx, 10
    mul rbx
    inc rcx
    jmp .loop

.finished:
    cmp rcx, 0
    je .restore
    mov rbx, 10
    div rbx

.restore:
    pop rbx
    pop rcx
    ret

number_str:
    push rbx
    push rdx
    push rsi
    push rdi

    test    rax, rax
    jnz .nonzero
    mov byte [rsi], '0'
    mov rcx, 1
    jmp .restore

.nonzero:
    sub rsp, 32
    mov rdi, rsp
    xor rcx, rcx
    mov rbx, 10

.divide_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi+rcx], dl
    inc rcx
    test    rax, rax
    jnz .divide_loop

    mov r8, rcx
    xor r9, r9
.reverse_loop:
    mov al, [rdi + r8 - 1]
    mov [rsi + r9], al
    dec r8
    inc r9
    cmp r8, 0
    jne .reverse_loop

    add rsp, 32

.restore:
    pop rdi
    pop rsi
    pop rdx
    pop rbx
    ret
