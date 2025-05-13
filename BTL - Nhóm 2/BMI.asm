include "emu8086.inc"
.model small
.stack 100h

.data
    a dw ? 
    b dw ? 
    x dw ?
    y dw ?
    
    nguyen dw ?
    du dw ?
    thapphan dw ?
    bminguyen dw ?
    bmithapphan dw ?
    
    batdau db 'BAM PHIM BAT KY DE BAT DAU$'
    khainiem1 db '(BMI(Body Mass Index) la chi so danh gia tinh trang suc khoe$'  
    khainiem2 db 'dua tren ti le giua can nang va chieu cao$'
    gt db '->BTL KTMT-Nhom 2<-$'
    
    cannang db 'Nhap vao can nang cua ban<kg>: $'
    chieucao db 'Nhap vao chieu cao cua ban<cm>: $'
    bmi db 'Chi so BMI cua ban la: $'
    
    tbthuacan db 'Ban dang thua can$'
    tbthieucan db 'Ban dang thieu can$'
    tbbinhthuong db 'Ban dang rat khoe manh$'
    
    
    tb5 db 'Nhan SPACE de tinh lai$'
    tb6 db 'Nhan ENTER de ket thuc$'
    
    bthg db 'Chi so cua ban binh thuong, tiep tuc duy tri!$'
    
    beophi1 db '1. Dieu chinh che do an.$'
    beophi2 db '2. Tap luyen the thao.$'
    beophi3 db '3. Nghi ngoi hop ly.$'
    
    gay1 db '1. Tang cuong an do nhieu calo.$'
    gay2 db '2. An nhieu thuc pham co protein nhu thit, ca, trung, sua.$'
    gay3 db '3. An nhieu bua nho trong ngay.$'

.code
main proc
    mov ax, @data
    mov ds, ax    

    ; xoa man hinh
    mov ah, 06h    
    xor al, al     
    xor cx, cx    
    mov dx, 184Fh  
    mov bh, 1Eh   
    int 10h 
    
    ; giao dien
    GOTOXY 10, 5  
    printn "===\ \   / ===   /== /=\ =   /== =  = =   /=\ === /=\ -==="
    GOTOXY 10, 6
    printn " I I I\ /I  I    I   I I I   I   I  I I   I I  I  I I  I I"
    GOTOXY 10, 7
    printn "=_=/ I I I  I    I   I-I I   I   I  I I   I-I  I  I I  II/"
    GOTOXY 10, 8
    printn " I I I   I  I    I   I I I   I   I  I I   I I  I  I I  I \"
    GOTOXY 10, 9
    printn "|==/ =   = ===   \== = = \== \== \==/ \== = =  =  \=/  = ="
    
    GOTOXY 26,15
    lea dx, batdau 
    mov ah,9
    int 21h 
    
    GOTOXY 30,21
    lea dx, gt
    mov ah, 9
    int 21h
    
    GOTOXY 10,18
    lea dx,khainiem1
    mov ah, 9
    int 21h 
    
    GOTOXY 19,19
    lea dx,khainiem2
    mov ah, 9
    int 21h
    
    GOTOXY 54,15
    mov dl, '>'
    mov ah, 2
    int 21h
    mov dl, '>'
    int 21h
    
    mov ah,1
    int 21h

chuongtrinh:

    ; xoa man hinh
    mov ah,06h
    xor al,al
    xor cx,cx
    mov dx,184fh
    mov bh,1eh
    int 10h 
    
    ; nhap can nang
    GOTOXY 7,5
    lea dx, cannang
    mov ah,9
    int 21h
    call nhapso
    mov x,ax
    
    ; nhap chieu cao
    GOTOXY 7,7
    lea dx, chieucao
    mov ah,9
    int 21h
    call nhapso
    mov y,ax

    ; tinh BMI = (can nang * 10000) / (chieu cao ^ 2)
    mov ax,y
    mul y
    mov cx,ax
     
    mov ax,x
    mov bx,10000
    mul bx
    div cx
    mov nguyen,ax
    mov du,dx
    
    ; xu ly phan thap phan
    mov ax,du
    mov bx,10
    mul bx
    div cx
    mov du,ax
    mov ax,dx 
    mul bx
    div cx
    cmp ax,5
    jg tang
    jmp skip

tang:
    inc du
    mov dx,du
    cmp dx,10
    je tang1
    jmp skip

tang1:
    mov du,0
    inc nguyen

