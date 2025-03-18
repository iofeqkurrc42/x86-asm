org 0x7c00
mov ax, 0xb800
mov es, ax
mov byte [es:0x00], 'i'  ; 写入第一个字符到显存
mov byte [es:0x02], 'a'  ; 写入第二个字符到显存
mov byte [es:0x04], 'm'  ; 写入第三个字符到显存
jmp $              ; 无限循环

times 510-($-$$) db 0  ; 填充剩余空间
db 0x55, 0xaa          ; 引导扇区签名
