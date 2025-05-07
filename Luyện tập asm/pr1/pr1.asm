.Model small

.Stack 100H

.Data
    x db ?
    a db 4
    b db 3
    c db 2
    d db 1
    t dw ?
    ans db 13,10,'your anwser is: $' 
.Code
MAIN Proc
    mov ax, @data
    mov ds, ax
    
    ;nhap x va convert to digit
    mov ah, 1
    int 21h
    sub al, '0'
    mov x, al
    
    ;f(x) = ax^3 - bx^2 - cx + d
    mov al, a
    mul x         ; ax
    sub al, b     ; ax - b
    mul x         ; ax^2 - bx
    sub al, c     ; ax^2 - bx - c
    mul x         ; ax^3 - bx^2 - cx
    add al, d     ; ax^3 - bx^2 - cx + d
    mov t, ax
    add t, '0'    ; convert to string
    
    ;in ra "your anwser is: "
    mov ah, 9
    lea dx, ans
    int 21h
    
    mov ah, 2
    mov dx, t
    int 21h
END MAIN
    

