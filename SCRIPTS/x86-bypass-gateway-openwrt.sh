#!/bin/bash
# 2022.09.19

pwd

cd /workdir/openwrt

echo "添加 passwall"
git clone  https://github.com/qqhpc/xiaorouji-openwrt-passwall.git ./package/passwall

echo "添加 passwall2"
git clone https://github.com/qqhpc/xiaorouji-openwrt-passwall2.git ./package/passwall2

echo "添加 helloworld"
sed -i "/helloworld/d" "feeds.conf.default" && git clone https://github.com/qqhpc/fw876-helloworld.git ./package/helloworld
# ssr-plus依赖sagernet-core,Sagernet内核和V2ray/Xray内核冲突

echo "添加 openclash"
cd ./package/
svn export https://github.com/qqhpc/vernesong-OpenClash/branches/dev/luci-app-openclash
cd ..

echo "下载 feeds"
./scripts/feeds update -a

echo "更新 go"
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

echo "安装 feeds"
./scripts/feeds install -a

echo "下载 config"
rm -rf .config
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/Lean/.config/lean.x86.ply.config.txt
mv lean.x86.ply.config.txt .config

echo "下载 dl"
make download -j2

echo "编译固件"
make -j$(expr $(nproc) + 1)  V=s
