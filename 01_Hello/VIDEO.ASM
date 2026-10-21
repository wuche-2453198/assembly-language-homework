; 第一次作业（补充）：直接写显存 B800h 输出 Hello, World!

data    segment
msg     db      'Hello, World!'         ; 13 个字符
len     equ     $ - msg                 ; 字符串长度
attr    equ     07h                     ; 黑底白字
data    ends

stack   segment stack
        db      128 dup(0)              ; 128 字节堆栈
stack   ends

code    segment
        assume  cs:code, ds:data
start:
        mov     ax, data                ; 数据段段地址
        mov     ds, ax                  ; DS 指向数据段
        mov     ax, 0b800h              ; 彩色文本显存段地址
        mov     es, ax                  ; ES 指向显存
        mov     si, offset msg          ; SI 指向字符串
        mov     di, 12*160              ; 第 13 行行首
        mov     cx, len                 ; 字符个数
put:
        mov     al, [si]                ; 取一个字符
        mov     es:[di], al             ; 写入字符码
        mov     byte ptr es:[di+1], attr ; 写入属性
        inc     si                      ; 下一个字符
        add     di, 2                   ; 显存中每字符占 2 字节
        loop    put                     ; 直到字符全部写入
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS
code    ends
        end     start
