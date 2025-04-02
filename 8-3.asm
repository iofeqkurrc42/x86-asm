; 检测点8.1 第 3 题答案
push ds
push bx
push ax

mov bx,ss
mov ds,bx
mov bx,sp
mov dx,[bx]

pop ax
pop bx
pop ds

;; 将这26字节的数据在原地反向排列
;; 使用栈
string db 'abcdefghijklmnopqrstuvwxyz'
    mov cx,26
    mov bx,string
lppush:
    mov al,[bx]
    push ax
    inc bx
    loop lppush
lppop:
    pop ax
    mov [bx],al
    inc bx
    loop lppop

;; 使用基址变址寻址
    mov bx,string
    mov si,0
    mov di,25
order:
    mov ah,[bx+si]
    mov al,[bx+di]
    mov [bx+si],al
    mov [bx+di],ah
    inc si
    dec di
    cmp si,di
    jl order

