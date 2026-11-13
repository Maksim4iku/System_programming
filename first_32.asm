format ELF
public _start

msg1 db "Соловьев", 0xA
len1 = $ - msg1
msg2 db "Максим", 0xA
len2 = $ - msg2
msg3 db "Николаевич", 0xA, 0
len3 = $ - msg3
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, len1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, len2
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, len3
    int 0x80

    mov eax, 1
    mov ebx, 0
    int 0x80
