; 小练习：输入 0~65535 的十进制数，输出对应的十六进制数

data    segment
msg1    db      'Please input a Dec number:', 0dh, 0ah, '$'
msg2    db      'The Hex number:', 0dh, 0ah, '$'
msg3    db      'Not a Dec number! Try again.', 0dh, 0ah, '$'
inbuf   db      6                       ; 最多输入 5 个数字（另加回车）
inlen   db      0                       ; 实际输入字符数
inch    db      0, 0, 0, 0, 0, 0        ; 输入内容
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
        xor     bx, bx                  ; BX = 数值，清零
parse_loop:
        mov     al, [si]                ; 取一个字符
        sub     al, '0'                 ; 转成数字
        cmp     al, 9                   ; 是 0~9 吗？
        ja      bad                     ;   不是，转到错误处理
        xor     ah, ah
        mov     bp, ax                  ; BP = 当前数字
        mov     ax, bx                  ; AX = 已有数值
        mov     cx, 10                  ; 乘数 10
        mul     cx                      ; DX:AX = AX * 10
        or      dx, dx                  ; 乘积超过 16 位？
        jnz     bad                     ;   是，转到错误处理
        mov     bx, ax                  ; BX = 已有数值 * 10
        add     bx, bp                  ; BX = 数值 * 10 + 数字
        jc      bad                     ; 进位，超出 16 位
        inc     si                      ; 下一个字符
        dec     di                      ; 剩余字符数减 1
        jnz     parse_loop              ; 还有字符就继续
        mov     dx, offset msg2         ; DX 指向结果提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        call    print_hex               ; 输出十六进制结果
        mov     ax, 4c00h               ; 4Ch：结束程序
        int     21h                     ; 返回 DOS
bad:
        mov     dx, offset msg3         ; DX 指向错误提示
        mov     ah, 09h                 ; 09h：显示字符串
        int     21h
        jmp     again                   ; 重新输入

print_hex proc
        push    ax                      ; 保存 AX
        push    bx                      ; 保存 BX
        push    cx                      ; 保存 CX
        push    dx                      ; 保存 DX
        push    bp                      ; 保存 BP
        mov     cx, 4                   ; 共 4 个十六进制位
        xor     bp, bp                  ; BP = 0：尚未输出有效位
hex_loop:
        rol     bx, 1                   ; 高 4 位移到低 4 位
        rol     bx, 1
        rol     bx, 1
        rol     bx, 1
        mov     al, bl                  ; 取低 4 位
        and     al, 0fh
        cmp     al, 0                   ; 是前导零吗？
        jne     put_digit               ;   不是，输出
        cmp     cx, 1                   ; 是最后一位吗？
        je      put_digit               ;   是，必须输出
        test    bp, bp                  ; 前面已输出有效位？
        jnz     put_digit               ;   是，输出这个 0
        jmp     next_digit              ;   否，跳过前导零
put_digit:
        mov     bp, 1                   ; 标记已输出有效位
        cmp     al, 9                   ; 是 10~15 吗？
        jbe     digit                   ;   否，直接转 ASCII
        add     al, 7                   ;   是，先加 7
digit:
        add     al, '0'                 ; 转成 ASCII 字符
        mov     dl, al                  ; DL = 待输出字符
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
next_digit:
        loop    hex_loop                ; CX 减 1，不为 0 继续
        mov     dl, 0dh                 ; 回车
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        mov     dl, 0ah                 ; 换行
        mov     ah, 02h                 ; 02h：输出单个字符
        int     21h
        pop     bp                      ; 恢复 BP
        pop     dx                      ; 恢复 DX
        pop     cx                      ; 恢复 CX
        pop     bx                      ; 恢复 BX
        pop     ax                      ; 恢复 AX
        ret
print_hex endp

code    ends
        end     start
