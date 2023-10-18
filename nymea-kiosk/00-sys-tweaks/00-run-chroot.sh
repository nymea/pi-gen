# Rotate internal display by default
echo lcd_rotate=2 >> /boot/config.txt

# Enable fake KMS driver, the real kms causes issues
sed -i 's/vc4-kms-v3d/vc4-fkms-v3d/' /boot/config.txt

# Get away with the low voltage warning
echo avoid_warnings=1 >> /boot/config.txt

# Hide console log messages and blinking cursor and activate the splash
sed -i "s/console=tty1/console=tty3 quiet vt.global_cursor_default=0 splash/" "/boot/cmdline.txt"
