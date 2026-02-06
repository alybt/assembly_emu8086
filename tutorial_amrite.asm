.model small
.stack 100H

; Data segment
.data   ; if there is nothing in the data segment, you can omit this line.

; Code segment
.code

main PROC
    ; Write your code here

    exit:
    MOV AH, 4CH
    INT 21H
    main ENDP
END main
