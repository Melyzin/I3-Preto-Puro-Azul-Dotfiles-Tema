#!/bin/bash

# Atualiza o sistema
sudo pacman -Syu --noconfirm

# Habilita multilib, se ainda não estiver
sudo sed -i '/\[multilib\]/,/Include/ s/^#//' /etc/pacman.conf

# Adiciona repositório do CachyOS
echo -e "\n[cachyos]\nSigLevel = Optional TrustAll\nServer = https://mirror.cachyos.org/$repo/$arch" | sudo tee -a /etc/pacman.conf
sudo pacman -Syy

# Instala o kernel CachyOS
sudo pacman -S --noconfirm linux-cachyos linux-cachyos-headers

# Instala dependências principais
sudo pacman -S --noconfirm \
  i3-gaps rofi polybar picom dunst \
  kitty fish ufw \
  neofetch lxappearance papirus-icon-theme \
  xorg xorg-xinit xorg-xset xterm \
  git unzip wget curl firefox \
  gvfs thunar thunar-archive-plugin file-roller \
  ttf-jetbrains-mono ttf-font-awesome \
  base-devel

# Define o fish como shell padrão
chsh -s /usr/bin/fish

# Ativa o firewall
sudo systemctl enable ufw
sudo ufw enable

# Clona os dotfiles do Keyitdev
cd ~
git clone https://github.com/Keyitdev/dotfiles.git
cp -r dotfiles/.config ~/
cp -r dotfiles/.fonts ~/
cp dotfiles/.xinitrc ~/

# Instala o Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
mkdir chrome-extract && bsdtar -xf chrome.deb -C chrome-extract
sudo cp -r chrome-extract/opt/google/chrome /opt/google/
sudo ln -sf /opt/google/chrome/google-chrome /usr/bin/google-chrome
rm -rf chrome*

# Aplica tema AMOLED com azul
sed -i 's/#282c34/#000000/g' ~/.config/polybar/colors.ini
sed -i 's/#61afef/#3b82f6/g' ~/.config/polybar/colors.ini
sed -i 's/#282c34/#000000/g' ~/.config/rofi/config.rasi
sed -i 's/#61afef/#3b82f6/g' ~/.config/rofi/config.rasi
sed -i 's/#282c34/#000000/g' ~/.config/i3/config
sed -i 's/#61afef/#3b82f6/g' ~/.config/i3/config

# Finaliza
echo "Instalação completa! Reinicie o sistema e use 'startx' para iniciar o i3."
