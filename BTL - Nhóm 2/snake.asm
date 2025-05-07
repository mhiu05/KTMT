.Model small 

.Stack 100H   

.Data
    ;mainmenu
    main1  db "Game Team 2"
    main2  db "In this game you must eat 4 letters by sequence:"
    main3  db "First eat 'T' then 'E' then 'A' then 'M'"
    main4  db "Move the snake by pressing the keys w,a,s,d"
    main5  db "w: move up"
    main6  db "s: move down"
    main7  db "d: move right"
    main8  db "a: move left"
    main9  db "The snake head is the 'D' in the middle of the screen"
    main10 db "Press any key to start..."
    about db "This game is done by: TEAM 2"   
    
    ;bild
    hlths  db "Lives:",3,3,3    
    
    ;ingame
    letadd  dw 09b4h,0848h,06b0h,01e8h,4 Dup(0)
    dletadd dw 09b4h,0848h,06b0h,01e8h,4 Dup(0)
    letnum  db 4
    fin  db 4
    hich db 6 ;/2  
    
    ;snake infomation
    sadd dw 07d2h,5 Dup(0)
    snake db 'D',5 Dup(0)
    snake1 db 1
    
    ;end
    gmwin  db "You Win"
    gmov   db "Game Over"
    endtxt db "Press Esc to exit"
    
    ;any
    endline db 13, 10, '$' 

.Code
start:  
    mov ax, data    
    mov ds, ax
    
    mov ax, 0b800h
    mov es, ax    
    
    cld ;clear direction flag

    ; hide con tro chuot
    mov ah, 1
    mov ch, 2bh
    mov cl, 0bh
    int 10h

    call main_menu ; goi ham in khung hinh tu main1 -> main10      
    
    startag: ;read cac cach di chuyen va tao khung ban dau
    
    call bild ; goi ham de dat chu cai va duong vien 
    xor cl, cl
    read: ;read cac cach di chuyen
    mov ah,1
    int 16h    
    jz s1
    mov ah,0
    int 16h
    and al,0dfh
    mov dl,al
    jmp s1
    
    s1:
    cmp dl,1bh
    je ext
    
    cmp dl,'D' ;di chuyen sang phai
    jne left
    call mr
    mov cl,dl
    jmp read ;nhay sang doc cach di chuyen tiep theo
    
    left: ;di chuyen trai
    cmp dl,'A'
    jne up
    call ml ;goi ham di chuyen sang trai
    mov cl,dl
    jmp read ;nhay sang doc cach di chuyen tiep theo
    
    up: ;di chuyen len
    cmp dl,'W'
    jne down
    call mu ;goi ham di chuyen len tren
    mov cl,dl
    jmp read ;nhay sang doc cach di chuyen tiep theo
    
    down: ;di chuyen xuong
    cmp dl,'S'
    jne read1
    call md ;goi ham di chuyen xuong duoi
    mov cl,dl
    jmp read ;nhay sang doc cach di chuyen tiep theo
    read1:
    mov dl,cl
    jmp read
   
    
    ext:
    xor cx,cx
    mov dh,24
    mov dl,79
    mov bh,7
    mov ax,700h
    int 10h
    mov ax,4c00h ; exit to operating system.
    int 21h
ends 

main_menu proc   ;ham in khung hinh tu main1 den main10
    call border  ;ham xac dinh gioi han duong di cua snake
    
    mov di,186h
    lea si,main1 ; chuyen noi dung main1 vao thanh ghi si
    mov cx,11
    lapmain1:
    movsb        ; [di] <- [si], sau d� si++, di++ (move string binary)
    inc di       ; di++, byte ki tu va byte mau
    loop lapmain1 
        
    mov di,33Eh
    lea si,main2 ;chuyen noi dung main2 vao thanh ghi si
    mov cx,48
    lapmain2:
    movsb
    inc di
    loop lapmain2
    
    mov di,3DEh
    lea si,main3 ;chuyen noi dung main3 vao thanh ghi si
    mov cx,40
    lapmain3:
    movsb
    inc di
    loop lapmain3 
    
    mov di,47Eh
    lea si,main4 ;chuyen noi dung main4 vao thanh ghi si
    mov cx,43
    lapmain4:
    movsb
    inc di
    loop lapmain4  
    
    mov di,5DCh
    lea si,main5 ;chuyen noi dung main5 vao thanh ghi si
    mov cx,9
    lapmain5:
    movsb
    inc di
    loop lapmain5  
    
    mov di,67Ch
    lea si,main6 ;chuyen noi dung main6 vao thanh ghi si
    mov cx,11
    lapmain6:
    movsb
    inc di
    loop lapmain6  

    mov di,71Ch
    lea si,main7 ; chuyen noi dung main7 vao thanh ghi si
    mov cx,12
    lapmain7:
    movsb
    inc di
    loop lapmain7  
    
    mov di,7BCh
    lea si,main8 ; chuyen noi dung main8 vao thanh ghi si
    mov cx,11
    lapmain8:
    movsb
    inc di
    loop lapmain8
    
    mov di,8DEh
    lea si,about ;chuyen noi dung about vao thanh ghi si
    mov cx,28
    lapabout: 
    movsb
    inc di
    loop lapabout 

    mov di,97Eh
    lea si,main9        ; chuyen noi dung main9 vao thanh ghi si
    mov cx,53
    lapmain9: 
    movsb
    inc di
    loop lapmain9

    mov di,0B5Eh
    lea si,main10       ; chuyen noi dung main10 vao thanh ghi si
    mov cx,25
    lapmain10:
    movsb
    inc di
    loop lapmain10

    mov ah,7
    int 21h

    call clear_all       ; goi ham de xoa tao noi
    ret
