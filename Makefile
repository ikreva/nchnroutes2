## 设置代理 例：socks5://127.0.0.1:1080
proxy=

## 设置下一跳接口名 例：tun0, 默认tun0
next=tun0

## 设置需要排除的 IPv4 IPv6 ,多个IP空格隔开
exclude=

## 设置使用IPv4 中国列表，可以选择 geoip chnroutes2 apnic , 默认 geoip
ipv4-list=


ifdef proxy
    proxy := --proxy $(proxy)
endif

ifdef next
    next := --next $(next)
endif

ifdef exclude
    exclude := --exclude $(exclude)
endif

ifdef ipv4-list
    ipv4-list := --ipv4-list $(ipv4-list)
endif

produce:
	curl $(proxy) --retry 5 -C - -o ipv4-address-space.csv https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv
	curl $(proxy) --retry 5 -C - -o delegated-apnic-latest https://ftp.apnic.net/stats/apnic/delegated-apnic-latest
	curl $(proxy) --retry 5 -C - -o geoip_cn.txt https://gh.cooluc.com/https://raw.githubusercontent.com/Loyalsoldier/geoip/release/text/cn.txt
	curl $(proxy) --retry 5 -C - -o chnroutes2.txt https://gh.cooluc.com/https://raw.githubusercontent.com/misakaio/chnroutes2/master/chnroutes.txt

	python3 produce.py $(next) $(exclude) $(ipv4-list)
	# mv routes4.conf /etc/bird/routes4.conf
	# mv routes6.conf /etc/bird/routes6.conf
	# birdc configure
	# birdc6 configure
