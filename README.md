# 🛠️ Intel GPU Fix: Deshabilitar driver `xe` y forzar `i915` en Linux (Kernel 6.8+)

Este script soluciona un problema común con mini PCs modernas con GPU Intel Alder Lake y dos monitores, donde el sistema solo detecta uno de ellos como "None-1", espejando la pantalla o sin permitir configuraciones extendidas.

## 📌 ¿Por qué sucede?

A partir del kernel **6.8+**, algunas distribuciones (como Ubuntu/Kubuntu 22.04+) comenzaron a usar el nuevo driver de Intel llamado `xe` para GPUs modernas (como la **8086:4626** de Alder Lake). Este reemplaza parcialmente al conocido driver `i915`, pero aún presenta **problemas de compatibilidad** con:

- Soporte multi-monitor
- DisplayPort/HDMI en configuraciones extendidas
- Detección de monitores correctamente

## 🧩 Solución

Este script:

- Desactiva (`blacklist`) el módulo `xe`
- Fuerza la carga del driver clásico `i915`
- Ajusta GRUB para usar `i915.modeset=1`
- Regenera `initramfs` y `grub`
- Ofrece reiniciar al final

## ⚙️ Requisitos

- Linux con kernel **6.8 o superior**
- GPU Intel Alder Lake-P u otra que use el driver `xe`
- Permisos `sudo`

---

## 🚀 Uso

### 1. Clonar el repositorio

git clone https://github.com/TU_USUARIO/intel-gpu-i915-fix.git
cd intel-gpu-i915-fix


### 2. Dar permisos y ejecutar el script

chmod +x fix-intel-gpu-xe-block.sh
./fix-intel-gpu-xe-block.sh

### 3. Reiniciar el sistema cuando se te indique
🧪 Verificación

Después del reinicio, ejecutá:

xrandr

Deberías ver ambos monitores con nombres reales como HDMI-1 y DP-1, en lugar de None-1.

También podés revisar:

ls /sys/class/drm/

Y confirmar que aparecen correctamente:

card0
card0-HDMI-A-1
card0-DP-1
...

### 🛟 Nota

Si en el futuro el driver xe mejora o se requiere por otras razones, podés revertir los cambios eliminando el archivo:

sudo rm /etc/modprobe.d/blacklist-xe.conf

Y restaurando GRUB con:

sudo nano /etc/default/grub
# Restaurar línea GRUB_CMDLINE_LINUX_DEFAULT a "quiet splash"
sudo update-grub
sudo update-initramfs -u
sudo reboot
