#!/bin/sh
cd `dirname $0`
git reset --hard
git pull

git submodule update --init
for i in gfwlist genpac
do
	(cd $i;git pull origin master)
done

rm -rf env
virtualenv env
source env/bin/activate
# (cd genpac;python setup.py install) # 旧版genpac本地安装
# (cd genpac;pip install .) # 新版genpac本地安装

# 3.0rc1无法生成gfwlist，固定使用2.1.0版
(cd genpac; git checkout 4826281; python setup.py install) # 2.1.0版
# pip install genpac==2.1.0 # 备选在线安装

env/bin/genpac \
	--format pac \
	--pac-proxy "SOCKS5 127.0.0.1:1081" \
	--pac-precise \
	--gfwlist-url - \
	--gfwlist-local gfwlist/gfwlist.txt \
	--user-rule-from user-rule.txt \
	-o gfwlist_1081.pac
# sed -e '3d' -i gfwlist_1081.pac
# sed -e '5d' -e '3d' -i gfwlist_1081.pac # 删除带无用日期的注释

env/bin/genpac \
	--format pac \
	--pac-proxy "SOCKS5 127.0.0.1:7890" \
	--pac-precise \
	--gfwlist-url - \
	--gfwlist-local gfwlist/gfwlist.txt \
	--user-rule-from user-rule.txt \
	-o gfwlist_7890.pac
# sed -e '3d' -i gfwlist_7890.pac
# sed -e '5d' -e '3d' -i gfwlist_7890.pac # 删除带无用日期的注释

deactivate

git add .
git commit -m "[$(LANG=C date)]auto update"
git push -f origin master
