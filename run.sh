#!/bin/bash

# 默认参数
sector=0
launch_bochs=1
vhd_file="LEECHUNG.vhd"

# 解析命令行选项
while getopts "s:n" opt; do
	case $opt in
	s) sector="$OPTARG" ;;
	n) launch_bochs=0 ;;
	*)
		echo "用法错误"
		exit 1
		;;
	esac
done
shift $((OPTIND - 1)) # 移除已解析的选项

# 检查必需参数
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
	echo "用法：$0 [-s 扇区号] [-n] <filename.asm> [vhd_file.vhd]"
	echo "示例："
	echo "  $0 -s 1 boot.asm           # 写入第1扇区，使用默认VHD，启动Bochs"
	echo "  $0 -s 0 -n kernel.asm disk.vhd  # 写入第0扇区，不启动Bochs"
	exit 1
fi

# 验证扇区号为整数
if ! [[ "$sector" =~ ^[0-9]+$ ]]; then
	echo "错误：扇区号必须为整数"
	exit 1
fi

# 检查NASM是否安装
if ! command -v nasm &>/dev/null; then
	echo "错误：NASM 未安装。请执行以下命令安装："
	echo "sudo apt-get update && sudo apt-get install nasm"
	exit 1
fi

# 处理文件名参数
filename=$(basename "$1" .asm)
if [ ! -f "$1" ]; then
	echo "错误：文件 $1 不存在"
	exit 1
fi

# 指定VHD文件（如果提供）
if [ $# -eq 2 ]; then
	vhd_file="$2"
fi

# 编译汇编文件
output_name="${filename}.bin"
nasm -f bin "$1" -o "$output_name"
if [ $? -ne 0 ]; then
	echo "汇编编译失败，请检查："
	echo "1. 代码是否包含必要的起始地址声明（如 org 0x7C00）"
	echo "2. 指令是否符合 x86 架构规范"
	exit 1
fi

echo "编译成功！生成的二进制文件：$output_name"
echo "文件大小：$(wc -c <"$output_name") 字节"

# 处理VHD文件锁
vhd_file_lock="${vhd_file}.lock"
if [ -f "$vhd_file_lock" ]; then
	rm "$vhd_file_lock"
	echo "已删除Bochs文件加锁文件 $vhd_file_lock"
fi

# 写入VHD镜像（支持指定扇区）
sudo dd if="$output_name" of="$vhd_file" bs=512 seek=$sector count=1 conv=notrunc
if [ $? -ne 0 ]; then
	echo "写入 $vhd_file 文件失败"
	exit 1
fi
echo "二进制文件已成功写入 $vhd_file 的第 $sector 扇区"

# 清理临时文件
rm "$output_name"

# 条件启动Bochs
if [ $launch_bochs -eq 1 ]; then
	if ! command -v bochs &>/dev/null; then
		echo "错误：Bochs 未安装。请执行以下命令安装："
		echo "sudo apt-get install bochs bochs-x vgabios"
		exit 1
	fi
	echo "启动 Bochs 模拟器..."
	bochs -q
fi
