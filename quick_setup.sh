#!/bin/sh

echo 'Changing HandleLidSwitch'
sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
service systemd-logind restart

echo 'Configuring Wake on Lan'
apt install ethtool

echo "
# Reset WOL daily and after reboot
30 22 * * * root /sbin/ethtool -s enp3s0 wol g
@reboot root /sbin/ethtool -s enp3s0 wol g
" >> /etc/crontab

echo 'Configuring daily shutdown'
echo "
# shutdown every night
30 23 * * * root shutdown -h now
" >> /etc/crontab

echo 'Changing Proxmox subscription (only valid for stretch)'
cd /etc/apt/sources.list.d/

sed -i 's/deb/#deb/' pve-enterprise.list

echo 'deb http://download.proxmox.com/debian/pve stretch pve-no-subscription' > pve-no-subscription.list
