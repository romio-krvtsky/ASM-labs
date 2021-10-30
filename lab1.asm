.model small
.stack 100h
.data
    a dw 9
    b dw 8
    c dw 2
    d dw 0
.code
start:  
        mov ax,@data
        mov ds,ax
        
        mov ax,c
        mov cx,ax
        mul cx
        mul cx     ; ax = c^3

        mov bx,a
        mov cx,b
        and bx,cx ; bx = a AND b

        cmp ax,bx ; check a AND b == c^3
        jne condition1

        mov ax,c
        dec ax    ; ax = c-1
        mov bx,d

        div bx
        mov bx,b
    
        div bx
        mov cx,a
        add ax,cx ; ax = (c-1)/d/b + a

        JMP exit
    condition1:

        mov ax,a
        mov cx,ax
        mul cx
        mul cx    ; ax = a^3

        mov bx,ax ; bx = ax = a^3

        mov ax,b
        mov cx,ax
        mul cx
        mul cx    ; ax = b^3

        add ax,bx ; ax = a^3 + b^3

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

        JMP exit
    condition2:

        mov ax,a
        mov bx,b
        mul bx
        mov bx,c
        mul bx
        mov bx,d
        mul bx  ; ax = a*b*c*d

exit:
        mov ah,4ch
        int 21h
end start