skip:
    ; in ket qua
    GOTOXY 10,9
    lea dx, bmi
    mov ah,9
    int 21h
    
    mov ax,nguyen
    call inso
    
    mov dl,','
    mov ah,2
    int 21h
    
    mov ax,du
    call inso
    
    ; gan bien so sanh
    mov ax, nguyen
    mov bminguyen, ax
    mov ax, du
    mov bmithapphan, ax
    
    ; so sanh BMI
    mov ax, bminguyen
    cmp ax, 25 
    jge thuacan
    cmp ax, 18
    jl thieucan
    je bang
    jg binhthuong   
    
bang:
    cmp bmithapphan, 5
    jl thieucan
    jge binhthuong

binhthuong:
    GOTOXY 10,12
    mov ah, 9
    lea dx, tbbinhthuong
    int 21h 
    GOTOXY 10,14
    mov ah, 9
    lea dx,bthg
    int 21h
    GOTOXY 7,21
    mov ah, 9
    lea dx,tb5
    int 21h
    GOTOXY 49,21
    mov ah, 9
    lea dx,tb6
    int 21h
    
    mov ah,1
    int 21h
    cmp al,13
    je ketthuc
    cmp al,32
    je chuongtrinh     

thieucan:
    GOTOXY 10,12
    lea dx, tbthieucan
    mov ah,9
    int 21h 
    
    GOTOXY 10,14
    mov ah, 9 
    lea dx,gay1
    int 21h
    
    GOTOXY 10,16
    mov ah, 9
    lea dx,gay2
    int 21h
    
    GOTOXY 10,18
    mov ah, 9
    lea dx,gay3
    int 21h  
    
    GOTOXY 7,21
    mov ah, 9
    lea dx,tb5
    int 21h
    
    GOTOXY 49,21
    mov ah, 9
    lea dx,tb6
    int 21h
    
    mov ah,1
    int 21h
    cmp al,13
    je ketthuc
    cmp al,32
    je chuongtrinh   

thuacan:
    GOTOXY 10,12
    lea dx, tbthuacan
    mov ah,9
    int 21h
    
    GOTOXY 10,14 
    mov ah, 9
    lea dx,beophi1
    int 21h
    
    GOTOXY 10,16
    mov ah, 9
    lea dx,beophi2
    int 21h
    
    GOTOXY 10,18
    mov ah, 9
    lea dx,beophi3
    int 21h          
    
    GOTOXY 7,21
    mov ah, 9
    lea dx,tb5
    int 21h
    
    GOTOXY 49,21
    mov ah, 9
    lea dx,tb6
    int 21h
    
    mov ah,1
    int 21h
    cmp al,13
    je ketthuc
    cmp al,32
    je chuongtrinh

ketthuc:
    mov ah, 06h
    XOR al,al     
    XOR cx,cx    
    MOV dx, 184FH  
    MOV bh, 1Eh    
    INT 10h
    
    GOTOXY 23, 3
    printn "Cam on thay va cac ban da theo doi!"
    
    GOTOXY 11,6
    printn "Thanh vien"
    
    GOTOXY 33,6
    printn "**************"
    
    GOTOXY 59,6
    printn "Cong viec"
    
    GOTOXY 11,8
    printn "----------" 
    
    GOTOXY 60,8
    printn "-------"
    
    GOTOXY 5,10
    printn "DamChienThang-B23DCKH106"  
    
    GOTOXY 59,10
    printn "Giao dien"
    
    GOTOXY 5,13
    printn "BuiDuyHieu-B23DCCN296"  
    
    GOTOXY 56,13
    printn "Code thuat toan"
    
    GOTOXY 5,16
    printn "DaoHaMy-B23DCCN571"
    
    GOTOXY 55,16
    printn "Tong hop & Bao cao" 
    
    GOTOXY 30,21
    lea dx, gt
    mov ah, 9
    int 21h
    
    mov ah, 4ch
    int 21h
main endp

; === SUB PROGRAM ===
nhapso proc
    mov a, 0
    mov b, 0
    mov bx, 10

lap:
    mov ah, 08h    
    int 21h
    cmp al, 13
    je ket

    cmp al, '0'
    jb lap           
    cmp al, '9'
    ja lap           

    mov dl, al
    mov ah, 02h
    int 21h

    sub al, '0'
    mov ah, 0
    mov a, ax
    mov ax, b
    mul bx
    add ax, a
    mov b, ax

    jmp lap

ket:
    mov ax, b
    ret
nhapso endp


inso proc
    push ax
    push bx
    push cx
    push dx
    mov bx,10
    mov cx,0
lap1:
    mov dx,0
    div bx
    push dx 
    inc cx
    cmp ax,0
    jg lap1
cout:
    pop dx
    add dl,'0'
    mov ah,2
    int 21h
    loop cout
    pop dx
    pop cx
    pop bx
    pop ax
    ret
inso endp

end main
