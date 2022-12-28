#!/usr/bin/sudo /bin/bash
wget https://github.com/ChisBread/rk3588-gaming-step-by-step/raw/main/rk3588-enhance/balance-governor.sh -O /usr/local/bin/balance-governor.sh
chmod +x /usr/local/bin/balance-governor.sh
wget https://github.com/ChisBread/rk3588-gaming-step-by-step/raw/main/rk3588-enhance/performance-governor.sh -O /usr/local/bin/performance-governor.sh
chmod +x /usr/local/bin/performance-governor.sh
cat > /etc/sysctl.d/rk3588-governor <<EOF
#RK3588_GOVERNOR_DEFAULT=performance
RK3588_GOVERNOR_DEFAULT=balance
EOF
cat > /etc/systemd/system/rk3588-governor.service <<EOF
[Unit]
After=
Description=rk3588-governor

[Service]
EnvironmentFile=/etc/sysctl.d/rk3588-governor
ExecStart=/usr/bin/bash -c "/usr/local/bin/\${RK3588_GOVERNOR_DEFAULT:-balance}-governor.sh"
Type=oneshot

[Install]
WantedBy=default.target
EOF
systemctl daemon-reload
systemctl enable rk3588-governor
systemctl start rk3588-governor