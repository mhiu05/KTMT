.model small
.stack 100h
.data
    ;source string
    msg1 db 10,13,"chuoi ban dau la: $"
    str1 db 'h','1','i','E', '@', 'u'
         db 10,13,'$'
    ;destination string
    msg2 db 10,13,"chuoi sau khi bien doi la: $"
    str2 db 6 dup(?)
         db '$'
.code
MAIN proc
    mov ax, @data
    mov ds, ax
    mov es, ax
    
    ;si -> str1, di -> str2
    lea si, str1
    lea di, str2
    cld  
    mov cx, 6 ;str 1 co 6 ki tu
    
    START:
        lodsb ;load string byte, [ds:si] -> al, si++ (neu direction flag = 0)
        
        ;neu khong la chu thuong thi skip
        cmp al, 'a'
        jl NotLowerCase
        cmp al, 'z'
        jg NotLowerCase
        
        ;neu la chu thuong thi convert to in hoa
        sub al, 20h
        
    NotLowerCase:
        stosb ;store string byte, al -> [es:di], di++ (neu direction flag = 0)
        
        loop START
        jmp PRINT
        
    PRINT:    
        ;in ra source string
        lea dx, msg1
        mov ah, 9
        int 21h
        
        lea dx, str1
        mov ah, 9
        int 21h
        
        ;in ra destionation string
        lea dx, msg2
        mov ah, 9
        int 21h
        
        lea dx, str2
        mov ah, 9
        int 21h
        
    ;return 0
    mov ah, 4ch
    int 21h                     
MAIN endp
END MAIN
