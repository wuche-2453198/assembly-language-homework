; 第一次作业（1）：以传统方式输出 Hello, World!，用 debug -u 对照机器码

data    segment
msg     db      'Hello, World!', 0dh, 0ah, '$'   ; 待显示的字符串
data    ends

stack   segment stack
        db      128 dup(0)              ; 128 字节堆栈
stack   ends

code    segment
        assume  cs:code, ds:data
start:
        mov     ax, data                ; 数据段段地址
        mov     ds, ax                  ; DS 指向数据段
        mov     dx, offset msg          ; DX 指向字符串
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h                     ; 调用 DOS 功能
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS
code    ends
        end     start
