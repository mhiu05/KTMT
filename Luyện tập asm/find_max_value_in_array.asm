.model small
.stack 100h
.data
    arr db 1,4,9,5,7,6,3,0,2,8
    msg db 10,13,"Max number in array is: $"
        
.code
MAIN proc
    mov ax, @data
    mov ds, ax
     
    cld
    mov cx, 9
    lea si, arr
    mov bl, [si] ;max = phan tu dau tien in array
    inc si
    
    START:
        lodsb
        
        cmp al, bl
        ;neu arr[i] <= max thi skip
        jle CONTINUE
        
        ;neu arr[i] > max
        mov bl, al ;max = arr[i]
        
    CONTINUE:
        loop START 
        
    ;in ra thong bao max number
    lea dx, msg
    mov ah, 9
    int 21h
      
    ;in ra max number
    mov dl, bl
    add dl, '0'
    mov ah, 2
    int 21h    
        
    ;return 0
    mov ah, 4ch
    int 21h                     
MAIN endp
END MAIN
