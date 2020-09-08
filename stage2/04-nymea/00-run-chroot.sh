# Add nymea repository
echo -e "\n## nymea repo\ndeb http://repository.nymea.io buster rpi\n#deb-src http://repository.nymea.io buster rpi" | tee /etc/apt/sources.list.d/nymea.list
wget -qO - http://repository.nymea.io/repository-pubkey.gpg | apt-key add -

# Set repository priority (prefer packages from raspbian section)
cat <<EOM >/etc/apt/preferences.d/nymea
Package: *
Pin: release c=raspbian
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
nymea - nymea.io | Debian GNU/Linux 10
EOM

cat <<EOM > /etc/issue
nymea - nymea.io | Debian GNU/Linux 10  \n \l
EOM

# Change hostname to nymea
echo nymea > /etc/hostname
sed -i 's/localhost/localhost nymea/' /etc/hosts

# Enable i2c
echo dtparam=i2c_arm=on >> /boot/config.txt
echo i2c-dev >> /etc/modules

# Rotate internal display by default
echo lcd_rotate=2 >> /boot/config.txt

# Enable fake KMS driver
echo dtoverlay=vc4-fkms-v3d >> /boot/config.txt

# Get away with the low voltage warning
echo avoid_warnings=1 >> /boot/config.txt

# Enable ttyS0 uart on GPIO header
echo enable_uart=1 >> /boot/config.txt

# Drop packages conflicting with network-manager
apt-get purge --yes openresolv dhcpcd5

# Disable BlueZ plugins QtBluetooth can't deal with
mkdir /etc/systemd/system/bluetooth.service.d
cat <<EOM > /etc/systemd/system/bluetooth.service.d/01-disable-battery-plugin.conf
[Service]
ExecStart=
ExecStart=/usr/lib/bluetooth/bluetoothd  --noplugin=battery,sap
EOM
