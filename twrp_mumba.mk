#
# Copyright (C) 2023 The Android Open Source Project
# Copyright (C) 2023 SebaUbuntu's TWRP device tree generator
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
#$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from mumba device
$(call inherit-product, device/motorola/mumba/device.mk)

PRODUCT_DEVICE := mumba
PRODUCT_NAME := twrp_mumba
PRODUCT_BRAND := motorola
PRODUCT_MODEL := motorola G57 Power
PRODUCT_MANUFACTURER := motorola

PRODUCT_GMS_CLIENTID_BASE := android-motorola

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_PRODUCT=mumba \
    PRIVATE_BUILD_DESC="mumba-user 15 WWAA36V.48-12-ST12.1 a0ae9 release-keys"
BUILD_FINGERPRINT := motorola/mumba/mumba:15/WWAA36V.48-12-ST12.1/a0ae9:user/release-keys
