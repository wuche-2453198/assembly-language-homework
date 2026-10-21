/* 第三次作业（3）：用 C 求 1+2+...+100 并输出结果 */
#include <stdio.h>

int main(void)
{
    int sum = 0;                        /* 累加和 */
    int i;                              /* 加数 */

    for (i = 1; i <= 100; i++) {
        sum += i;                       /* 累加 */
    }
    printf("%d\n", sum);                /* 输出 5050 */
    return 0;
}
