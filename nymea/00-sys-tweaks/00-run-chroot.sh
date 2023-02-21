# Add nymea repository
echo -e "\n## nymea repo\ndeb http://repository.nymea.io bullseye rpi\n#deb-src http://repository.nymea.io bullseye rpi" | tee /etc/apt/sources.list.d/nymea.list
wget -qO - http://repository.nymea.io/Repository.key | apt-key add -

# Set repository priority (prefer packages from raspbian section)
cat <<EOM >/etc/apt/preferences.d/nymea
Package: *
Pin: release c=raspios
Pin-Priority: 700

Package: *
Pin: origin repository.nymea.io c=main
Pin-Priority: 500
EOM

apt-get update

cat <<EOM > /etc/motd

     .
     ++,
    |\`--\`+-.
     \`\`--\`-++. .;;+.
     \\\`\`--*++++;;;/@\\          _ __  _   _ _ __ ___   ___  __ _
      \\\`*#;.++++\\;+|/         | '_ \| | | | '_ \` _ \\ / _ \\/ _\` |
       \`-###+++++;\`           | | | | |_| | | | | | |  __/ (_| |
          /###+++             |_| |_|\__, |_| |_| |_|\___|\__,_|
          |+++#\`                      __/ |
          \`###+.                     |___/
           \`###+
             \`#+
               \`

EOM


cat <<EOM > /etc/machine-info
PRETTY_HOSTNAME=nymea
EOM

cat <<EOM > /etc/issue.net
nymea - nymea.io | Debian GNU/Linux 11
EOM

cat <<EOM > /etc/issue
nymea - nymea.io | Debian GNU/Linux 11  \n \l
EOM

# Change hostname to nymea
echo nymea > /etc/hostname
sed -i 's/localhost/localhost nymea/' /etc/hosts

# Enable i2c
echo dtparam=i2c_arm=on >> /boot/config.txt
echo i2c-dev >> /etc/modules

# Enable UART (For RaspBee and similar headers)
echo enable_uart=1 >> /boot/config.txt
sed -i 's/console=serial0,115200 //' /boot/cmdline.txt

# Drop packages conflicting with network-manager
apt-get purge --yes openresolv dhcpcd5

# Disable BlueZ plugins QtBluetooth can't deal with
mkdir /etc/systemd/system/bluetooth.service.d
cat <<EOM > /etc/systemd/system/bluetooth.service.d/01-disable-battery-plugin.conf
[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd  --noplugin=battery,sap
EOM
