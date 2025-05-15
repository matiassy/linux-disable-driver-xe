#!/bin/bash
# Script para deshabilitar el driver xe de Intel y forzar el uso de i915
# Compatible con GPU Intel Alder Lake y kernel >= 6.8

echo "🔧 Deshabilitando driver xe..."
echo "blacklist xe" | sudo tee /etc/modprobe.d/blacklist-xe.conf

echo "✅ Asegurando que se cargue i915 en el arranque..."
grep -q '^i915$' /etc/initramfs-tools/modules || echo "i915" | sudo tee -a /etc/initramfs-tools/modules

echo "🛠️ Editando parámetros de GRUB..."
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.modeset=1"/' /etc/default/grub

echo "🔄 Actualizando GRUB e initramfs..."
sudo update-grub
sudo update-initramfs -u

echo "✅ Listo. Se requiere reiniciar el sistema para aplicar los cambios."
read -p "¿Querés reiniciar ahora? (s/n): " resp
if [[ "$resp" =~ ^[sS]$ ]]; then
  sudo reboot
else
  echo "🔁 Podés reiniciar más tarde con: sudo reboot"
fi
