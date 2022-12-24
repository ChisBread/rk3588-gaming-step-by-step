if [ "$USER" != "root" ]; then
    echo "Requires root privileges, execute 'sudo bash ./switch.sh'"
    exit -1
fi
if [ ! -e "/boot/dtb/rockchip/rk3588s-orangepi-5.dtb.ori" ]; then
    cp /boot/dtb/rockchip/rk3588s-orangepi-5.dtb /boot/dtb/rockchip/rk3588s-orangepi-5.dtb.ori
    chmod 755 rk3588s-orangepi-5.dtb && sudo cp rk3588s-orangepi-5.dtb /boot/dtb/rockchip
else
    mv /boot/dtb/rockchip/rk3588s-orangepi-5.dtb.ori /boot/dtb/rockchip/rk3588s-orangepi-5.dtb
fi