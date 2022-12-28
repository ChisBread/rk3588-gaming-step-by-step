#!/usr/bin/sudo /bin/bash
sudo echo performance > /sys/class/devfreq/fb000000.gpu/governor
sudo echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
sudo echo performance > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
sudo echo performance > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
sudo echo performance > /sys/class/devfreq/dmc/governor