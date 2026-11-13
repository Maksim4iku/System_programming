format ELF64
public _start

msg1 db "Соловьев", 0xA
len1 = $ - msg1
msg2 db "Максим", 0xA
len2 = $ - msg2
msg3 db "Николаевич", 0xA, 0
len3 = $ - msg3
_start:
    mov rax, 4
    mov rbx, 1
    mov rcx, msg1
    mov rdx, len1
    int 0x80

    mov rax, 4
    mov rbx, 1
    mov rcx, msg2
    mov rdx, len2
    int 0x80

    mov rax, 4
    mov rbx, 1
    mov rcx, msg3
    mov rdx, len3
    int 0x80

    mov rax, 1
    mov rbx, 0
    int 0x80
