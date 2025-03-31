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
