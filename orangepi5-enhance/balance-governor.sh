sudo bash -c 'echo performance > /sys/class/devfreq/fb000000.gpu/governor'
sudo bash -c 'echo ondemand > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor'
sudo bash -c 'echo ondemand > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor'
sudo bash -c 'echo ondemand > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor'