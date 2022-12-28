#!/usr/bin/sudo /bin/bash
cat > /etc/systemd/system/dmc_upthreshold_init.service <<EOF
[Unit]
After=
Description=dmc upthreshold init

[Service]
ExecStart=/usr/bin/bash -c "echo 20 >/sys/devices/platform/dmc/devfreq/dmc/upthreshold"
Type=oneshot

[Install]
WantedBy=default.target
EOF
systemctl daemon-reload
systemctl enable dmc_upthreshold_init
systemctl start dmc_upthreshold_init