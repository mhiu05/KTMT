include "emu8086.inc"
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
    snake_address dw 07d2h,5 Dup(0)
    snake db 'S',5 Dup(0)
    snake_len db 1
    
    ;end
    gmwin  db "You Win"
    gmov   db "Game Over"
    endtxt db "Press Esc to exit"

.Code
start:
    ;khoi tao ds  
    mov ax, @data    
    mov ds, ax ;tro thanh ghi ds ve dau doan data
    
    mov ax, 0b800h ; 0B800h là vùng nho video trong che do van ban (text mode) 80x25 cua DOS.
    mov es, ax    
    
    cld ;clear direction flag: DF = 0

    call screen_menu ;print main screen: screen1 -> screen10      
    
    startag: ;start again
    
    call bild ;function display alphabet and border in game
    
    read: ;read cac cach di chuyen
        mov ah, 1
        int 16h       ;check xem co phim nao duoc nhan chua
        jz right      ;neu khong co thi jump den right
        
        mov ah, 0     ;doc ki tu dem tu ban phim (lay ki tu vua nhan)
        int 16h    
        sub al, 20h   ;convert chu thuong -> chu hoa
        mov dl, al
        jmp right
    
    right:    
        cmp dl, 'D'    ;di chuyen sang phai
        jne left
        call move_right
        jmp read       ;nhay sang read cach di chuyen tiep theo
    
    left: 
        cmp dl, 'A'
        jne up
        call move_left 
        jmp read 
    
    up: 
        cmp dl, 'W'
        jne down
        call move_up
        jmp read 
    
    down: 
        cmp dl, 'S'
        jne read
        call move_down
        jmp read  
    
    exit:
        call clear_all
        
    ;return 0
    mov ax, 4ch ; exit to operating system.
    int 21h
ends 

screen_menu proc    ;ham in khung hinh tu screen1 den screen10
    call border   
    
    ;in "Game Team 2"
    mov di, 186h     ; 186h = 390 = 160 * 2 + 35 * 2 (dong 2, cot 35)
    lea si, screen1  ; load effective address
    mov cx, 11     ; lap 11 lan
    lapscr1:
        movsb         ; [di] <- [si], sau dó si++, di++ (move string binary)
        inc di        ; di++, byte ki tu va byte color
    loop lapscr1 
    
    ;in screen2    
    mov di, 33Eh
    lea si, screen2  
    mov cx, 48
    lapscr2:
        movsb
        inc di
    loop lapscr2
    
    ;in screen3
    mov di, 3DEh
    lea si, screen3 
    mov cx, 40
    lapscr3:
        movsb
        inc di
    loop lapscr3 
    
    ;in screen4
    mov di, 47Eh
    lea si, screen4 
    mov cx, 43
    lapscr4:
        movsb
        inc di
    loop lapscr4  
    
    ;in screen5
    mov di, 5DCh
    lea si, screen5  
    mov cx, 10
    lapscr5:
        movsb
        inc di
    loop lapscr5  
    
    ;in screen6
    mov di, 67Ch
    lea si, screen6 
    mov cx, 12
    lapscr6:
        movsb
        inc di
    loop lapscr6  
    
    ;in screen7
    mov di, 71Ch
    lea si, screen7 
    mov cx, 13
    lapscr7:
        movsb
        inc di
    loop lapscr7  
    
    ;in screen8
    mov di, 7BCh
    lea si, screen8  
    mov cx, 12
    lapscr8:
        movsb
        inc di
    loop lapscr8
    
    ;in about
    mov di, 8DEh
    lea si, about  
    mov cx, 28
    lapabout: 
        movsb
        inc di
    loop lapabout 
    
    ;in screen9
    mov di, 97Eh
    lea si, screen9  
    mov cx, 53
    lapscr9: 
        movsb
        inc di
    loop lapscr9
    
    ;in screen10
    mov di, 0B5Eh
    lea si, screen10 
    mov cx, 25
    lapscr10:
        movsb
        inc di
    loop lapscr10
    
    ;Press any key to start
    mov ah, 7     
    int 21h
    
    ;xoa man hinh hien tai
    call clear_all   
    ret
screen_menu endp

; Game screen
bild proc           ;function display alphabet and border in game
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
    xor dx, dx   
    mov di, snake_address    ; dia chi bat dau ran
    mov dl, snake            ; ki tu dai dien ran: 'S'
    ;es: extra segment (es: 0b800h)
    es: mov [di],dl          ; vi tri snake init
    es: mov [09b4h], 'N'     ; vi tri cac chu cai tren screen
    es: mov [0848h], 'A'   
    es: mov [06b0h], 'K'
    es: mov [01E8h], 'E'
    ret
bild endp

