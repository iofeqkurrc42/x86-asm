; 写一小段程序，先比较寄存器AX和BX中的数值，然后，当AX的内容大于BX的内容时，转移到标号lbb处执行
; AX的内容等于BX的内容时，转移到标号lbz处执行
; AX的内容小于BX的内容时，转移到标号lbl处执行

         jmp near start
data     db 0x00,0x01,0x00,0x02

lbb:
         mov byte [es:0x00],'>'
         mov byte [es:0x01],0x07
         jmp end
lbz:
         mov byte [es:0x00],'='
         mov byte [es:0x01],0x07
         jmp end
lbl:
         mov byte [es:0x00],'<'
         mov byte [es:0x01],0x07
         jmp end

start:
         mov ax,0x7c0                  ;设置数据段基地址
         mov ds,ax

         mov ax,0xb800                 ;设置附加段基地址 
         mov es,ax

         mov si,data
         mov ax,[si]
         add si,2
         mov bx,[si]
         cmp ax,bx
         ja lbb
         je lbz
         jb lbl

end:
         jmp near $
times 510-($-$$) db 0
                 db 0x55,0xaa 
