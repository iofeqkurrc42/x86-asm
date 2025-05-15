## x86 Assembly Language

[中文](./README_CN.md)

### Requirements
- nasm compiler
- bochs emulator (bochs bochs-x vgabios)

### Configuration
Configure bochs here. If using the virtual hard disk from 《x86 汇编语言: 从实模式到保护模式》, follow the book's configuration.
Note: In bochs configuration, change
```
romimage: file=/usr/share/bochs/BIOS-bochs-latest
```
to
```
romimage: file="/usr/share/bochs/BIOS-bochs-legacy"
```
### Run
```sh
./run.sh [-s seek] [-n] <filename.asm> [vhd_file.vhd]
```
-s: set seek
-n: not run bochs


### Reference
- 《x86 汇编语言: 从实模式到保护模式》
- [《x86 汇编语言: 从实模式到保护模式》Resoure](https://www.lizhongc.com/thread-1-1-1.html)
- [Bochs configuration](http://blog.ccyg.studio/article/eedcc300-35f4-4174-9622-c336aa8d7881/)
- [Bochs Startup Failure Solutions on Ubuntu](http://blog.ccyg.studio/article/eedcc300-35f4-4174-9622-c336aa8d7881/)
