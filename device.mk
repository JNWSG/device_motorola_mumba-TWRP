#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/mumba

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Configure virtual_ab compression.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Configure twrp common.mk
$(call inherit-product, vendor/twrp/config/common.mk)

PRODUCT_PACKAGES += \
    bootctrl.motorola_sm6435.recovery \
    android.hardware.boot@1.2-impl-qti.recovery

# API
PRODUCT_SHIPPING_API_LEVEL  := 35
PRODUCT_TARGET_VNDK_VERSION := 35
BOARD_SHIPPING_API_LEVEL := 35
SHIPPING_API_LEVEL := 35

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Required modules
TWRP_REQUIRED_MODULES += \
    moto_prebuilt

# FIX: Copy librecovery_updater directly into recovery system/lib64
# boot-service.qti.recovery needs it via libboot_control_qti.so
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/librecovery_updater.so:recovery/root/system/lib64/librecovery_updater.so \
    $(DEVICE_PATH)/recovery/root/vendor/lib64/librecovery_updater_msm.so:recovery/root/system/lib64/librecovery_updater_msm.so

# FIX: Place corrected manifest at vendor vintf path used by TWRP keymaster lookup
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/recovery/root/system/etc/vintf/manifest.xml:recovery/root/vendor/etc/vintf/manifest.xml
       
# Soong namespaces
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)
