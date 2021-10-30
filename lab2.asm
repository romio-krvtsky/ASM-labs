.model small
.stack 100h

.data
    a dw ?
    b dw ?
    c dw ?
    d dw ?
    error1massage db " - error! OVERFLOW",'$'
    error2massage db " - error! DIVISION BY 0", '$'
    inputMassage db "enter number: ",'$'
    ouputMassage db "result: ",'$'
    string db 10 dup('$')
.code
start:  
        mov ax,@data
        mov ds,ax

        ;input of numbers 
        call InputNumber
        mov a,ax        
        call InputNumber
        mov b,ax
        call InputNumber
        mov c,ax
        call InputNumber
        mov d,ax

        mov ax,c
        mov cx,ax
        mul cx
        mul cx     ; ax = c^3
        jc lError 

        mov bx,a
        mov cx,b
        and bx,cx ; bx = a AND b

        cmp ax,bx ; check a AND b == c^3
        jne condition1
        jmp  Label1
    lError:
        jmp overflowError 
    Label1 :
        mov ax,c
        dec ax    ; ax = c-1
        mov bx,d
        cmp bx,0
        je DivideByZeroError
        div bx
        mov bx,b
        cmp bx,0
        je DivideByZeroError
        div bx
        mov cx,a
        add ax,cx ; ax = (c-1)/d/b + a
        call OutputResult
        JMP exit
    condition1:

        mov ax,a
        mov cx,ax
        mul cx
        mul cx    ; ax = a^3
        jc overflowError

        mov bx,ax ; bx = ax = a^3

        mov ax,b
        mov cx,ax
        mul cx
        mul cx    ; ax = b^3
        jc overflowError

        add ax,bx ; ax = a^3 + b^3
        jc overflowError

        mov cx,c
        mov dx,b
        add cx,dx ; cx = c + b

        cmp ax,cx ; check c + b == a^3 + b^3
        jne condition2

        mov ax,a
        mov cx,c
        mov dx,d 
        add cx,dx 
        and ax,cx ; ax = a AND (c+d)
        call OutputResult

        JMP exit
    condition2:

        mov ax,a
        mov bx,b
        mul bx
        mov bx,c
        mul bx
        mov bx,d
        mul bx  ; ax = a*b*c*d
        jc overflowError
        call OutputResult
        jmp exit
        
overflowError:   
    lea dx,error1massage
    call PrintMassage
    jmp exit

DivideByZeroError:
    lea dx,error2massage
    call PrintMassage
    jmp exit

exit:
        mov ah,4ch
        int 21h

InputNumber PROC
            lea dx,inputMassage       
            call PrintMassage 
            mov ah,01h
            int 21h     ; в al - первый символ
            sub al,30h  ; теперь первая цифра
            mov ah,0    ; расширение до слова
            mov bx,10
            mov cx,ax   ; в cx - первая цифра
cycle:  
            mov ah,01h
            int 21h      ;   в al следующий символ
            cmp al,0dh   ; сравнение с символом Enter
            je exitCycle ; конец ввода
            sub al,30h   ; в al - следующая цифра
            cbw          ; расширение до слова
            xchg ax,cx   ; теперь в ax - предыдущее число, в cx - следующая
            mul bx       ; ax*10
            jc overflowError
            add cx,ax    ; cx=ax*10+cx
            jmp cycle    ; продолжение ввода
exitCycle :   
    mov ax,cx
    
    
    ret
InputNumber ENDP

OutputResult PROC
    mov bx ,10
    mov cx,0
l1:
    mov dx,0
    div bx
    add dx,48
    push dx
    inc cx
    cmp ax,0
    jne l1
    lea bx,string
l2:
    pop dx           
    mov [bx],dx
    inc bx
loop l2 
    lea dx,ouputMassage
    call PrintMassage
    
    lea dx,string
    call PrintMassage

    ret
OutputResult endp

PrintMassage PROC
    mov ah,9
    int 21h
    ret
PrintMassage endp

end start