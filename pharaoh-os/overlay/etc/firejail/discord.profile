include /etc/firejail/disable-common.inc
include /etc/firejail/disable-secret.inc
private-bin flatpak
private-etc resolv.conf
whitelist ${HOME}/.var/app/com.discordapp.Discord
caps.drop all
seccomp
netfilter
