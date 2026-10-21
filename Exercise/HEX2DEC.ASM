; 小练习：输入 1~2 位十六进制数，输出对应的十进制数

data    segment
msg1    db      'Please input a Hex number:', 0dh, 0ah, '$'
msg2    db      'The Dec number:', 0dh, 0ah, '$'
msg3    db      'Not a Hex digit! Try again.', 0dh, 0ah, '$'
inbuf   db      3                       ; 最多输入 3 个字符
inlen   db      0                       ; 实际输入字符数
inch    db      0, 0, 0, 0              ; 输入内容
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
        mov     dx, offset msg1         ; DX 指向输入提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        mov     dx, offset inbuf        ; DX 指向输入缓冲区
        mov     ah, 0ah                 ; 0Ah：读取一行
        int     21h
        mov     dl, 0dh                 ; 回车
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     dl, 0ah                 ; 换行
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     cl, inlen               ; CL = 实际输入字符数
        xor     ch, ch
        cmp     cx, 0                   ; 没有输入？
        je      again                   ;   是，重新输入
        mov     di, cx                  ; DI = 剩余字符数
        mov     si, offset inch         ; SI 指向输入内容
        xor     bx, bx                  ; BX = 转换结果，清零
hex_loop:
        mov     al, [si]                ; 取一个字符
        cmp     al, 'a'                 ; 是小写字母吗？
        jb      not_lower
        cmp     al, 'z'
        ja      not_lower
        sub     al, 20h                 ; 转成大写
not_lower:
        cmp     al, '0'                 ; 是 '0'~'9' 吗？
        jb      bad
        cmp     al, '9'
        jbe     is_digit
        cmp     al, 'A'                 ; 是 'A'~'F' 吗？
        jb      bad
        cmp     al, 'F'
        ja      bad
        sub     al, 37h                 ; 'A'~'F' 转成 10~15
        jmp     hex_add
is_digit:
        sub     al, 30h                 ; '0'~'9' 转成 0~9
hex_add:
        mov     ch, al                  ; 暂存数字值
        mov     cl, 4                   ; 移位次数 4
        shl     bx, cl                  ; BX = BX * 16
        mov     al, ch                  ; 取回数字值
        xor     ah, ah                  ; 高位清零
        add     bx, ax                  ; BX = BX * 16 + 数字值
        inc     si                      ; 下一个字符
        dec     di                      ; 剩余字符数减 1
        jnz     hex_loop                ; 还有字符就继续
        mov     dx, offset msg2         ; DX 指向结果提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        mov     ax, bx                  ; AX = 转换结果
        call    print_dec               ; 输出十进制结果
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS
bad:
        mov     dx, offset msg3         ; DX 指向错误提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        jmp     again                   ; 重新输入

print_dec proc
        push    ax                      ; 保存 AX
        push    bx                      ; 保存 BX
        push    cx                      ; 保存 CX
        push    dx                      ; 保存 DX
        push    si                      ; 保存 SI
        mov     si, 10                  ; 除数为 10
        xor     cx, cx                  ; 位数计数清零
div_loop:
        xor     dx, dx                  ; 被除数高 16 位清零
        div     si                      ; DX:AX 除以 10
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
        pop     si                      ; 恢复 SI
        pop     dx                      ; 恢复 DX
        pop     cx                      ; 恢复 CX
        pop     bx                      ; 恢复 BX
        pop     ax                      ; 恢复 AX
        ret
print_dec endp

code    ends
        end     start
