#!/usr/bin/sudo /bin/bash
echo performance > /sys/class/devfreq/fb000000.gpu/governor
echo ondemand > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo ondemand > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
echo dmc_ondemand > /sys/class/devfreq/dmc/governor
echo 20 > /sys/devices/platform/dmc/devfreq/dmc/upthreshold
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