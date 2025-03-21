#!/usr/bin/fish

# 检查 NASM 是否安装
if not command -v nasm >/dev/null
    echo "错误：NASM 未安装。请执行以下命令安装："
    echo "sudo apt-get update && sudo apt-get install nasm"
    exit 1
end

# 参数校验
if test (count $argv) -lt 1 -o (count $argv) -gt 2
    echo "用法：$0 <filename.asm> [vhd_file.vhd]"
    exit 1
else if not test -f $argv[1]
    echo "错误：文件 $argv[1] 不存在"
    exit 1
end

# 提取文件名和输出路径
set filename (basename $argv[1] .asm)
set output_name "$filename.bin"

# 编译汇编文件
nasm -f bin $argv[1] -o $output_name
if not test $status -eq 0
    echo "汇编编译失败，请检查："
    echo "1. 代码是否包含必要的起始地址声明（如 org 0x7C00）"
    echo "2. 指令是否符合 x86 架构规范"
    exit 1
end

echo "编译成功！生成的二进制文件：$output_name"
echo "文件大小："(wc -c < $output_name)" 字节"

# 设置 VHD 文件名（带默认值）
set vhd_file "LEECHUNG.vhd"
if test (count $argv) -ge 2
    set vhd_file $argv[2]
end

# 写入 VHD 文件
if not test -f $vhd_file
    echo "错误：目标VHD文件 $vhd_file 不存在"
    exit 1
end

# 删除 bochs 文件加锁文件
set vhd_file_lock "$vhd_file.lock"
if test -f $vhd_file_lock
    rm $vhd_file_lock
	  echo "已删除bochs 文件加锁文件 $vhd_file_lock"
end

# 设置 sudo dd if=$output_name of=$vhd_file bs=512 count=1 conv=notrunc
if not test $status -eq 0
    echo "写入 $vhd_file 文件失败"
    exit 1
end

echo "二进制文件已成功写入 $vhd_file 文件"
rm $output_name

# 启动 Bochs 模拟器
if not command -v bochs >/dev/null
    echo "错误：Bochs 未安装。请执行以下命令安装："
    echo "sudo apt-get install bochs bochs-x vgabios"
    exit 1
end

echo "启动 Bochs 模拟器..."
bochs -q
