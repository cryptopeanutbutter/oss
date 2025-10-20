include /etc/firejail/disable-common.inc
include /etc/firejail/disable-secret.inc
private-bin flatpak
private-etc resolv.conf
whitelist ${HOME}/.var/app/com.valvesoftware.Steam
caps.drop all
seccomp
netfilter
