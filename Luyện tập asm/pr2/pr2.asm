.Model small
.Stack 100H

.Data
    tu dw ? 
    mau dw ?
    x dw ?
    a dw 1
    b dw 2
    c dw 1
    d dw 2
    f dw ?
    ans db 13,10,'your answer is: $'
    error db 13,10,'ERROR: denominator is equal to zero$'
    negsign db '-$'
.Code
MAIN Proc
    mov ax, @data                   
    mov ds, ax
    
    ; Nhap x va convert to digit
    mov ah, 1
    int 21h
    mov ah, 0
    sub al, '0'
    mov x, ax  
    
    ; Tu so
    mov ax, x
    imul a       
    add ax, b                   
    mov tu, ax
    
    ; Mau so
    mov ax, x
    imul c         
    sub ax, d
    mov mau, ax
    
    cmp mau, 0
    je CASE_ERROR
    

    mov ax, tu
    cwd             ; Mo rong dau AX -> DX:AX
    idiv mau        ; Chia có dau
    mov f, ax
    
    ; In tieu de
    mov ah, 9
    lea dx, ans
    int 21h
    
    ; Kiem tra am
    cmp f, 0
    jge positive
    
    ; In dam am (neu can)
    mov ah, 9
    lea dx, negsign
    int 21h
    neg f           ; doi sang dau duong de xu ly
    
    positive:
    mov ax, f
    add al, '0'  ; convert to string
    mov dl, al
    mov ah, 2
    int 21h
    
    jmp EXIT
    
    CASE_ERROR:
        lea dx,error
        mov ah, 9
        int 21h   
    
    EXIT:
        mov ah, 4ch
        int 21h
END MAIN