cat << 'EOF'

| mi.void              |
| *wayland + hyprland* |

EOF

read -p "- Graphics Driver -"$'\n\n'" 0: Intel"$'\n'" 1: AMD"$'\n\n'"Enter: " driver

if [ $driver -ne "0" -a $driver -ne "1" ]; then
  echo "Invalid: $driver"
  exit
fi

echo repository=https://raw.githubusercontent.com/Makrennel/hyprland-void/repository-x86_64-glibc | sudo tee /etc/xbps.d/hyprland-void.conf

sudo xbps-install -Sy

sudo xbps-install -y linux-firmware-$([[ $driver =  "0" ]] && echo "intel" || echo "amd") mesa-dri
sudo xbps-install -y dbus elogind polkit

sudo xbps-install -y hyprland hyprland-qtutils xdg-desktop-portal-hyprland 
sudo xbps-install -y wbg foot fuzzel Waybar

sudo xbps-install -y wireplumber pipewire
sudo xbps-install -y wl-clipboard

sudo ln -s /etc/sv/dbus /var/service
sudo rm /var/service/acpid
sudo rm /var/service/sshd

sudo xbps-install -y xdg-user-dirs
xdg-user-dirs-update
sudo xbps-remove -y xdg-user-dirs
 
mkdir -p ~/.cache
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/icons
sudo mkdir -p /etc/pipewire/pipewire.conf.d

sudo chmod -R 777 ~/.cache

cp -fv ./resources/wallpaper.png ~/wallpaper.png
cp -fv ./resources/JetBrainsMonoNerdFont-Regular.ttf ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf
cp -TRfv ./resources/Bibata-Modern-Ice ~/.local/share/icons/Bibata-Modern-Ice
cp -TRfv ./.config ~/.config

sudo ln -s /usr/share/examples/wireplumber/10-wireplumber.conf /etc/pipewire/pipewire.conf.d/
sudo ln -s /usr/share/examples/pipewire/20-pipewire-pulse.conf /etc/pipewire/pipewire.conf.d/
