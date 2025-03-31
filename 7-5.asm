         jmp near start

data1    db 0x05,0xff,0x80,0xf0,0x97,0x30
data2    dw 0x90,0xfff0,0xa0,0x1235,0x2f,0xc0,0xc5bc

pos_cnt  dw 0
neg_cnt  dw 0

start:
         mov ax,0x7c0                  ;设置数据段基地址
         mov ds,ax

         mov si,data1
         mov cx,6
counter_byte:
         mov dl,[si]
         test dl,0x80
         js negative_byte 
         mov di,pos_cnt
         mov ax,[di]
         inc ax
         mov [di],ax
         jmp byte_next
negative_byte:
         mov di,neg_cnt
         mov ax,[di]
         inc ax
         mov [di],ax
byte_next:
         inc si
         loop counter_byte

         mov si,data2
         mov cx,7
counter_word:
         mov dx,[ds:si]
         test dx,dx
         js negative_word
         mov di,pos_cnt
         mov ax,[di]
         inc ax
         mov [di],ax
         jmp word_next
negative_word:
         mov di,neg_cnt
         mov ax,[di]
         inc ax
         mov [di],ax
word_next:
         add si,2
         loop counter_word

         mov ax,0xb800
         mov es,ax
         mov byte [es:0x00],'p'
         mov byte [es:0x01],0x07
         mov byte [es:0x02],':'
         mov byte [es:0x03],0x07
         mov di,pos_cnt
         mov ax,[di]
         or al,0x30
         mov ah,0x07
         mov [es:0x04],ax
         mov byte [es:0x06],'n'
         mov byte [es:0x07],0x07
         mov byte [es:0x08],':'
         mov byte [es:0x09],0x07
         mov di,neg_cnt
         mov ax,[di]
         or al,0x30
         mov ah,0x07
         mov [es:0x0A],ax

         jmp near $
times 510-($-$$) db 0
                 db 0x55,0xaa
