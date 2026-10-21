# 汇编语言课程作业

本仓库整理个人在汇编语言课程的作业。汇编程序均为 16 位 DOS 实模式程序，在 DOSBox + MASM 5.0 下汇编、链接和运行；C 程序用于观察编译器生成的反汇编，在 Windows 下用 `gcc -m32` 编译。

## 目录

| 目录                     | 题目             | 主要内容                                               |
| ------------------------ | ---------------- | ------------------------------------------------------ |
| [`01_Hello/`](01_Hello/) | Hello, World!    | 传统 EXE 方式、DEBUG 写内存方式、直接写显存            |
| [`02_ASCII/`](02_ASCII/) | 打印 ASCII 表    | LOOP、条件转移、C 语言及反汇编注释                     |
| [`03_Sum/`](03_Sum/)     | 求和             | 结果放在寄存器/数据段/栈、输入求和、C 语言及反汇编注释 |
| [`Exercise/`](Exercise/) | 小练习：进制转换 | 十六进制转十进制、十进制转十六进制                     |
| [`tools/`](tools/)       | 工具             | MASM 5.0、LINK 3.60、DEBUG                             |

## 运行环境

- DOSBox 0.74
- MASM 5.0
- LINK 3.60
- DEBUG（第一次作业查看机器码用）

## 环境准备

1. 安装 DOSBox 0.74。
2. 把仓库放到一个不含中文的路径，例如 `C:\ASM`。路径含空格时，`mount` 后面的路径要用双引号括起来。
3. 启动 DOSBox，挂载仓库并设置工具路径：

```bat
mount c C:\ASM
c:
set PATH=C:\tools;%PATH%
```

`C:\ASM` 只是示例，换成你实际存放仓库的目录。`C:\tools` 是挂载后的仓库内 `tools` 目录，不需要改成 Windows 路径。

4. 进入要运行的题目目录，例如：

```bat
cd \01_Hello
```

也可以把挂载命令写进 DOSBox 配置文件的 `[autoexec]` 段，这样每次启动 DOSBox 都会自动执行：

```ini
[autoexec]
@echo off
mount c C:\ASM
c:00
set PATH=C:\tools;%PATH%
```

## 汇编与链接

把 `tools` 加入 DOS 的 `PATH`，或把 `MASM.EXE`、`LINK.EXE`、`DEBUG.EXE` 复制到源文件所在目录：

```bat
masm HELLO.ASM;
link HELLO.OBJ;
HELLO.EXE
```
