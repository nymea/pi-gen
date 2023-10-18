# Add nymea repository
echo -e "\n## nymea repo\ndeb http://repository.nymea.io/experimental bookworm main\n#deb-src http://repository.nymea.io/experimental booworm main" | tee /etc/apt/sources.list.d/nymea.list
wget -O /etc/apt/trusted.gpg.d/nymea.gpg https://repository.nymea.io/nymea.gpg

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
nymea - nymea.io | Debian GNU/Linux 12
EOM

cat <<EOM > /etc/issue
nymea - nymea.io | Debian GNU/Linux 12  \n \l
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

# Disable BlueZ plugins QtBluetooth can't deal with
mkdir /etc/systemd/system/bluetooth.service.d
cat <<EOM > /etc/systemd/system/bluetooth.service.d/01-disable-battery-plugin.conf
[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd  --noplugin=battery,sap
EOM