main_menu endp

; Game screen
bild proc        ; ham de dat chu cai va ve duong vien
; start point
    call border     ; ham xac dinh gioi han duong di cua snake

    lea si,hlths
    mov di,0
    mov cx,9 
		 
    loph:   
    movsb
    inc di
    loop loph

    lea si,main1
    mov di,088h
    mov cx,11
    loph1:
	movsb
    inc di
    loop loph1

    xor dx,dx
    mov di,sadd
    mov dl,snake
    es:     mov [di],dl     ; tri cac chu cai tren screen
    es:     mov [0944h],'T'
    es:     mov [0948h],'E'
    es:     mov [0606h],'A'
    es:     mov [01E8h],'M'
ret
endp

; snake move:
; left: di chuyen sang trai
ml proc
    push dx
    call shift_addrs   ; goi ham thay doi dia chi
    sub sadd,2

    call eat           ; goi ham eat va xu ly so nang

    call move_snake    ; goi ham di chuyen cua snake
    pop dx
ret
endp

; right:  di chuyen sang phai
mr proc
    push dx
    call shift_addrs   ; goi ham thay doi dia chi
    add sadd,2

    call eat           ; goi ham eat va xu ly so nang

    call move_snake    ; goi ham di chuyen cua snake
    pop dx

ret
endp

; up:  di chuyen len tren
mu proc
    push dx
    call shift_addrs   ; goi ham thay doi dia chi
    sub sadd,160

    call eat           ; goi ham eat va xu ly so nang

    call move_snake    ; goi ham di chuyen cua snake
    pop dx
ret
endp

; down: di chuyen xuong duoi 
md proc
    push dx
    call shift_addrs   ; goi ham thay doi dia chi
    sub sadd,160
		 
    call eat         ;goi ham eat va xu ly so nang
    call move_snake  ;goi ham di chuyen cua snake
    pop dx
ret
endp

shift_addrs proc        ;ham thay doi dia chi
    push ax
    xor ch, ch
    xor bh, bh
    mov cl, snake1
    inc cl
    mov al, 2
    mul cl
    mov bl, al

    xor dx,dx
    shiftsnake:
    mov dx,sadd[bx-2]
    mov sadd[bx],dx
    sub bx,2
    loop shiftsnake:
    pop ax
ret
endp

eat proc ;ham eat va xu ly so mang
    push ax
    push cx 
		 
    mov di,sadd
    es: cmp [di],0
    jz no
    es: cmp [di],20h
    jz wall
    xor ch,ch
    mov cl,letnum
    xor si,si
    lop:    
	cmp di,letadd[si]
    jz addf
    add si,2
    loop lop
    jmp wall
    addf:   
	mov letadd[si],0
    xor bh,bh
    mov bl,snake1
    es: mov dl,[di]
    mov snake[bx],dl
    es: mov [di],0
    add snake1,1
    sub fin,1
    cmp fin,0
    jz chkletters   ; ham xu ly an chu cai
    jmp no
    wall:   
    cmp di,320
    jbe wallk
    cmp di,3840
    jae wallk
    mov ax,di
    xor bh,bh
    mov bl,160
    div bl
    cmp ah,0
    jz wallk
    mov ax,di
    xor bh,bh
    mov bl,160
    div bl
    cmp ah,0
    jz wallk
    jmp no
    wallk:  
    xor bh,bh
    mov bl,hlths
    es: mov [bx+10],0
    mov hlths[bx+2],0
    sub hlths,2
    cmp hlths,0
    jnz rest   
    pop cx
    pop ax
    call game_over ;goi ham xu ly xu neu thua
    rest:
    pop cx
    pop ax
    call restart ;goi ham khoi dong lai game sau khi mat 1 mang
    
    no:
    pop cx
    pop ax
