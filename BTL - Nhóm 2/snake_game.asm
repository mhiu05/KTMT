.Model small 

.Stack 100H   

.Data
    ;main screen
    screen1  db "Game Team 2"
    screen2  db "In this game you must eat 4 letters by sequence:"
    screen3  db "First eat 'N' then 'A' then 'K' then 'E'"
    screen4  db "Move the snake by pressing the keys w,a,s,d"
    screen5  db "w: move up"
    screen6  db "s: move down"
    screen7  db "d: move right"
    screen8  db "a: move left"
    screen9  db "The snake head is the 'S' in the middle of the screen"
    screen10 db "Press any key to start..."
    about db "This game is done by: TEAM 2"   
    
    ;bild
    hlths  db "Lives:",3,3,3    
    
    ;ingame
    letadd  dw 09b4h,0848h,06b0h,01e8h,4 Dup(0)
    dletadd dw 09b4h,0848h,06b0h,01e8h,4 Dup(0)
    letnum  db 4
    fin  db 4
    hlth db 6 ;/2  
    
    ;snake infomation
    sadd dw 07d2h,5 Dup(0)
    snake db 'S',5 Dup(0)
    snake1 db 1
    
    ;end
    gmwin  db "You Win"
    gmov   db "Game Over"
    endtxt db "Press Esc to exit"

.Code
start:
    ;khoi tao ds  
    mov ax, @data    
    mov ds, ax ;tro thanh ghi ds ve dau doan data
    
    mov ax, 0b800h ; 0B800h l� v�ng nho video trong che do van ban (text mode) 80x25 cua DOS.
    mov es, ax    
    
    cld ;clear direction flag: DF = 0

    ; hide con tro chuot
    mov ah, 1    ; Set Cursor Shape
    mov ch, 2bh  ; Start Scan Line
    mov cl, 0bh  ; End Scan Line, ch > cl => hide con tro chuot
    int 10h      ; BIOS(Basic Input/Output System) video service

    call screen_menu ; print intro game: screen1 -> screen10      
    
    startag: ;start again
    
    call bild ; function display alphabet and border in game
    xor cl, cl
    
    read: ;read cac cach di chuyen
        mov ah, 1
        int 16h    ; check xem co phim nao duoc nhan chua
        jz s1      ; neu khong co thi jump den s1
        
        mov ah, 0  ; doc ki tu dem tu ban phim (lay ki tu vua nhan)
        int 16h    
        sub al, 20h; convert chu thuong -> chu hoa
        mov dl, al
        jmp s1
    
    s1:                
        cmp dl, 1bh  ; 1bh: phim esc
        je ext      ; neu nhan esc -> thoat
        jmp right
    
    right:    
        cmp dl, 'D' ;di chuyen sang phai
        jne left
        call move_right
        mov cl, dl
        jmp read ;nhay sang doc cach di chuyen tiep theo
    
    left: ;di chuyen trai
        cmp dl, 'A'
        jne up
        call move_left ;goi ham di chuyen sang trai
        mov cl, dl
        jmp read ;nhay sang doc cach di chuyen tiep theo
    
    up: ;di chuyen len
        cmp dl, 'W'
        jne down
        call move_up ;goi ham di chuyen len tren
        mov cl, dl
        jmp read ;nhay sang doc cach di chuyen tiep theo
    
    down: ;di chuyen xuong
        cmp dl, 'S'
        jne read1
        call move_down ;goi ham di chuyen xuong duoi
        mov cl, dl
        jmp read ;nhay sang doc cach di chuyen tiep theo  
        
    read1:
        mov dl, cl
        jmp read
        
    ext:
        xor cx,cx
        mov dh, 24
        mov dl, 79
        mov bh, 7
        mov ax, 700h
        int 10h  
        
    ;return 0
    mov ax,4ch ; exit to operating system.
    int 21h
ends 

