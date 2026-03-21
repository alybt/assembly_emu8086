; BITUN, ALELY PACIFICO    

TITLE Data Transfer Examples      (Moves.asm)

; emonstrates the MOV, MOVSX, MOVZX, and XCHG instructions.
; Reference: Kip Irvine, Assembly Language for x86 Processors, 6th Ed, p. 102.

INCLUDE Irvine32.inc

.data
val1 WORD 1000h
val2 WORD 2000h

.code
main PROC

    ; MOVZX (Move with Zero-Extend)
    ; Used for unsigned integers. Fills upper bits with zeros.
    mov   bx, 0A69Bh
    movzx eax, bx           ; EAX = 0000A69Bh
    movzx edx, bl           ; EDX = 0000009Bh
    movzx cx, bl            ; CX  = 009Bh

    ; MOVSX (Move with Sign-Extend)
    ; Used for signed integers. Fills upper bits with the sign bit.
    mov   bx, 0A69Bh
    movsx eax, bx           ; EAX = FFFFA69Bh (sign bit was 1)
    movsx edx, bl           ; EDX = FFFFFF9Bh
    movsx bl,  byte ptr [val1] ; Demonstration of memory to register

    ; LAHF and SAHF (Flags)
    ; Copies status flags to/from the AH register.
    lahf                    ; Load status flags into AH
    inc   ax                ; Modify AH or flags
    sahf                    ; Store AH back into status flags

    ; XCHG (Exchange) 
    ; Swaps the contents of two operands.
    mov  ax, val1           ; AX = 1000h
    xchg ax, val2           ; AX = 2000h, val2 = 1000h
    mov  val1, ax           ; val1 = 2000h

    call DumpRegs           ; Display register values for verification
    exit
main ENDP
END main