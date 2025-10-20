include /etc/firejail/disable-common.inc
include /etc/firejail/disable-secret.inc
noblacklist ${HOME}/.config/pharaohsearch
private-bin /usr/local/pharaoh/pharaohsearch/pharaohsearch
private-etc passwd,group,resolv.conf
read-only /usr
whitelist ${HOME}/.config/pharaohsearch
whitelist ${HOME}/.cache/pharaohsearch
caps.drop all
seccomp
netfilter