screen_menu proc    ;ham in khung hinh tu screen1 den screen10
    call border   ;ham xac dinh gioi han duong di cua snake
    
    mov di, 186h
    lea si, screen1  ; chuyen noi dung screen1 vao thanh ghi si
    mov cx, 11     ; lap 11 lan
    lapscr1:
        movsb         ; [di] <- [si], sau d� si++, di++ (move string binary)
        inc di        ; di++, byte ki tu va byte mau
    loop lapscr1 
        
    mov di, 33Eh
    lea si, screen2  ;chuyen noi dung screen2 vao thanh ghi si
    mov cx, 48
    lapscr2:
        movsb
        inc di
    loop lapscr2
    
    mov di, 3DEh
    lea si, screen3  ;chuyen noi dung screen3 vao thanh ghi si
    mov cx, 40
    lapscr3:
        movsb
        inc di
    loop lapscr3 
    
    mov di, 47Eh
    lea si, screen4  ;chuyen noi dung screen4 vao thanh ghi si
    mov cx, 43
    lapscr4:
        movsb
        inc di
    loop lapscr4  
    
    mov di, 5DCh
    lea si, screen5  ;chuyen noi dung screen5 vao thanh ghi si
    mov cx, 10
    lapscr5:
        movsb
        inc di
    loop lapscr5  
    
    mov di, 67Ch
    lea si, screen6  ;chuyen noi dung screen6 vao thanh ghi si
    mov cx, 12
    lapscr6:
        movsb
        inc di
    loop lapscr6  

    mov di, 71Ch
    lea si, screen7  ;chuyen noi dung screen7 vao thanh ghi si
    mov cx, 13
    lapscr7:
        movsb
        inc di
    loop lapscr7  
    
    mov di, 7BCh
    lea si, screen8  ;chuyen noi dung screen8 vao thanh ghi si
    mov cx, 12
    lapscr8:
        movsb
        inc di
    loop lapscr8
    
    mov di, 8DEh
    lea si, about  ;chuyen noi dung about vao thanh ghi si
    mov cx, 28
    lapabout: 
        movsb
        inc di
    loop lapabout 

    mov di, 97Eh
    lea si, screen9  ;chuyen noi dung screen9 vao thanh ghi si
    mov cx, 53
    lapscr9: 
        movsb
        inc di
    loop lapscr9

    mov di, 0B5Eh
    lea si, screen10 ;chuyen noi dung screen10 vao thanh ghi si
    mov cx, 25
    lapscr10:
        movsb
        inc di
    loop lapscr10
    
    ;Press any key to start
    mov ah, 7     
    int 21h

    call clear_all   
    ret
screen_menu endp

; Game screen
bild proc           ; function display alphabet and border in game
    call border     ;ham xac dinh gioi han duong di cua snake 
    
    ;display hlths: lives
    lea si, hlths
    mov di, 0
    mov cx, 9  
    lap1:   
        movsb
        inc di
    loop lap1
    
    ;display screen1: game team 2
    lea si, screen1
    mov di, 088h
    mov cx, 11
    lap2:
    	movsb
        inc di
    loop lap2
    
    ;display snake and alphabet
    xor dx, dx      ; mov dx, 0
    mov di, sadd    ; dia chi bat dau ran
    mov dl, snake   ; ki tu dai dien ran: 'D'
    ;es: extra segment (es: 0b800h)
    es: mov [di],dl     ; vi tri snake init
    es: mov [09b4h], 'N' ; vi tri cac chu cai tren screen
    es: mov [0848h], 'A' ; offset = (y * 80 + x) * 2
    es: mov [06b0h], 'K'
    es: mov [01E8h], 'E'
    ret
bild endp

; snake move:
move_left proc
    push dx
    call replace_address   ; goi ham thay doi dia chi
    sub sadd,2

    call eat           ; goi ham eat va xu ly so nang

    call move_snake    ; goi ham di chuyen cua snake
    pop dx
    ret
