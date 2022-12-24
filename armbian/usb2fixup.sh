sudo bash -c 'cat > /etc/systemd/system/orangepi5_usb2_init.service <<EOF
[Unit]
After=
Description=usb2 init

[Service]
ExecStart=/usr/bin/bash -c "echo host > /sys/kernel/debug/usb/fc000000.usb/mode"
Type=oneshot

[Install]
WantedBy=default.target
EOF'
sudo systemctl daemon-reload
sudo systemctl enable orangepi5_usb2_init
sudo systemctl start orangepi5_usb2_init
echo "ACTION==\"remove\", SUBSYSTEM==\"typec\", RUN+=\"/usr/bin/bash -c 'echo host > /sys/kernel/debug/usb/fc000000.usb/mode'\"" > /tmp/83-typec.rules
sudo bash -c 'mv /tmp/83-typec.rules /etc/udev/rules.d/'
sudo udevadm control --reload-rules