format ELF64

public _start
public exit
public print_symb

section '.data' writeable
  array db 'ddfbfdgdfvjipyuoerwqazxbhf'
  array_len = $ - array

section '.bss' writable
  place db 1

section '.text' executable
  _start:
    mov rcx, array_len
    .iter:
       mov al, [array+rcx-1]
       call print_symb
       loop .iter
    call exit

print_symb:
  push rcx
  push rax
  mov eax, 4
  mov ebx, 1
  pop rdx
  mov [place], dl
  mov ecx, place
  mov edx, 1
  int 0x80
  pop rcx
  ret

exit:
  mov eax, 1
  mov ebx, 0
  int 0x80
