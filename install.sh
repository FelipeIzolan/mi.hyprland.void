cat << 'EOF'

| mi.void              |
| *wayland + hyprland* |

EOF

read -p "- Graphics Driver -"$'\n\n'" 0: Intel"$'\n'" 1: AMD"$'\n\n'" Enter: " driver

if [ $driver -ne "0" -a $driver -ne "1" ]; then
  echo " Invalid: $driver"
  exit
fi

echo repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc | sudo tee /etc/xbps.d/hyprland-void.conf

sudo xbps-install -Sy

sudo xbps-install linux-firmware-$([[ $driver =  "0" ]] && echo "intel" || echo "amd") mesa-dri
sudo xbps-install -y dbus turnstile seatd

sudo xbps-install -y hyprland hyprland-qtutils xdg-desktop-portal-hyprland 
sudo xbps-install -y Waybar wbg foot fuzzel
sudo xbps-install -y noto-fonts-ttf

sudo xbps-install -y wireplumber pipewire
sudo xbps-install -y wl-clipboard

sudo ln -s /etc/sv/dbus /var/service
sudo ln -s /etc/sv/seatd /var/service
sudo ln -s /etc/sv/turnstiled /var/service

sudo xbps-install -y xdg-user-dirs
xdg-user-dirs-update
sudo xbps-remove -y xdg-user-dirs
 
mkdir -p ~/.cache
mkdir -p ~/.local/share/fonts
mkdir -p ~/.config/service/dbus
mkdir -p ~/.local/share/icons

sudo chmod -R 777 ~/.cache

sudo groupadd _seatd
sudo usermod -a -G _seatd $(whoami)

cp -fv ./resources/wallpaper.png ~/wallpaper.png
cp -fv ./resources/JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf
cp -TRfv ./resources/Bibata-Modern-Ice ~/.local/share/icons/Bibata-Modern-Ice
cp -TRfv ./.config ~/.config

ln -s /usr/share/examples/turnstile/dbus.run ~/.config/service/dbus/run
