#!/bin/bash

# --- aria2 + веб-интерфейс, отключить Transmission ---
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_ARIA=y/CONFIG_FIRMWARE_INCLUDE_ARIA=y/' build.config
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_ARIA_WEB_CONTROL=y/CONFIG_FIRMWARE_INCLUDE_ARIA_WEB_CONTROL=y/' build.config
sed -i 's/CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/#CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/' build.config

# --- Партиции: переключить симлинк на 16 МБ ---
PARTITIONS="padavan-ng/trunk/configs/boards/NEXX/WT3020H/partitions.config"
if [ -L "$PARTITIONS" ]; then
    ln -sf ../../pt_ralink_16m.config "$PARTITIONS"
    echo "partitions.config symlink changed to 16M"
elif [ -f "$PARTITIONS" ]; then
    sed -i 's/0x770000/0xF70000/g' "$PARTITIONS"
    sed -i 's/0x7C0000/0xFC0000/g' "$PARTITIONS"
    echo "partitions.config patched for 16M"
fi

# --- Ядро: включить 16 МБ flash ---
KERNEL_CFG="padavan-ng/trunk/configs/boards/NEXX/WT3020H/kernel-3.4.x.config"
if [ -f "$KERNEL_CFG" ]; then
    sed -i 's/# CONFIG_RT2880_FLASH_16M is not set/CONFIG_RT2880_FLASH_16M=y/' "$KERNEL_CFG"
    sed -i 's/CONFIG_RT2880_FLASH_8M=y/# CONFIG_RT2880_FLASH_8M is not set/' "$KERNEL_CFG"
    echo "kernel config patched for 16M"
fi
