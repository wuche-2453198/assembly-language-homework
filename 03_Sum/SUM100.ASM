; 第三次作业（1）：求 1+2+...+100，结果存放在寄存器中并输出

stack   segment stack
        db      128 dup(0)              ; 128 字节堆栈
stack   ends

code    segment
        assume  cs:code
start:
        xor     ax, ax                  ; 累加和清零
        mov     cx, 100                 ; 循环 100 次
        mov     bx, 1                   ; 当前加数
sum_loop:
        add     ax, bx                  ; 累加
        inc     bx                      ; 下一个加数
        loop    sum_loop                ; CX 减 1，不为 0 继续
        call    print_dec               ; 输出十进制结果
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS

print_dec proc
        push    ax                      ; 保存 AX
        push    bx                      ; 保存 BX
        push    cx                      ; 保存 CX
        push    dx                      ; 保存 DX
        mov     bx, 10                  ; 除数为 10
        xor     cx, cx                  ; 位数计数清零
div_loop:
        xor     dx, dx                  ; 被除数高 16 位清零
        div     bx                      ; DX:AX 除以 10
        push    dx                      ; 余数压栈
        inc     cx                      ; 位数加 1
        cmp     ax, 0                   ; 商为 0 吗？
        jne     div_loop                ; 不为 0 继续除
pop_loop:
        pop     dx                      ; 弹出余数
        add     dl, '0'                 ; 转成 ASCII 字符
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        dec     cx                      ; 位数减 1
        jnz     pop_loop                ; 不为 0 继续输出
        mov     dl, 0dh                 ; 回车
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     dl, 0ah                 ; 换行
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        pop     dx                      ; 恢复 DX
        pop     cx                      ; 恢复 CX
        pop     bx                      ; 恢复 BX
        pop     ax                      ; 恢复 AX
        ret
print_dec endp

code    ends
        end     start
