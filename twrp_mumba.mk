#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/motorola/mumba

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

# Release name
PRODUCT_RELEASE_NAME := mumba

## Device identifier
PRODUCT_DEVICE := mumba
PRODUCT_NAME := twrp_mumba
PRODUCT_BRAND := Motorola
PRODUCT_MODEL := MotorolaG57Power
PRODUCT_MANUFACTURER := Motorola

# Assert
TARGET_OTA_ASSERT_DEVICE := mumba

# Theme
TW_STATUS_ICONS_ALIGN := center
#TW_Y_OFFSET := 99
#TW_H_OFFSET := -99
