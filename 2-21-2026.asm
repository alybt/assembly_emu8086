; BITUN, ALELY PACIFICO BSCS 2A

org 100h


PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h
        POP     AX
        
ENDM 
     
     
     
.data   ; 1: read the given data for each variables
DB "0"
s1 DB "00000000", 0
sum DW 0
flag DB 0 

.code
CALL print ; 2: call the print
DB 0dh, 0ah, "8 bit binary: ", 0

MOV     DX, 9  ; 14:
LEA     DI, s1 ; 15: 
CALL    GET_STRING ; 16: CALL GET_STRING

MOV     CX, 8
MOV     SI, OFFSET s1

check_s:          ; check if the inputed was a binary number
        CMP     [SI], 0
        JNE     ok0
        MOV     flag, 1
        JMP     convert
    ok0:
        CMP     [SI], 'b'
        JNE     ok1
        MOV     flag, 1
        JMP     convert
    ok1: 
        CMP     [SI], 31h
        JMP     ok2
        JMP     error_invalid
    ok2: 
        INC     SI
    
    LOOP    check_s

    
convert:    ; as the check_s ended it will now convert the binary if it has one 
    MOV     BL, 1
    MOV     CX, SI 
    SUB     CX, OFFSET s1
    DEC     SI
    
JCXZ        stop_program

 
next_digit:
    MOV     AL, [SI]
    SUB     AL, 30h 
    MUL     BL
    ADD     SUM, AX
    SHL     BL, 1
    DEC     s1
    LOOP    next_digit

TEST    sum, 0000_0000_1000_0000b
JNZ     print_signed_unsigned


print_unsigned:
    CALL        print 
    DB          0dh, 0ah, "decimal: ", 0 
    MOV         AX, SUM
    CALL    PRINT_NUM_UNS
    JMP     stop_program

    
print_signed_unsigned:
    CALL    print
    DB      0dh, 0ah, "unsigned decimal: ", 0
    MOV     AX, SUM
    CALL    PRINT_NUM_UNS
    CALL    print
    DB      0dh, 0ah, "signed decimal: ", 0
    MOV     AX, SUM 
    CALL    PRINT_NUM
    JMP     stop_program

error_invalid: 
    CALL    print
    DB      0dh, 0ah, "error: only zeros and ones are allowed!", 0

stop_program: 
    CALL    print
    DB      0dh, 0ah, "press any key...", 0 
    MOV     AH, 0 
    INT     16h
    RET
    
GET_STRING  PROC    NEAR  ; CALLS TO GET THE INPUT OF THE USER
    PUSH    AX          ; 17:
    PUSH    CX          ;
    PUSH    DI          ;
    PUSH    DX          ;
    
MOV     CX, 0

CMP     DX, 1
JBE     empty_buffer

DEC     DX

wait_for_key:    ; read and wait for the input of the user 
    MOV     AH, 0 
    INT     16h 

CMP     AL, 13
JZ      exit

CMP     AL, 8
JNE     add_to_buffer
JCXZ    wait_for_key
DEC     CX
DEC     DI

PUTC    8
PUTC    ' '
PUTC    8

JMP     wait_for_key

add_to_buffer:      ; add a buffer to read all the input of the user
    CMP     CX, DX
    JAE     wait_for_key
    
    MOV     [DI], AL
    INC     DI 
    INC     CX 
    
    MOV     AH, 0eh
    INC     CX
    MOV     AH, 0eh
    INT     10h
JMP     wait_for_key

exit: 
    MOV     [DI], 0

empty_buffer:     ; if the input was empty it will end it 
POP     DX
POP     DI
POP     CX
POP     AX
GET_STRING ENDP   ; it will end the get string here 

PRINT_NUM   PROC    NEAR
    PUSH    DX
    PUSH    AX
    
    CMP     AX, 0
    JNZ     not_zero
    
    PUTC    '0'
    
    JMP     printed_pn 

not_zero:
    CMP     AX, 0
    JNS     positive
    NEG     AX 
    
    PUTC    '-'
    
positive: 
    CALL    PRINT_NUM_UNS 
    
printed_pn:
    POP     AX
    POP     DX
    RET
ENDP

PRINT_NUM_UNS   PROC NEAR
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    
    MOV     CX, 1
    MOV     BX, 10000
    
    CMP     AX, 0
    JZ      print_zero
    
begin_print: 
    CMP     BX, 0
    JZ      end_print
    
    CMP     CX, 0
    JE      calc
    CMP     AX, BX
    JB      skip
    
calc: 
    MOV     CX, 0
    
    MOV     DX, 0
    DIV     BX
    
    ADD     AL, 30h
    PUTC    AL
    
    MOV     AX, DX
    
skip: 
    PUSH    AX
    MOV     DX, 0
    MOV     AX, BX
    DIV     CS:ten
    MOV     BX, AX
    POP     AX
    
    JMP     begin_print
    
print_zero:
    PUTC    '0'

end_print:
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    RET


ten         DW 10
ENDP

print PROC  ; 3: || After the first print of the 8 bit now it will get the other needed to be printed   
    MOV     CS:temp1, SI ; 4: MOV THE SI TO CS Temp
    POP     SI           ; 5: POP THE VALUE OF SI
    PUSH    AX           ; 6: PUSH the AX

next_char:
    MOV     AL, CS:[SI]  ; 7: MOV THE CS VALUE TO AL
    INC     SI           ; 8: 
    CMP     AL, 0        ; 9: NULL
    JZ      printed_ok   ; 10: printed_ok
    MOV     AH, 0Eh      ; 11: 
    INT     10h          ; 12: 
    JMP     next_char    ; 13: Loop

printed_ok:              ; print 
    POP     AX
    PUSH    SI
    MOV     SI,CS:temp1
    RET

temp1 DW ?

ENDP


ret




