# RK3588(S) 游戏教程

一步步教你在RK3588(Debian-based OS)上运行各种游戏

注意: 本文只是个用作参考的操作手册，不保证在某些刁钻的场景下适用

1. 按照[环境安装](./gpu-envs.md)教程，安装GPU驱动、box86、box64
2. 按照[性能优化](./rk3588-enhance/README.md)无痛解锁大约30%的性能
3. 桌面(可选): 建议GNOME+Wayland的组合
4. 提速环境变量(可选): 将PAN_MESA_DEBUG=gofaster作为系统默认环境变量
5. 测试: 安装glmark2-es2-wayland并跑分
# 特殊处理
- 一些镜像自带的桌面系统(比如香橙派5)不支持panfrost驱动
```
sudo apt-mark unhold xserver-common xserver-xorg-core xserver-xorg-dev xserver-xorg-legacy
sudo apt update && sudo apt dist-upgrade
```
# malior
- 桌面替换完成后可以使用[malior](https://github.com/ChisBread/malior)安装游戏和应用

# 游戏提示
- war3
  - 1. 下载免安装中文版war3
  - 2. 安装、启动malior(确保启动时的LANG为zh_CN.UTF-8)
  - 3. 使用 `malior install wine` 安装wine环境
  - 3. 使用 `malior winetricks -q fakechinese wenquanyi` 解决中文乱码
  - 5. 解压war3到 `~/.local/malior/war3-1.24e` 确保目录下有 `War3.exe`
  - 6. 运行 `malior wine "~/.local/malior/war3-1.24e/War3.exe -opengl -windows"`
