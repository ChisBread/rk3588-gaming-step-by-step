cat << "EOF" | sudo tee /usr/sbin/ondemand_friends.sh > /dev/null
#!/bin/bash
prefix="/sys/devices/system/cpu"
find "${prefix}" -name cpuinfo_cur_freq -exec chmod +r {} \;
grep -q ondemand /etc/default/cpufrequtils
if [ $? -eq 0 ]; then	
	CPUFreqPolicies=($(ls -d ${prefix}/cpufreq/policy? | sed 's/freq\/policy//'))
	if [ ${#CPUFreqPolicies[@]} -eq 1 -a -d "${prefix}/cpufreq" ]; then
		# if there's just a single cpufreq policy ondemand sysfs entries differ
		CPUFreqPolicies=${prefix}
	fi
	for i in ${CPUFreqPolicies[@]}; do
		affected_cpu=$(tr -d -c '[:digit:]' <<< ${i})
		echo ondemand >${prefix}/cpu${affected_cpu:-0}/cpufreq/scaling_governor
		echo 1 >${i}/cpufreq/ondemand/io_is_busy
		echo 25 >${i}/cpufreq/ondemand/up_threshold
		echo 10 >${i}/cpufreq/ondemand/sampling_down_factor
		echo 200000 >${i}/cpufreq/ondemand/sampling_rate
	done
fi
EOF
sudo chmod +x /usr/sbin/ondemand_friends.sh

sudo bash -c 'cat > /etc/systemd/system/ondemand_friends.service <<EOF
[Unit]
After=
Description=ondemand_friends

[Service]
ExecStart=/usr/sbin/ondemand_friends.sh
Type=oneshot

[Install]
WantedBy=default.target
EOF'
sudo systemctl daemon-reload
sudo systemctl enable ondemand_friends
sudo systemctl start ondemand_friends

sudo bash -c 'cat > /etc/systemd/system/dmc_upthreshold_init.service <<EOF
[Unit]
After=
Description=dmc upthreshold init

[Service]
ExecStart=/usr/bin/bash -c "echo 20 >/sys/devices/platform/dmc/devfreq/dmc/upthreshold"
Type=oneshot

[Install]
WantedBy=default.target
EOF'
sudo systemctl daemon-reload
sudo systemctl enable dmc_upthreshold_init
sudo systemctl start dmc_upthreshold_init