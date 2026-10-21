/* 第二次作业（3）：用 C 输出 ASCII 小写字母，每行 13 个 */
#include <stdio.h>

#define PERLINE 13
#define NLINE   2

int main(void)
{
    int ch = 'a';                       /* 当前字符 */
    int row, col;                       /* 行计数、列计数 */

    for (row = 0; row < NLINE; row++) {
        for (col = 0; col < PERLINE; col++) {
            putchar(ch);                /* 输出当前字符 */
            ch++;                       /* 下一个字符 */
        }
        putchar('\r');                  /* 回车 */
        putchar('\n');                  /* 换行 */
    }
    return 0;
}
