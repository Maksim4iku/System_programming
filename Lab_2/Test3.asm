format ELF64

public _start
public exit
public print_symb

section '.data' writeable
  array db 'ddfbfdgdfvjipyuoerwqazxbhf'
  array_len = $ - array
  symbol db '!'
  newline db 10

section '.bss' writable
  matrix rb 45
  place db 1

section '.text' executable
  _start:
    mov rcx, 0
    mov rbx, matrix
    mov al, [symbol]
  .fill:
    mov al, [array+rcx]
    mov [rbx], al
    inc rbx
    inc rcx
    cmp rcx, array_len
    jbe .fill

    mov rsi, 0
    mov r8, 1

  .row_loop:
    mov r9, 0
  .col_loop:
    mov al, [matrix+rsi]
    call print_symb
    inc rsi
    inc r9
    cmp r9, r8
    jne .col_loop

    mov al, [newline]
    call print_symb
    inc r8
    cmp r8, 9
    jbe .row_loop

    call exit


print_symb:
  push rcx
  push rsi
  push r8
  push r9
  push rax
  mov eax, 4
  mov ebx, 1
  pop rdx
  mov [place], dl
  mov ecx, place
  mov edx, 1
  int 0x80
  pop r9
  pop r8
  pop rsi
  pop rcx
  ret

exit:
  mov eax, 1
  mov ebx, 0
  int 0x80
