# Panfork 32位版 交叉编译&安装 
- step1. 安装环境依赖
```bash
sudo dpkg --add-architecture armhf
sudo apt update
# 这里顺便安装了部分常见依赖, 可以按需去除
sudo apt install libc6:armhf libncurses5:armhf libsdl2*:armhf libopenal*:armhf libpng*:armhf libfontconfig*:armhf libXcomposite*:armhf libbz2-dev:armhf libXtst*:armhf
# 这些是工具链和编译环境, 如果提示缺少依赖, google一下就能找到对应的包
sudo apt install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
sudo apt install libexpat1-dev:armhf libwayland-egl-backend-dev:armhf libxext-dev:armhf libxfixes-dev:armhf libxcb-glx0-dev:armhf libxcb-shm0-dev:armhf libxcb-dri2-0-dev:armhf libxcb-dri3-dev:armhf libxcb-present-dev:armhf libxshmfence-dev:armhf libxxf86vm-dev:armhf libxrandr-dev:armhf libx11-xcb-dev:armhf
```
- step2. 编译安装libdrm
``` bash
cd drm/build
sudo rm -rf *
CC=arm-linux-gnueabihf-gcc CXX=arm-linux-gnueabihf-g++ meson
sudo ninja install
```
- step3. 创建文件 mesa/cross_armhf.txt 并复制以下设置
```conf
[binaries]
# we could set exe_wrapper = qemu-arm-static but to test the case
# when cross compiled binaries can't be run we don't do that
c = '/usr/bin/arm-linux-gnueabihf-gcc'
cpp = '/usr/bin/arm-linux-gnueabihf-g++'
ar = '/usr/arm-linux-gnueabihf/bin/ar'
strip = '/usr/arm-linux-gnueabihf/bin/strip'
pkgconfig = '/usr/bin/arm-linux-gnueabihf-pkg-config'
ld = '/usr/bin/arm-linux-gnueabihf-ld'

[properties]
root = '/usr/arm-linux-gnueabihf'

has_function_printf = true
has_function_hfkerhisadf = false

skip_sanity_check = true

[host_machine]
system = 'linux'
cpu_family = 'arm'
cpu = 'armv7' # Not sure if correct.
endian = 'little'
```
- step4. 编译安装panfork (安装到/opt/panfrost/arm-linux-gnueabihf)
```bash
cd mesa/build
PKG_CONFIG_PATH=/usr/local/lib/arm-linux-gnueabihf/pkgconfig CC=arm-linux-gnueabihf-gcc CXX=arm-linux-gnueabihf-g++ meson -Dgallium-drivers=panfrost -Dvulkan-drivers=panfrost -Dllvm=disabled --prefix=/opt/panfrost/arm-linux-gnueabihf --cross-file cross_armhf.txt
```
- step4. 开启全局默认
```bash
sudo bash -c "echo '/opt/panfrost/arm-linux-gnueabihf/lib' >> /etc/ld.so.conf.d/0-panfrost.conf"
sudo ldconfig
```