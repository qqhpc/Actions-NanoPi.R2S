#!/bin/bash
# 2022.09.08

pwd

cd /workdir/openwrt

echo "添加 passwall"
echo "src-git passwall https://github.com/qqhpc/xiaorouji-openwrt-passwall.git" >> feeds.conf.default

echo "添加 passwall2"
echo "src-git passwall2 https://github.com/qqhpc/xiaorouji-openwrt-passwall2.git" >> feeds.conf.default

echo "添加 helloworld"
sed -i "/helloworld/d" "feeds.conf.default" && echo "src-git helloworld https://github.com/qqhpc/fw876-helloworld.git" >> feeds.conf.default
# ssr-plus依赖sagernet-core,Sagernet内核和V2ray/Xray内核冲突

echo "添加 openclash"
#echo "src-git OpenClash https://github.com/qqhpc/vernesong-OpenClash.git;dev" >> feeds.conf.default
svn export https://github.com/qqhpc/vernesong-OpenClash/branches/dev/luci-app-openclash ./package/openclash

echo "添加 luci-app-adguardhome"
git clone https://github.com/qqhpc/rufengsuixing-luci-app-adguardhome.git ./package/luciadguardhome

#echo "添加 kenzok8_small"
#echo "src-git small https://github.com/qqhpc/kenzok8-small.git;master" >> feeds.conf.default

#echo "添加 node"
#echo "src-git node https://github.com/nxhack/openwrt-node-packages.git;openwrt-22.03" >> feeds.conf.default

echo "下载 feeds"
./scripts/feeds update -a

echo "更新 go"
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

echo "安装 feeds"
./scripts/feeds install -a

echo "下载 config"
rm -rf .config
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/Lean/.config/lean.raspberrypi4b.5gmod.config.txt
mv lean.raspberrypi4b.5gmod.config.txt .config

echo "下载 dl"
make download -j2

echo "编译固件"
make -j$(expr $(nproc) + 1)  V=s
