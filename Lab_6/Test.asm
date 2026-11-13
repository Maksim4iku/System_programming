format ELF64

public _start

extrn initscr
extrn start_color
extrn init_pair
extrn getmaxx
extrn getmaxy
extrn raw
extrn noecho
extrn keypad
extrn stdscr
extrn move
extrn getch
extrn addch
extrn refresh
extrn endwin
extrn exit
extrn timeout
extrn mydelay
extrn curs_set

section '.bss' writable
    xmax      dq 1
    ymax      dq 1
    palette   dq 1
    speed     dq 1
    left      dq 0
    top       dq 0
    right     dq 0
    bottom    dq 0
    pos_x     dq 0
    pos_y     dq 0

section '.text' executable

_start:
    call initscr
    call start_color
    call noecho
    call raw

    xor rdi, rdi
    call curs_set

    mov rdi, 1
    mov rsi, 1
    mov rdx, 1
    call init_pair

    mov rdi, 2
    mov rsi, 0
    mov rdx, 0
    call init_pair

    mov rdi, [stdscr]
    call getmaxx
    dec rax
    mov [xmax], rax

    mov rdi, [stdscr]
    call getmaxy
    dec rax
    mov [ymax], rax

    mov rdi, [stdscr]
    mov rsi, 1
    call keypad

    mov qword [speed], 30000
    mov qword [palette], 1

main_loop:
    mov qword [left], 0
    mov qword [top], 0
    mov rax, [xmax]
    mov [right], rax
    mov rax, [ymax]
    mov [bottom], rax

    call draw_spiral

    cmp qword [palette], 1
    jne .set_red
    mov qword [palette], 2
    jmp main_loop
.set_red:
    mov qword [palette], 1
    jmp main_loop
draw_spiral:
.down_check:
    mov rax, [top]
    cmp rax, [bottom]
    jg .done

    mov rax, [top]
    mov [pos_y], rax
.down_loop:
    mov rdi, [pos_y]
    mov rsi, [left]
    call put_cell
    inc qword [pos_y]
    mov rax, [pos_y]
    cmp rax, [bottom]
    jle .down_loop
.right_check:
    mov rax, [left]
    inc rax
    cmp rax, [right]
    jg .done

    mov rax, [left]
    inc rax
    mov [pos_x], rax
.right_loop:
    mov rdi, [bottom]
    mov rsi, [pos_x]
    call put_cell
    inc qword [pos_x]
    mov rax, [pos_x]
    cmp rax, [right]
    jle .right_loop

.up_check:
    mov rax, [bottom]
    dec rax
    cmp rax, [top]
    jl .done

    mov rax, [bottom]
    dec rax
    mov [pos_y], rax
.up_loop:
    mov rdi, [pos_y]
    mov rsi, [right]
    call put_cell
    dec qword [pos_y]
    mov rax, [pos_y]
    cmp rax, [top]
    jge .up_loop

.left_check:
    mov rax, [right]
    dec rax
    cmp rax, [left]
    jle .done

    mov rax, [right]
    dec rax
    mov [pos_x], rax
.left_loop:
    mov rdi, [top]
    mov rsi, [pos_x]
    call put_cell
    dec qword [pos_x]
    mov rax, [pos_x]
    cmp rax, [left]
    jg .left_loop

    inc qword [left]
    inc qword [top]
    dec qword [right]
    dec qword [bottom]

    jmp .down_check

.done:
    ret
put_cell:
    call move

    cmp qword [palette], 1
    jne .color2
    mov eax, ' '
    or  eax, 0x100
    mov rdi, rax
    jmp .draw
.color2:
    mov eax, ' '
    or  eax, 0x200
    mov rdi, rax

.draw:
    call addch
    call refresh

    mov rdi, 10
    call timeout
    call getch

    cmp eax, 'l'
    je .quit

    cmp eax, 'p'
    jne .do_delay

    mov rax, [speed]
    cmp rax, 1000
    jle .reset_speed
    xor rdx, rdx
    mov rcx, 2
    mul rcx
    xor rdx, rdx
    mov rcx, 3
    div rcx
    mov [speed], rax
    jmp .do_delay

.reset_speed:
    mov qword [speed], 30000

.do_delay:
    mov rdi, [speed]
    cmp rdi, 0
    je .skip
    call mydelay
.skip:
    ret

.quit:
    call endwin
    mov rdi, 0
    call exit