move_left endp

move_right proc
    push dx
    call replace_address ; goi ham thay doi dia chi
    add sadd,2

    call eat           ; goi ham eat va xu ly so nang

    call move_snake    ; goi ham di chuyen cua snake
    pop dx
    ret
move_right endp

move_up proc
    push dx
    call replace_address   ; goi ham thay doi dia chi
    sub sadd,160        ; 160 = 80 * 2 

    call eat           ; goi ham eat va xu ly so nang

    call move_snake    ; goi ham di chuyen cua snake
    pop dx
    ret
move_up endp

move_down proc
    push dx
    call replace_address ; goi ham thay doi dia chi
    add sadd, 160
		 
    call eat         ;goi ham eat va xu ly so nang
    call move_snake  ;goi ham di chuyen cua snake
    pop dx
    ret
move_down endp

replace_address proc   ;ham thay doi dia chi
    push ax
    xor ch, ch
    xor bh, bh
    mov cl, snake1     ; cl: do dai cua ran hien tai
    inc cl             ;++cl v� can 1 o cho dau moi
    mov al, 2
    mul cl
    mov bl, al                      

    xor dx,dx
    shiftsnake:
        mov dx, sadd[bx-2]
        mov sadd[bx], dx
        sub bx, 2
    loop shiftsnake:
    pop ax
    ret
replace_address endp

eat proc ;ham eat va xu ly so mang
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov di, sadd
    es: cmp [di], 0
    je no
    es: cmp [di], 20h  ; so sanh voi space - tuong
    je wall

    xor ch, ch
    mov cl, letnum   ;cl: so luong chu cai con lai (letnum)
    xor si, si       ;si = 0 (de duyet mang letnum)

    lop:
        cmp di, letadd[si] ;so sanh di voi vi tri chu cai thu si
        je addf     ; neu trung thi jmp den addf (an moi)
        add si, 2   ;si += 2 (moi phan tu letnum la word)
        loop lop    ;lap den khi cl = 0
        jmp wall
    
    addf:
        ; X�a chu c�i da an
        mov letadd[si], 0
    
        ; Luu k� tu v�o snake[]
        xor bh, bh
        mov bl, snake1 ; do dai hien tai cua ran
        es: mov dl, [di]  ;ky tu tai vi tri di (chu cai an duoc)
        mov snake[bx], dl ;luu ky tu vao mang snake
    
        ; X�a tr�n m�n h�nh (neu can)
        es: mov [di], 0
    
        ; tang do dai ran v� giam so chu cai con lai    
        add snake1, 1
        sub fin, 1
    
        cmp fin, 0  ; kiem tra xem con moi khong
        je chkletters
        jmp no
    
    wall:
        cmp di, 320    ;kiem tra xem co cham bien tren khong (dong 1)
        jbe wallk
        cmp di, 3840   ;kiem tra xem co cham bien duoi khong (dong 24)
        jae wallk
        
        ;kiem tra cham bien trai, phai
        mov ax, di
        mov bl, 160 ;160 byte/dong (80 cot * 2 byte)   
        div bl      ; ax/bl -> ah = so du (vi tri cot)   
        cmp ah, 0   ; bien trai
        jz wallk
        
        mov ax, di
        add ax, 2
        mov bl, 160
        div bl    
        cmp ah, 0 ;bien phai
        je wallk    
        jmp no
    
    wallk:
        ;giam mang song
        xor bh, bh
        mov bl, hlth
        es: mov [bx+10], 0 ;xoa hien thi mang song tren man hinh
        mov hlths[bx+2], 0 ; cap nhat gia tri trong mang hlths
        sub hlth, 2       ;giam mang song di 1 (moi mang bang 2 byte)
        cmp hlth, 0       ;kiem tra con mang khong
        jne rest           ;neu con -> restart
    
        ; Game over
        pop ax
        pop bx
        pop cx
        pop dx
        pop si
        pop di
        call game_over
    
    rest:
        pop ax
        pop bx
        pop cx
        pop dx
        pop si
        pop di
        call restart
    
    no:
        pop ax
        pop bx
        pop cx
        pop dx
        pop si
        pop di
    ret
