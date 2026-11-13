format elf64
public _start
include 'func.asm'

section '.data' writable
    path      db "/dev/urandom", 0
    err_open  db "open /dev/urandom failed", 0xA, 0
    err_read  db "read failed", 0xA, 0

section '.bss' writable
    number    rq 1           ; 8 случайных байт
    place     rb 32

section '.text' executable

_start:
    ;; --- open("/dev/urandom", O_RDONLY) ---
    mov rdi, path
    xor rsi, rsi             ; O_RDONLY = 0
    xor rdx, rdx
    mov rax, 2               ; sys_open
    syscall
    cmp rax, 0
    jl .open_error
    mov r8, rax              ; fd

    ;; --- read(fd, &number, 8) ---
    mov rdi, r8
    mov rsi, number
    mov rdx, 8               ; читаем 8 байт = qword
    xor rax, rax             ; sys_read
    syscall
    cmp rax, 8
    jne .read_error

    ;; --- close(fd) ---
    mov rdi, r8
    mov rax, 3
    syscall

    ;; --- печать числа ---
    mov rax, [number]
    mov rsi, place
    call number_str
    call print_str
    call new_line
    call exit

.open_error:
    mov rsi, err_open
    call print_str
    call exit

.read_error:
    ;; закрыть fd перед выходом
    mov rdi, r8
    mov rax, 3
    syscall
    mov rsi, err_read
    call print_str
    call exit
