#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2025 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

#set -o xtrace
FDEVICE="mumba"

git clone https://github.com/LineageOS/android_hardware_qcom_bootctrl.git -b lineage-23.2-caf hardware/qcom-caf/bootctrl

TW_get_target_device() {
	export script_path="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
	if echo "$script_path" | grep -q "$FDEVICE"; then
		TW_BUILD_DEVICE="$FDEVICE"
	elif echo "$0" | grep -q "$FDEVICE"; then
		TW_BUILD_DEVICE="$FDEVICE"
	fi
}

if [ -z "$TW_BUILD_DEVICE" ]; then
	TW_get_target_device
fi

if [ "$TW_BUILD_DEVICE" = "$FDEVICE" ]; then
	echo "Detected build device: $TW_BUILD_DEVICE"

	# A/B Partition
	export TW_VIRTUAL_AB_DEVICE=1
	export TW_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export TW_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"

	# Compression Binaries & Tools
	export TW_USE_BASH_SHELL=1
	export TW_USE_NANO_EDITOR=1
	export TW_USE_TAR_BINARY=1
	export TW_USE_LZ4_BINARY=1
	export TW_USE_SED_BINARY=1
	export TW_USE_XZ_UTILS=1
	export TW_USE_ZSTD_BINARY=1
	export TW_DELETE_AROMAFM=1
	export TW_REMOVE_AAPT=1
	export TW_USE_BUSYBOX_BINARY=1
	export TW_USE_GREP_BINARY=1

	# KernelSU / Magisk Support
	export TW_USE_SPECIFIC_MAGISK_ZIP="$script_path/prebuilt/Magisk-v30.6.zip"
	export TW_MOVE_MAGISK_INSTALLER_TO_RAMDISK=1
	export TW_ENABLE_KERNELSU_SUPPORT=1
	export TW_ENABLE_KERNELSU_NEXT_SUPPORT=1
	export TW_ENABLE_SUKISU_SUPPORT=1

	# Settings
	export TW_VARIANT="CRYPTO"
	export TW_SETTINGS_ROOT_DIRECTORY="/persist"
	export TW_MAINTAINER_PATCH_VERSION="$(date -d "+40 minutes" +%Y%m%d%H%M)"
	export TW_ALLOW_EARLY_SETTINGS_LOAD=1
	export TW_RESET_SETTINGS="disabled"
else
	echo "I: vendorsetup.sh skipped; device mismatch or environment issue."
fi