eat endp


move_snake proc ;ham di chuyen snake
    xor ch, ch
    xor si, si
    xor dl, dl
    mov cl, snake1
    xor bx, bx
    l1mr:
        mov di, sadd[si] ;di: vi tri doan ran thu si (tu mang sadd)
        mov dl, snake[bx];dl: ky tu doan ran thu bx (tu mang snake)
        es: mov [di], dl ;ghi ki tu len man hinh tai vi tri di
        add si, 2
        inc bx
    loop l1mr
    mov di, sadd[si]
    es:mov [di],0
    ret
move_snake endp

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
    xor ch, ch
    xor si, si
    mov cl, snake1
    inc cl
    delt:
        mov di, sadd[si]
        es:mov [di],0
        add si,2
    loop delt
    
    mov fin, 4
    
    mov sadd, 07D2h
    mov cl, snake1
    inc cl
    xor si, si
    inc si
    xor di, di
    add di, 2
    emptsn:
        mov snake[si], 0
        mov sadd[di], 0
        add di, 2
        inc si
    loop emptsn
    mov snake1, 1
    
    xor ch, ch
    mov cl, letnum
    xor si, si
    reslet:
        mov bx, dletadd[si]
        mov letadd[si], bx
        add si, 2
        add bx, 2
    loop reslet
    xor si, si
    mov snake[si], 'D'
    
    jmp startag ;nhay ve chuong trinh read cach di chuyen va tao khung ban dau
    ret    
restart endp

chkletters proc 
    call move_snake ;cap nhat vi tri ran tren man hinh
    
    cmp snake[1],'N'
    jne endtest1   
    cmp snake[2],'A'
    jne endtest1
    cmp snake[3],'K'
    jne endtest1
    cmp snake[4],'E'
    jne endtest1
    call win  
    
    endtest1:
        xor bh, bh
        mov bl, hlth
        es: mov [bx+10], 0
        mov hlths[bx+2], 0
        sub hlth, 2
        cmp hlth, 0
        jne restc
        call game_over   
        
    restc:
        call restart 
    ret
chkletters endp

win proc 
    call clear_all 
    call border 
    
    ;in ra: "You Win"
    mov di, 7cah
    lea si, gmwin
    mov cx, 7
    lope1w:
        movsb
        inc di
    loop lope1w
    
    ;in ra: "Press Esc to exit"
    mov di, 862h
    lea si, endtxt
    mov cx, 17  
    lope2:
        movsb
        inc di
    loop lope2
    
    qwer1:
        mov ah, 7   ;nhap 1 ki tu khong echo
        int 21h
        cmp al, 1bh
        je ext
        jmp qwer1    
    ret
win endp   

game_over proc 
    call clear_all 
    call border
    
    ;in "Game Over"
    mov di, 7c8h
    lea si, gmov
    mov cx, 9
    lope1:
        movsb
        inc di
    loop lope1
    
    ;in "Press Esc to exit"
    mov di, 862h
    lea si, endtxt
    mov cx, 17
    lope2w:
        movsb
        inc di
    loop lope2w
    
    qwer:
        mov ah, 7
        int 21h
        cmp al, 1bh
        je ext
        jmp qwer
    ret
game_over endp

clear_all proc ;ham xoa noi dung man hinh van ban 
    xor cx, cx   ;row start = 0, col start = 0
    mov dh, 24   ;row end = 24
    mov dl, 79   ;col end = 79
    mov bh, 7    ;while(text) on black(background)
    mov ax, 700h ; ah = 07h (scroll), al = 00h (clear)
    int 10h    
    ret
clear_all endp 

end start 