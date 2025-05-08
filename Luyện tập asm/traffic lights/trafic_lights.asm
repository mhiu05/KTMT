.model small
.stack 100h
.data
    ;     FEDC BA9 876 543 210
    ;     0000 GYR GYR GYR GYR
    R1 dw 0000001100001100B  ; dèn doc: xanh (100) - ngang: do (001)
    R2 dw 0000001010001010B  ; dèn doc: vàng (010) - ngang: do (001)
    R3 dw 0000100001100001B  ; dèn doc: do (001) - ngang: xanh (100)
    R4 dw 0000010001010001B  ; dèn doc: do (001) - ngang: vàng (010)
    
    ALL_RED equ 0000001001001001B
    PORT equ 4 ;output port
    
    ;hang so thoi gian (s)
    ;3s = 3,000,000 micro sec = 002D C6C0H
    Wait_3_Sec_Cx equ 2Dh
    Wait_3_Sec_Dx equ 0C6C0h
    
    ;10s = 10,000,000 micro sec = 0098 9680h
    Wait_10_Sec_Cx equ 98h
    Wait_10_Sec_Dx equ 9680h  
        
.code
    waitMacro macro t1, t2
        mov cx, t1
        mov dx, t2
        mov ah, 86h
        int 15h
    endm 
    
MAIN proc
    mov ax, @data
    mov ds, ax
     
    cld
    
    ; Set lights to Red for all direction
    mov ax, ALL_RED
    out PORT, ax
    waitMacro Wait_3_Sec_Cx, Wait_3_Sec_Dx
    
    START:
        ;den xanh chieu doc, den do chieu ngang
        lea si, R1
        mov ax, [si]
        out PORT, ax
        waitMacro Wait_10_Sec_Cx, Wait_10_Sec_Dx
        
        ;den vang chieu doc, den do chieu nang
        lea si, R2
        mov ax, [si]
        out PORT, ax
        waitMacro Wait_3_Sec_Cx, Wait_3_Sec_Dx
        
        ;den do chieu doc, den xanh chieu ngang
        lea si, R3
        mov ax, [si]
        out PORT, ax
        waitMacro Wait_10_Sec_Cx, Wait_10_Sec_Dx 
        
        ;den do chieu doc, den vang chieu ngang
        lea si, R4
        mov ax, [si]
        out PORT, ax
        waitMacro Wait_3_Sec_Cx, Wait_3_Sec_Dx
        jmp START
    
    ;return 0
    mov ah, 4ch
    int 21h                     
MAIN endp   
END MAIN
