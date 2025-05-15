## x86 汇编语言

### 需要
- nasm 编译器
- bochs 虚拟机(bochs bochs-x vgabios)

### 配置

需要配置 bochs 配置在此, 若使用《x86 汇编语言: 从实模式到保护模式》里虚拟硬盘, 则根据书中配置.

注意:bochs 配置里

```
romimage: file=/usr/share/bochs/BIOS-bochs-latest
```

改为

```
romimage: file="/usr/share/bochs/BIOS-bochs-legacy"
```


### 运行
```sh
./run.sh [-s seek] [-n] <filename.asm> [vhd_file.vhd]
```
-s: set seek
-n: not run bochs


### 引用
- 《x86 汇编语言: 从实模式到保护模式》
- [《x86 汇编语言: 从实模式到保护模式》配套资源](https://www.lizhongc.com/thread-1-1-1.html)
- [Bochs 配置](http://blog.ccyg.studio/article/eedcc300-35f4-4174-9622-c336aa8d7881/)
- [Bochs 在 Ubuntu 下启动失败解决方法](http://blog.ccyg.studio/article/eedcc300-35f4-4174-9622-c336aa8d7881/)
