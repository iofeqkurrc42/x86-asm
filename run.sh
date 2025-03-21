#!/bin/bash
if ! command -v nasm &>/dev/null; then
	echo "错误：NASM 未安装。请执行以下命令安装："
	echo "sudo apt-get update && sudo apt-get install nasm"
	exit 1
fi

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "用法：$0 <filename.asm> [vhd_file.vhd]"
	exit 1
elif [ ! -f "$1" ]; then
	echo "错误：文件 $1 不存在"
	exit 1
fi

filename=$(basename "$1" .asm)
output_name="${filename}.bin" # 直接指定二进制输出扩展名
nasm -f bin "$1" -o "$output_name"
if [ $? -ne 0 ]; then
	echo "汇编编译失败，请检查："
	echo "1. 代码是否包含必要的起始地址声明（如 org 0x7C00）"
	echo "2. 指令是否符合 x86 架构规范"
	exit 1
fi

echo "编译成功！生成的二进制文件：$output_name"
echo "文件大小：$(wc -c <"$output_name") 字节"

# 使用 dd 命令将编译好的 bin 文件写入 LEECHUNG.vhd 文件
vhd_file="${2:-LEECHUNG.vhd}" # 默认 VHD 文件名
if [ ! -f "$vhd_file" ]; then
	echo "错误：目标VHD文件 $vhd_file 不存在"
	exit 1
fi

vhd_file_lock = "$vhd_file.lock" # 默认 VHD 文件加锁文件名
if [ -f "$vhd_file_lock" ]; then
	rm "$vhd_file_lock"
	echo "已删除bochs 文件加锁文件 $vhd_file_lock"
fi

sudo dd if="$output_name" of="$vhd_file" bs=512 count=1 conv=notrunc
if [ $? -ne 0 ]; then
	echo "写入 LEECHUNG.vhd 文件失败"
	exit 1
fi

echo "二进制文件已成功写入 LEECHUNG.vhd 文件"
rm "$output_name"

# 启动 Bochs 模拟器
if ! command -v bochs &>/dev/null; then
	echo "错误：Bochs 未安装。请执行以下命令安装："
	echo "sudo apt-get install bochs bochs-x vgabios"
	exit 1
fi
echo "启动 Bochs 模拟器..."
bochs -q
