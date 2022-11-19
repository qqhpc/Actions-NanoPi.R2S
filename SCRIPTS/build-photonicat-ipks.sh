#!/bin/bash
# 2022.09.08

pwd

cd /workdir/openwrt

echo "添加 passwall"
echo "src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall.git;packages" >> feeds.conf.default
echo "src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall.git;luci" >> feeds.conf.default

echo "添加 passwall2"
echo "src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main" >> feeds.conf.default

echo "添加 helloworld"
sed -i "/helloworld/d" "feeds.conf.default" && echo "src-git helloworld https://github.com/fw876/helloworld.git;master" >> feeds.conf.default
# ssr-plus依赖sagernet-core,Sagernet内核和V2ray/Xray内核冲突

echo "添加 openclash"
echo "src-git luciopenclash https://github.com/vernesong/OpenClash.git;master" >> feeds.conf.default

echo "添加 luci-app-adguardhome"
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git ./package/luciadguardhome

echo "下载 feeds"
./scripts/feeds update -a

echo "更新 go"
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

echo "安装 feeds"
./scripts/feeds install -a

echo "安装 feeds again"
./scripts/feeds install -a -f

echo "下载 config"
rm -rf .config
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/21.02/.config/photonicat/photonicat.ipks.config.txt
mv photonicat.ipks.config.txt .config

echo "下载 dl"
make download -j2 V=s

echo "编译固件"
export CROSS_COMPILE=aarch64-linux-gnu-
make -j$(expr $(nproc) + 1)  V=s
