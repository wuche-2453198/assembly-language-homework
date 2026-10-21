; 第三次作业（2）：输入 1~100 的整数 n，求 1+2+...+n 并输出十进制结果

data    segment
prompt  db      'n = $'                 ; 输入提示
buf     db      4, 0, 4 dup(0)          ; 0Ah 输入缓冲区
msg     db      'sum = $'               ; 结果提示
err     db      'n must be 1..100', 0dh, 0ah, '$' ; 范围错误提示
data    ends

stack   segment stack
        db      128 dup(0)              ; 128 字节堆栈
stack   ends

code    segment
        assume  cs:code, ds:data
start:
        mov     ax, data                ; 数据段段地址
        mov     ds, ax                  ; DS 指向数据段
again:
        mov     dx, offset prompt       ; DX 指向输入提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        mov     dx, offset buf          ; DX 指向输入缓冲区
        mov     ah, 0ah                 ; 0Ah：读取一行
        int     21h
        mov     dl, 0dh                 ; 回车
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     dl, 0ah                 ; 换行
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     cl, [buf+1]             ; CL = 实际输入字符数
        xor     ch, ch
        cmp     cx, 0                   ; 没有输入？
        je      bad                     ;   是，转到错误处理
        mov     si, offset buf+2        ; SI 指向输入内容
        xor     bx, bx                  ; BX = 数值，清零
parse_loop:
        mov     al, [si]                ; 取一个字符
        sub     al, '0'                 ; 转成数字
        cmp     al, 9                   ; 是 0~9 吗？
        ja      bad                     ;   不是，转到错误处理
        xor     ah, ah
        push    ax                      ; 保存当前数字
        mov     ax, bx                  ; AX = 已有数值
        mov     di, 10                  ; 乘数 10
        mul     di                      ; DX:AX = AX * 10
        mov     bx, ax                  ; BX = 已有数值 * 10
        pop     ax                      ; 取出当前数字
        add     bx, ax                  ; BX = 数值 * 10 + 数字
        inc     si                      ; 下一个字符
        loop    parse_loop              ; 还有字符就继续
        cmp     bx, 1                   ; n < 1 吗？
        jb      bad                     ;   是，转到错误处理
        cmp     bx, 100                 ; n > 100 吗？
        ja      bad                     ;   是，转到错误处理
        xor     ax, ax                  ; 累加和清零
        mov     cx, bx                  ; 循环 n 次
        mov     bx, 1                   ; 当前加数
sum_loop:
        add     ax, bx                  ; 累加
        inc     bx                      ; 下一个加数
        loop    sum_loop                ; CX 减 1，不为 0 继续
        push    ax                      ; 保存结果
        mov     dx, offset msg          ; DX 指向结果提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        pop     ax                      ; 取回结果
        call    print_dec               ; 输出十进制结果
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS
bad:
        mov     dx, offset err          ; DX 指向错误提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        jmp     again                   ; 重新输入

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