ret
endp

move_snake proc ;ham di chuyen snake
    xor ch,ch
    xor si,si
    xor dl,dl
    mov cl,snake1
    xor bx,bx
    l1mr:
    mov di,sadd[si]
    mov dl,snake[bx]
    es: mov [di],dl
    add si,2
    inc bx
    loop l1mr
    mov di,sadd[si]
    es:mov [di],0
ret
endp

border proc ; ham x�c dinh gioi han duong di cua snake
    mov ah, 0    ; Chuc nang "Set Video Mode" (Thiet lap che do man hinh)
    mov al, 3    ; Che do 3: 80x25 text mode voi 16 mau
    int 10h    
    
    mov ah, 6      ; Chuc nang cuon m�n h�nh l�n (Scroll Up Window)
    mov al, 0      ; So d�ng cuon (0 = x�a to�n bo v�ng chon)
    mov bh, 0FFh   ; M�u nen (0FFh = mau trang)
    
    ; Vien tren
    mov ch, 1      ; D�ng bat dau (y1 = 1)
    mov cl, 0      ; Cot bat dau (x1 = 0)
    mov dh, 1      ; D�ng ket th�c (y2 = 1)
    mov dl, 80     ; Cot ket th�c (x2 = 80)
    int 10h 

    ; Vien duoi
    mov ch, 24
    mov cl, 0
    mov dh, 24
    mov dl, 79
    int 10h

    ; Vien trai
    mov ch, 1
    mov cl, 0
    mov dh, 24
    mov dl, 0
    int 10h

    ; Vien phai
    mov ch, 1
    mov cl, 79
    mov dh, 24
    mov dl, 79
    int 10h 
    ret
border endp      

restart proc ;ham khoi dong lai game sau khi mat 1 mang
    xor ch,ch
    xor si,si
    mov cl,snake1
    inc cl
    delt:
    mov di,sadd[si]
    es:mov [di],0
    add si,2
    loop delt
    
    mov fin,4
    
    mov sadd,07D2h
    mov cl,snake1
    inc cl
    xor si,si
    inc si
    xor di,di
    add di,2
    emptsn:
    mov snake[si],0
    mov sadd[di],0
    add di,2
    inc si
    loop emptsn
    mov snake1,1
    
    xor ch,ch
    mov cl,letnum
    xor si,si
    reslet:
    mov bx,dletadd[si]
    mov letadd[si],bx
    add si,2
    add bx,2
    loop reslet
    xor si,si
    mov snake[si],'D'
    
    jmp startag ;nhay ve chuong trinh read cach di chuyen va tao khung ban dau
ret    
endp

chkletters proc ;ham an chu cai
    call move_snake ;goi ham di chuyen snake
    
    cmp snake[1],'T'
    jnz endtestl
    cmp snake[2],'E'
    jnz endtestl
    cmp snake[3],'A'
    jnz endtestl
    cmp snake[4],'M'
    jnz endtestl
    call win
    endtestl:
    xor bh,bh
    mov bl,hlths
    es: mov [bx+10],0
    mov hlths[bx+2],0
    sub hlths,2
    cmp hlths,0
    jnz restc
    call game_over ;goi ham xu ly neu thua
    restc:
    call restart ;goi ham khoi dong lai game khi mat mot mang
ret
endp

win proc ;ham xu ly neu win
    call clearall ;goi ham xoa tao moi
    call border ;goi ham goi han duong di
    
    mov di,7cah
    lea si,gmwin
    mov cx,7
    lope1w:
    movsb
    inc di
    loop lope1w
    
    mov di,862h
    lea si,endtxt
    mov cx,17
    lope2:
    movsb
    inc di
    loop lope2
    
    qwer1:
    mov ah,7
    int 21h
    cmp al,1bh
    jz ext
    jmp qwer1    
ret
endp
game_over proc ;ham xu ly neu thua
    call clearall ;goi ham xoa tao moi
    call border ;goi ham gioi han duong di
    
    mov di,7c8h
    lea si,gmov
    mov cx,9
    lope1:
    movsb
    inc di
    loop lope1
    
    mov di,862h
    lea si,endtxt
    mov cx,17
    lope2w:
    movsb
    inc di
    loop lope2w
    
    qwer:
    mov ah,7
    int 21h
    cmp al,1bh
    jz ext
    jmp qwer
ret
endp

clear_all proc ;ham xoa tao moi
    
    xor cx,cx
    mov dh,24
    mov dl,79
    mov bh,7
    mov ax,700h
    int 10h    
    ret
clear_all endp 

end start 
