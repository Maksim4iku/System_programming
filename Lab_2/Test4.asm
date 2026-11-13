format ELF64

public _start
public exit
public print_symb

section '.data' writeable
  number dq 3363522457
  buffer db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
  buffer_len = $ - buffer
  newline db 10

section '.bss' writable
  place db 1

section '.text' executable
  _start:
    mov rax, [number]
    xor rbx, rbx
    mov rcx, 10

  .digit_loop:
    xor rdx, rdx
    div rcx
    add rbx, rdx
    test rax, rax
    jnz .digit_loop


    mov rax, rbx
    mov rdi, buffer
    add rdi, buffer_len - 1
    mov rcx, 10


    test rax, rax
    jnz .convert_loop
    mov byte [rdi], '0'
    mov rsi, rdi
    mov rdx, 1
    jmp .print_result

  .convert_loop:
    xor rdx, rdx
    div rcx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .convert_loop
    inc rdi
    mov rsi, rdi

    mov rdx, buffer
    add rdx, buffer_len - 1
    sub rdx, rsi
    inc rdx

  .print_result:
    push rsi
    push rdx
    mov eax, 4
    mov ebx, 1
    pop rdx
    pop rsi
    mov ecx, esi
    int 0x80

    mov al, [newline]
    call print_symb

    call exit

print_symb:
  push rax
  mov eax, 4
  mov ebx, 1
  pop rdx
  mov [place], dl
  mov ecx, place
  mov edx, 1
  int 0x80
  ret

exit:
  mov eax, 1
  mov ebx, 0
  int 0x80
