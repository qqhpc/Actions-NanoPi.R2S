#!/bin/bash
# 2022.11.14

pwd

cd /workdir/openwrt

echo "添加 passwall"
git clone -b packages https://github.com/qqhpc/xiaorouji-openwrt-passwall.git ./package/passwallpackages
git clone -b luci https://github.com/qqhpc/xiaorouji-openwrt-passwall.git ./package/passwallluci

echo "添加 passwall2"
git clone https://github.com/qqhpc/xiaorouji-openwrt-passwall2.git ./package/passwall2

echo "添加 helloworld"
sed -i "/helloworld/d" "feeds.conf.default" && git clone https://github.com/qqhpc/fw876-helloworld.git ./package/helloworld
# ssr-plus的依赖:sagernet-core,Sagernet内核和V2ray/Xray内核冲突

echo "添加 openclash"
svn export https://github.com/qqhpc/vernesong-OpenClash/branches/dev/luci-app-openclash ./package/openclash

echo "添加 luci-app-adguardhome"
git clone https://github.com/qqhpc/rufengsuixing-luci-app-adguardhome.git ./package/luciadguardhome

echo "下载 feeds"
./scripts/feeds update -a

echo "安装 feeds"
./scripts/feeds install -a

echo "安装 feeds again"
./scripts/feeds install -a -f

echo "下载 config"
rm -rf .config
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/22.03/rk3328/NanoPi-R2S/openwrt-22.03-r2s.config.txt
mv openwrt-22.03-r2s.config.txt .config

echo "下载 dl"
make download -j2 V=s

echo "编译固件"
make -j$(expr $(nproc) + 1)  V=s
