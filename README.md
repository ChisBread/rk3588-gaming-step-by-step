# RK3588(S) 游戏教程

一步步教你在RK3588(Debian-based OS)上运行各种游戏

注意: 本文只是个用作参考的操作手册，不保证在某些刁钻的场景下适用

# 快速开始
- 注: 标注为可选的, 可以暂时忽略
- 0、 安装、启动malior
```bash
wget -O - https://github.com/ChisBread/malior/raw/main/install.sh > /tmp/malior-install.sh && bash /tmp/malior-install.sh  && rm /tmp/malior-install.sh
malior 'echo hello arm!'
```
- 1、 (可选)按照[性能优化](./rk3588-enhance/README.md)无痛解锁大约30%的性能
- 2、 桌面环境
  - 部分官方镜像自带的桌面系统(比如香橙派5)不支持panfrost驱动
  - 注意, 有两个选择
```bash
# 选择a: 替换官方桌面; 方便安装兼容性更好的panfrost驱动,但可能导致部分应用失效
sudo apt-mark unhold xserver-common xserver-xorg-core xserver-xorg-dev xserver-xorg-legacy
sudo apt update && sudo apt dist-upgrade
# 选择b: 安装blob(闭源)驱动, malior命令前加上MALI_BLOB=x11; 只支持到OpenGL 2.1, 并且只支持x11应用, 不支持wayland
malior install libmali-g610-blob && malior install gl4es
MALI_BLOB=x11 malior glmark2 # 测试x11+OpenGL
```
- 3、 (可选)如果确认桌面环境OK, 则按照[环境安装](./gpu-envs.md)教程，安装开源GPU驱动
- 4、 (可选)安装wine 32位版本(会自动安装box86、box64); war3, 星际争霸 都需要wine
```bash
malior install wine # 会有弹窗, 如果乱码了就凭感觉点一个
malior winetricks -q fakechinese wenquanyi # 安装wine中文环境
echo $LANG 
# 如果显示不是zh_CN.UTF-8, 运行wine时要加上LC_ALL来保证wine为中文环境
malior LC_ALL=zh_CN.UTF-8 winecfg
```
- 5、 (可选)安装steam-wip, box86下的steam暂时还不稳定, 一些独立小游戏可以跑
```bash
malior install steam-wip
```
# 可能出现异常
1. 固件没有正确安装
```bash
# 下载并覆盖固件
sudo wget https://github.com/JeffyCN/rockchip_mirrors/raw/libmali/firmware/g610/mali_csffw.bin -O /lib/firmware/mali_csffw.bin
```
2. 使用了官方闭源桌面+开源驱动, 或者使用闭源驱动执行了wayland应用
# 例子
- 魔兽争霸:冰封王座
  - 下载免安装中文版war3, 自行搜索; 可以的话请支持正版(但我们需要免安装版…)
  - 确保malior和wine已经安装
  - 解压war3到 `~/.local/malior/war3-1.24e` 确保目录下有 `War3.exe`
  - 运行 `malior LC_ALL=zh_CN.UTF-8 wine "~/.local/malior/war3-1.24e/War3.exe -opengl -windows"`
  - 如果是闭源驱动, 运行 `MALI_BLOB=x11 malior LC_ALL=zh_CN.UTF-8 wine "~/.local/malior/war3-1.24e/War3.exe -opengl -windows"`
