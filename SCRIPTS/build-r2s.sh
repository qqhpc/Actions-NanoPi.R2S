#!/bin/bash
# 2022.09.08

pwd

cd /workdir/openwrt

echo "移除 SNAPSHOT 标签"
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in

echo "添加 passwall"
echo "src-git passwall https://github.com/qqhpc/xiaorouji-openwrt-passwall.git" >> feeds.conf.default

echo "添加 passwall2"
echo "src-git passwall2 https://github.com/qqhpc/xiaorouji-openwrt-passwall2.git" >> feeds.conf.default


echo "添加ssr-plus"
sed -i "/helloworld/d" "feeds.conf.default" && echo "src-git helloworld https://github.com/qqhpc/fw876-helloworld.git" >> feeds.conf.default
# ssr-plus依赖sagernet-core,Sagernet内核和V2ray/Xray内核冲突

echo "添加 openclash"
echo "src-git OpenClash https://github.com/qqhpc/vernesong-OpenClash.git" >> feeds.conf.default

echo "下载feeds"
./scripts/feeds update -a

echo "更新 go"
rm -rf feeds/packages/lang/golang
svn co https://github.com/openwrt/packages/branches/openwrt-22.03/lang/golang feeds/packages/lang/golang

echo "安装feeds"
./scripts/feeds install -a

echo "下载config"
wget https://raw.githubusercontent.com/qqhpc/configfiles/main/openwrt/22.03/rk3328/NanoPi-R2S/r2s.fq.config.txt
mv r2s.fq.config.txt .config

echo "下载dl"
make download -j2

echo "编译固件"
make -j$(expr $(nproc) + 1)  V=s
