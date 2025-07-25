         ;代码清单15-3，文件名：c15_app.asm
         ;文件说明：用户程序
         ;修改于2022-02-28

;===============================================================================
SECTION header vstart=0

         program_length   dd program_end          ;程序总长度#0x00
         
         head_len         dd header_end           ;程序头部的长度#0x04

         prgentry         dd start                ;程序入口#0x08
         code_seg         dd section.code.start   ;代码段位置#0x0c
         code_len         dd code_end             ;代码段长度#0x10

         data_seg         dd section.data.start   ;数据段位置#0x14
         data_len         dd data_end             ;数据段长度#0x18

         stack_seg        dd section.stack.start  ;栈段位置#0x1c
         stack_len        dd stack_end            ;栈段长度#0x20
             
;-------------------------------------------------------------------------------
         ;符号地址检索表
         salt_items       dd (header_end-salt)/256 ;#0x24

         salt:                                     ;#0x28
         PrintString      db  '@PrintString'
                     times 256-($-PrintString) db 0

         TerminateProgram db  '@TerminateProgram'
                     times 256-($-TerminateProgram) db 0

         ReadDiskData     db  '@ReadDiskData'
                     times 256-($-ReadDiskData) db 0

header_end:

;===============================================================================
SECTION data vstart=0

         buffer times 1024 db  0         ;缓冲区

         message_1         db  0x0d,0x0a,0x0d,0x0a
                           db  '**********User program is runing**********'
                           db  0x0d,0x0a,0
         message_2         db  '  Disk data:',0x0d,0x0a,0

data_end:

;===============================================================================
SECTION stack vstart=0

        times 2048        db 0                    ;保留2KB的栈空间

stack_end:

;===============================================================================
      [bits 32]
;===============================================================================
SECTION code vstart=0

start:
         mov eax,ds
         mov fs,eax

         mov ss,[fs:stack_seg]
         mov esp,stack_end

         mov ds,[fs:data_seg]

         mov ebx,message_1
         call far [fs:PrintString]

         mov eax,100                         ;逻辑扇区号100
         mov ebx,buffer                      ;缓冲区偏移地址
         call far [fs:ReadDiskData]          ;段间调用

         mov ebx,message_2
         call far [fs:PrintString]

         mov ebx,buffer
         call far [fs:PrintString]           ;too.

         jmp far [fs:TerminateProgram]       ;将控制权返回到系统

code_end:

;===============================================================================
SECTION trail
;-------------------------------------------------------------------------------
program_end:

