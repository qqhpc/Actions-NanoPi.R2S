#!/bin/bash
# 2022.11.15

pwd

echo "开始下载openwrt源码"
git clone -b openwrt-22.03 https://github.com/openwrt/openwrt.git openwrt
echo "/workdir/openwrt的内容"
s /workdir/openwrt
ln -sf /workdir/openwrt $GITHUB_WORKSPACE/openwrt
echo "源码下载完成"

cd /workdir/openwrt

echo "添加 passwall"
git clone -b packages https://github.com/xiaorouji/openwrt-passwall.git ./package/passwall
git clone -b luci https://github.com/xiaorouji/openwrt-passwall.git ./package/luci-app-passwall
cp -r ./package/luci-app-passwall/luci-app-passwall ./package/passwall/
rm -rf ./package/luci-app-passwall

echo "添加 passwall2"
git clone https://github.com/xiaorouji/openwrt-passwall2.git ./package/passwall2

echo "添加 helloworld"
sed -i "/helloworld/d" "feeds.conf.default" && git clone https://github.com/fw876/helloworld.git ./package/helloworld
# ssr-plus的依赖:sagernet-core,Sagernet内核和V2ray/Xray内核冲突

echo "添加 openclash"
svn export https://github.com/vernesong/OpenClash/trunk/luci-app-openclash ./package/openclash

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
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/22.03/x86/64/openwrt-22.03-x86-sdant.config.txt
mv openwrt-22.03-x86-sdant.config.txt .config

echo "下载 dl"
make download -j2 V=s && make download -j2 V=s && find dl -size -1024c -exec rm -f {} ;
make download -j2 V=s

echo "编译固件"
make -j$(expr $(nproc) + 1)  V=s