; snake move:
move_left proc
    push dx
    call replace_address   ; goi ham thay doi dia chi
    sub snake_address, 2
    call eat           ; goi ham eat va xu ly so nang
    call move_snake    ; goi ham di chuyen cua snake
    pop dx
    ret
move_left endp

move_right proc
    push dx
    call replace_address 
    add snake_address, 2
    call eat         
    call move_snake   
    pop dx
    ret
move_right endp

move_up proc
    push dx
    call replace_address   
    sub snake_address, 160      
    call eat          
    call move_snake   
    pop dx
    ret
move_up endp

move_down proc
    push dx
    call replace_address 
    add snake_address, 160		 
    call eat         
    call move_snake  
    pop dx
    ret
move_down endp

replace_address proc   ;ham thay doi dia chi
    push ax
    xor ch, ch
    xor bh, bh
    mov cl, snake1     ; cl: do dai cua ran hien tai
    inc cl             ;++cl vì can 1 o cho dau moi
    mov al, 2
    mul cl
    mov bl, al                      

    xor dx,dx
    shiftsnake:
        mov dx, snake_address[bx-2]
        mov snake_address[bx], dx
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

    mov di, snake_address
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
        ; Xóa chu cái da an
        mov letadd[si], 0
    
        ; Luu ký tu vào snake[]
        xor bh, bh
        mov bl, snake1 ; do dai hien tai cua ran
        es: mov dl, [di]  ;ky tu tai vi tri di (chu cai an duoc)
        mov snake[bx], dl ;luu ky tu vao mang snake
    
        ; Xóa trên màn hình (neu can)
        es: mov [di], 0
    
        ; tang do dai ran và giam so chu cai con lai    
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
        mov di, snake_address[si] ;di: vi tri doan ran thu si (tu mang sadd)
        mov dl, snake[bx];dl: ky tu doan ran thu bx (tu mang snake)
        es: mov [di], dl ;ghi ki tu len man hinh tai vi tri di
        add si, 2
        inc bx
    loop l1mr
    mov di, snake_address[si]
    es:mov [di],0
    ret
move_snake endp

border proc ; ham xác dinh gioi han duong di cua snake
    mov ah, 0    ; Chuc nang "Set Video Mode" (Thiet lap che do man hinh)
    mov al, 3    ; Che do 3: 80x25 text mode voi 16 mau
    int 10h         
    
    mov ah, 6      ; Chuc nang cuon màn hình lên (Scroll Up Window)
    mov al, 0      ; So dòng cuon (0 = xóa toàn bo vùng chon)
    mov bh, 0FFh   ; Màu nen (0FFh = mau trang)
    
    ; Vien tren
    mov ch, 1      ; Dòng bat dau (y1 = 1)
    mov cl, 0      ; Cot bat dau (x1 = 0)
    mov dh, 1      ; Dòng ket thúc (y2 = 1)
    mov dl, 80     ; Cot ket thúc (x2 = 80)
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
        mov di, snake_address[si]
        es:mov [di],0
        add si,2
    loop delt
    
    mov fin, 4
    
    mov snake_address, 07D2h
    mov cl, snake1
    inc cl
    xor si, si
    inc si
    xor di, di
    add di, 2
    emptsn:
        mov snake[si], 0
        mov snake_address[di], 0
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
    mov snake[si], 'S'
    
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
    for11:
        movsb
        inc di
    loop for11
    
    ;in ra: "Press Esc to exit"
    mov di, 862h
    lea si, endtxt
    mov cx, 17  
    for12:
        movsb
        inc di
    loop for12
    
    quit_win:
        mov ah, 7   ;nhap 1 ki tu khong echo
        int 21h
        cmp al, 1bh ; cmp al, esc
        je exit
        jmp quit_win   
    ret
win endp   

game_over proc 
    call clear_all 
    call border
    
    ;in "Game Over"
    mov di, 7c8h
    lea si, gmov
    mov cx, 9
    for1:
        movsb
        inc di
    loop for1
    
    ;in "Press Esc to exit"
    mov di, 862h
    lea si, endtxt
    mov cx, 17
    for2:
        movsb
        inc di
    loop for2
    
    quit_lose:
        mov ah, 7
        int 21h
        cmp al, 1bh
        je exit
        jmp quit_lose
    ret
game_over endp

clear_all proc ;ham xoa noi dung man hinh van ban 
    xor cx, cx   ;row start = 0, col start = 0
    mov dh, 24   ;row end = 24
    mov dl, 79   ;col end = 79
    mov bh, 7    ;white(text) on black(background)
    mov ax, 700h ;ah = 07h (scroll), al = 00h (clear)
    int 10h    
    ret
clear_all endp 

end start 