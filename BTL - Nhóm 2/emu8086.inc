; emu8086.inc - macro definitions library for easy input/output


; this macro prints a string that is given as a parameter, example:
; PRINTN 'hello world!'
; the same as PRINT, but new line is automatically added.
PRINTN   MACRO   sdat
    LOCAL   next_char, s_dcl, printed, skip_dcl

    PUSH    AX      ; store registers...
    PUSH    SI      ;

    JMP     skip_dcl        ; skip declaration.
            s_dcl DB sdat, 13, 10, 0

    skip_dcl:
            LEA     SI, s_dcl
            
    next_char:      
            MOV     AL, CS:[SI]
            CMP     AL, 0
            JZ      printed
            INC     SI
            MOV     AH, 0Eh ; teletype function.
            INT     10h
            JMP     next_char
    printed:

    POP     SI      ; re-store registers...
    POP     AX      ;
ENDM

; sets current cursor
; position:
GOTOXY  MACRO   col, row
        PUSH    AX
        PUSH    BX
        PUSH    DX
        MOV     AH, 02h
        MOV     DH, row
        MOV     DL, col
        MOV     BH, 0
        INT     10h
        POP     DX
        POP     BX
        POP     AX
ENDM

