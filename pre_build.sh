#!/bin/bash

# --- aria2 + веб-интерфейс, отключить Transmission ---
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_ARIA=y/CONFIG_FIRMWARE_INCLUDE_ARIA=y/' build.config
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_ARIA_WEB_CONTROL=y/CONFIG_FIRMWARE_INCLUDE_ARIA_WEB_CONTROL=y/' build.config
sed -i 's/CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/#CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/' build.config

# --- Файловые системы для USB-HDD ---
sed -i 's/#CONFIG_FIRMWARE_ENABLE_EXT3/CONFIG_FIRMWARE_ENABLE_EXT3/' build.config
sed -i 's/#CONFIG_FIRMWARE_ENABLE_EXT2/CONFIG_FIRMWARE_ENABLE_EXT2/' build.config
sed -i 's/#CONFIG_FIRMWARE_ENABLE_XFS/CONFIG_FIRMWARE_ENABLE_XFS/' build.config
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_NFSD/CONFIG_FIRMWARE_INCLUDE_NFSD/' build.config
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_HDPARM/CONFIG_FIRMWARE_INCLUDE_HDPARM/' build.config

# --- Ядро: включить 16 МБ flash ---
KERNEL_CFG="padavan-ng/trunk/configs/boards/NEXX/WT3020H/kernel-3.4.x.config"
sed -i 's/# CONFIG_RT2880_FLASH_16M is not set/CONFIG_RT2880_FLASH_16M=y/' "$KERNEL_CFG"
sed -i 's/CONFIG_RT2880_FLASH_8M=y/# CONFIG_RT2880_FLASH_8M is not set/' "$KERNEL_CFG"

# --- Партиции: переключить симлинк на 16 МБ ---
PARTITIONS="padavan-ng/trunk/configs/boards/NEXX/WT3020H/partitions.config"
if [ -L "$PARTITIONS" ]; then
    ln -sf ../../pt_ralink_16m.config "$PARTITIONS"
fi
