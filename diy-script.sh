#!/bin/bash

# 修改默认IP
sed -i 's/192.168.1.1/192.168.100.1/g' package/base-files/files/bin/config_generate

# 更改 Argon 主题背景
#cp -f $GITHUB_WORKSPACE/images/bg1.jpg feeds/luci/themes/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# 移除冲突文件
rm -rf feeds/packages/net/{alist,adguardhome,mosdns,xray*,v2ray*,v2ray*,sing-box*,smartdns,brook*,chinadns-ng,*dns2socks*,dns2tcp*shadowsocks-libev,*shadowsocks-rust,*simple-obfs,*tcping,*trojan-go.*trojan,*trojan-plus,*tuic-client,*hysteria}
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/packages/lang/golang
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/luci/applications/luci-app-argon
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-passwall



# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}


# 加入第三方源
git clone --depth=1 https://github.com/kenzok8/small package/small
git clone --depth=1 https://github.com/kenzok8/openwrt-packages package/kenzo


# 更换golong 1.22
git clone https://github.com/kenzok8/golang feeds/packages/lang/golang

sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default

# Alist
git clone https://github.com/sbwml/luci-app-alist -b lua package/alist

./scripts/feeds update -a
./scripts/feeds install -a
