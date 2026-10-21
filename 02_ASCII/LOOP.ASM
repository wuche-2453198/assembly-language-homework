; 第二次作业（1）：用 LOOP 指令输出 a~z，每行 13 个字符

perline equ     13                      ; 每行字符数
nline   equ     2                       ; 行数

stack   segment stack
        db      128 dup(0)              ; 128 字节堆栈
stack   ends

code    segment
        assume  cs:code
start:
        mov     bl, 'a'                 ; 当前字符
        mov     cx, nline               ; 外层计数：剩余行数
row_loop:
        push    cx                      ; 保存外层计数
        mov     cx, perline             ; 内层计数：每行字符数
col_loop:
        mov     dl, bl                  ; 待输出的字符
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h                     ; 调用 DOS 功能
        inc     bl                      ; 下一个字符
        loop    col_loop                ; CX 减 1，不为 0 继续
        call    newline                 ; 输出回车换行
        pop     cx                      ; 恢复外层计数
        loop    row_loop                ; CX 减 1，不为 0 继续
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS

newline proc
        push    ax                      ; 保存 AX
        push    dx                      ; 保存 DX
        mov     dl, 0dh                 ; 回车
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     dl, 0ah                 ; 换行
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        pop     dx                      ; 恢复 DX
        pop     ax                      ; 恢复 AX
        ret
newline endp

code    ends
        end     start
