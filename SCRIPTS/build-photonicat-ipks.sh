#!/bin/bash
# 2022.09.08

pwd

echo "开始下载openwrt源码"
git clone https://github.com/coolsnowwolf/lede /workdir/openwrt
echo "/workdir/openwrt的内容"
ls /workdir/openwrt
echo "源码下载完成"

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

echo "安装 feeds"
./scripts/feeds install -a

echo "安装 feeds again"
./scripts/feeds install -a -f

echo "下载 config"
rm -rf .config
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/Lean/.config/photonicat.ipks.config.txt
mv photonicat.ipks.config.txt .config

echo "下载 dl"
make download -j1 V=s && make download -j1 V=s

echo "编译固件"
export CROSS_COMPILE=aarch64-linux-gnu-
# make -j$(expr $(nproc) + 1)  V=s
make V=s -j1
