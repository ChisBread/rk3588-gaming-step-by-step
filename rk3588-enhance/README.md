# rk3588性能优化
## 使用
- rk3588(s) 通用优化
```bash
# step1. 部署系统优化服务
wget -O - https://github.com/ChisBread/rk3588-gaming-step-by-step/raw/main/rk3588-enhance/deploy.sh | sudo bash
# step2. 默认平衡模式
echo 'RK3588_GOVERNOR_DEFAULT=balance' > /etc/sysctl.d/rk3588-governor
## or 默认性能模式
 # echo 'RK3588_GOVERNOR_DEFAULT=performance' > /etc/sysctl.d/rk3588-governor
# step3. 即时生效(重启则自动生效)
systemctl start rk3588-governor
```
- 临时切换
```bash
balance-governor.sh
# performance-governor.sh
```
- 香橙派5 CPU、GPU满血dtb
  - 见[release](https://github.com/ChisBread/linux-orangepi/releases), ⚠️注意！⚠️加压有风险，请确保供电和散热足够