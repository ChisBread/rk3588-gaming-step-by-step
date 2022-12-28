## GPU驱动

因为RK3588(S)的Linux补丁还没进主线，所以RK3588(S)内核版本暂停在了RockChip提供的5.10版本上
而5.10版本的内核，还没有合并Valhall(Mali-G57, Mali-G610 ...)支持

RK3588的厂商出场驱动可能会带上libmali, 支持OpenGL(ESv2) API，但可惜的是让它正确工作需要付出额外的成本
想让所有应用在默认情况下工作，我们需要mesa/panfrost支持

### Panfork简介

按我的理解, panfork是mesa/panfrost的User Space移植；驱动原理和libmali一样，但开源(意味着可以在自制系统上使用)、性能和兼容性更好.
而且作为mesa的移植, 如果作者积极维护, 我们就能及时用上Linux主线的GPU驱动更新, 比如PanVK(Mali GPU的Vulkan驱动)

总之, 在默认情况下, panfork运转良好

- refs
```txt
panfork https://gitlab.com/panfork/mesa
```
### Panfork 安装步骤(PPA版)

Ubuntu 22.04(Jammy)用户, 可以从ppa安装

```bash
# step1. 下载GPU固件到/lib/firmware
sudo wget https://github.com/JeffyCN/rockchip_mirrors/raw/libmali/firmware/g610/mali_csffw.bin -O /lib/firmware/mali_csffw.bin
# step2. 添加ppa
sudo add-apt-repository ppa:liujianfeng1994/panfork-mesa
# step3. 使用中科大ppa反代(可选)
sudo sed -i -e "s@http.*://ppa.launchpadcontent.net@https://launchpad.proxy.ustclug.org@g" /etc/apt/sources.list.d/*
sudo apt update
# step4. 原地升级
sudo apt dist-upgrade
# step5. 安装32位环境(可选)
sudo apt install -y libegl-mesa0:armhf libgbm1:armhf libgl1-mesa-dri:armhf libglapi-mesa:armhf libglx-mesa0:armhf
```
### Panfork 安装步骤(git版编译安装)

这一段照搬 [panfork](https://gitlab.com/panfork/mesa) ,并假设你的架构是aarch64

如果需要32位版本GPU驱动(比如通过box86运行Steam Linux)

在安装完成64位版以后, 参考[Panfork 32位版 编译安装](./mesa-armhf.md)


```bash
# step0. 内核编译参数(也许不是必选)
#编译内核时关闭 CONFIG_DRM_IGNORE_IOTCL_PERMIT
# step1. 下载GPU固件到/lib/firmware
sudo wget https://github.com/JeffyCN/rockchip_mirrors/raw/libmali/firmware/g610/mali_csffw.bin -O /lib/firmware/mali_csffw.bin
# step2. 安装环境依赖 
sudo apt install build-essential cmake meson git python3-mako libexpat1-dev bison flex libwayland-egl-backend-dev libxext-dev libxfixes-dev libxcb-glx0-dev libxcb-shm0-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxshmfence-dev libxxf86vm-dev libxrandr-dev libwayland-dev libx11-xcb-dev
# step3. 编译安装libdrm (覆盖原有的旧版) 
git clone https://gitlab.freedesktop.org/mesa/drm
mkdir drm/build
cd drm/build
meson
sudo ninja install
# step4. 编译安装wayland-protocols
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols
mkdir wayland-protocols/build
cd wayland-protocols/build
git checkout 1.24
meson
sudo ninja install
# step5. 编译安装panfork (安装到/opt/panfrost)
git clone https://gitlab.com/panfork/mesa
mkdir mesa/build
cd mesa/build
meson -Dgallium-drivers=panfrost -Dvulkan-drivers= -Dllvm=disabled --prefix=/opt/panfrost
sudo ninja install
```

### git版编译安装版使用(PPA版不需要)
- 全局默认
```bash
echo /opt/panfrost/lib/aarch64-linux-gnu | sudo tee /etc/ld.so.conf.d/0-panfrost.conf
# 如果存在 /etc/ld.so.conf.d/00-aarch64-mali.conf
# 要保证0-panfrost.conf优先级最高
# sudo mv /etc/ld.so.conf.d/00-aarch64-mali.conf /etc/ld.so.conf.d/1-aarch64-mali.conf
sudo ldconfig
```
- 临时使用(不推荐)
```bash
LD_LIBRARY_PATH=/opt/panfrost/lib/aarch64-linux-gnu glmark2
```

### 验证gpu负载
```
watch --no-title "cat /sys/devices/platform/fb000000.gpu/devfreq/fb000000.gpu/load | cut -d '@' -f 1 | awk '{ print \"GPU load: \"\$1\"%\"}'"
```

## 第二章: Box86与Box64
- 建议ppa安装，box86在aarch64下的编译较为麻烦
