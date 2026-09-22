#!/bin/bash

# === 1. aria2 + веб-интерфейс, отключить Transmission ===
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_ARIA=y/CONFIG_FIRMWARE_INCLUDE_ARIA=y/' build.config
sed -i 's/#CONFIG_FIRMWARE_INCLUDE_ARIA_WEB_CONTROL=y/CONFIG_FIRMWARE_INCLUDE_ARIA_WEB_CONTROL=y/' build.config
sed -i 's/CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/#CONFIG_FIRMWARE_INCLUDE_TRANSMISSION=y/' build.config

# === 2. Партиции: 16 МБ flash ===
PARTITIONS="padavan-ng/trunk/configs/boards/NEXX/WT3020H/partitions.config"
if [ -L "$PARTITIONS" ]; then
    ln -sf ../../pt_ralink_16m.config "$PARTITIONS"
    echo "partitions.config symlink changed to 16M"
elif [ -f "$PARTITIONS" ]; then
    sed -i 's/0x770000/0xF70000/g' "$PARTITIONS"
    sed -i 's/0x7C0000/0xFC0000/g' "$PARTITIONS"
    echo "partitions.config patched for 16M"
fi

# === 3. Ядро: 16 МБ flash ===
KERNEL_CFG="padavan-ng/trunk/configs/boards/NEXX/WT3020H/kernel-3.4.x.config"
if [ -f "$KERNEL_CFG" ]; then
    sed -i 's/# CONFIG_RT2880_FLASH_16M is not set/CONFIG_RT2880_FLASH_16M=y/' "$KERNEL_CFG"
    sed -i 's/CONFIG_RT2880_FLASH_8M=y/# CONFIG_RT2880_FLASH_8M is not set/' "$KERNEL_CFG"
    echo "kernel config patched for 16M"
fi

# === 4. Фикс мерцания: убираем CSS-переходы ===
WWW_DIR="padavan-ng/trunk/user/www/n56u_ribbon_fixed"

for CSS_FILE in "$WWW_DIR/bootstrap/css/main.css" \
                "$WWW_DIR/common-theme/css/main.css" \
                "$WWW_DIR/blue-theme/css/main.css" \
                "$WWW_DIR/grey-theme/css/main.css" \
                "$WWW_DIR/white-theme/css/main.css" \
                "$WWW_DIR/yellow-theme/css/main.css" \
                "$WWW_DIR/blue2-theme/css/main.css" \
                "$WWW_DIR/grey2-theme/css/main.css"; do
    if [ -f "$CSS_FILE" ]; then
        sed -i 's/transition:/transition: none !important;\/\* disabled: /g' "$CSS_FILE"
        sed -i 's/-webkit-transition:/-webkit-transition: none !important;\/\* disabled: /g' "$CSS_FILE"
        
        cat >> "$CSS_FILE" << 'CSSEOF'

/* === Anti-flicker fix for Yandex Browser === */
* {
    -webkit-transition: none !important;
    transition: none !important;
    -webkit-animation: none !important;
    animation: none !important;
    will-change: auto !important;
}
CSSEOF
        echo "anti-flicker patch applied to $CSS_FILE"
    fi
done

# === 5. Кастомный логотип ===
LOGO_SRC="kimax.png"
LOGO_DST="padavan-ng/trunk/user/www/n56u_ribbon_fixed/bootstrap/img/asus_logo.png"
if [ -f "$LOGO_SRC" ]; then
    cp "$LOGO_SRC" "$LOGO_DST"
    echo "custom logo installed: $LOGO_SRC -> $LOGO_DST"
    
    # Копируем во все темы
    for THEME_DIR in common-theme blue-theme grey-theme white-theme yellow-theme blue2-theme grey2-theme; do
        THEME_LOGO="padavan-ng/trunk/user/www/n56u_ribbon_fixed/$THEME_DIR/img/asus_logo.png"
        if [ -d "$(dirname "$THEME_LOGO")" ]; then
            cp "$LOGO_SRC" "$THEME_LOGO" 2>/dev/null && echo "logo copied to $THEME_DIR"
        fi
    done
else
    echo "WARNING: custom_logo.png not found, using default ASUS logo"
fi
