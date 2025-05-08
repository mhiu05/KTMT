.model small
.stack 100h
.data
    LIST_COUNT equ 7
    list db 1,4,0,3,7,2,8
    CRLF db 13,10,'$'
    msg1 db "day so ban dau la: $" 
    msg2 db 10,13,"day so sap xep tang dan la: $"
        
.code
MAIN proc
    mov ax, @data
    mov ds, ax
     
    cld
    
    ;in thong bao 1 
    lea dx, msg1
    mov ah, 9
    int 21h
    
    ;in list chua sap xep
    mov cx, LIST_COUNT
    lea si, list
    call PrintList
    
    ;in thong bao 2
    lea dx, msg2
    mov ah, 9
    int 21h 
    
    lea si, list
    mov bl, 1  ; bien dem
    
    MainLoop:
        mov al, [si]
        mov di, si
        mov bh, bl ;bien dem phu
        mov dx, di ;dx luu vi tri cua gia tri min
    SubLoop:
        inc di
        inc bh
        cmp al, [di]
        jle NotMin
        mov al, [di]
        mov dx, di
    Notmin:
        cmp bh, LIST_COUNT
        je ExitSub
        jmp SubLoop
    ExitSub:
        ;hoan doi vi tri neu min khac voi vi tri dau tien
        mov di, dx
        cmp si, di
        je NoSwap
        call SWAP
    NoSwap:
        inc bl
        cmp bl, LIST_COUNT
        je ExitMain
        inc si
        jmp MainLoop             
    ExitMain:  
        mov cx, LIST_COUNT
        lea si, list
        call PrintList
     
    ;return 0
    mov ah, 4ch
    int 21h                     
MAIN endp

;input: si luu dia chi bat dau cua list
;       cx luu so luong phan tu cua list
PrintList proc 
    push dx
    StartPrint:
        mov dl, [si]
        call PrintSingleDigital
        inc si
        loop StartPrint
    pop dx
    ret
PrintList endp

;input: dl chua ki tu so can in
PrintSingleDigital proc
    push ax
    add dl, '0'
    mov ah, 2
    int 21h
    pop ax
    ret
PrintSingleDigital endp  

;input: si tro toi vi tri thu nhat
;       di tro toi vi tri thu hai
SWAP proc
    push ax
    mov al, [si]
    mov ah, [di]
    mov [si], ah
    mov [di], al
    pop ax
    ret
SWAP endp    

END MAIN
