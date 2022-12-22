#!/usr/bin/env bash
sudo wget https://github.com/JeffyCN/rockchip_mirrors/raw/libmali/firmware/g610/mali_csffw.bin -O /lib/firmware/mali_csffw.bin
# deps
sudo apt install build-essential cmake meson git python3-mako libexpat1-dev bison flex libwayland-egl-backend-dev libxext-dev libxfixes-dev libxcb-glx0-dev libxcb-shm0-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxshmfence-dev libxxf86vm-dev libxrandr-dev libwayland-dev libx11-xcb-dev
# libdrm
git clone https://gitlab.freedesktop.org/mesa/drm
mkdir drm/build
cd drm/build
meson
sudo ninja install
# wayland-protocols
git clone https://gitlab.freedesktop.org/wayland/wayland-protocols
mkdir wayland-protocols/build
cd wayland-protocols/build
git checkout 1.24
meson
sudo ninja install
# panfork
git clone https://gitlab.com/panfork/mesa
mkdir mesa/build
cd mesa/build
meson -Dgallium-drivers=panfrost -Dvulkan-drivers= -Dllvm=disabled --prefix=/opt/panfrost
sudo ninja install
