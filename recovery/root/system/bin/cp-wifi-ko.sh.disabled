#!/system/bin/sh

LOGFILE=/tmp/recovery.log

log_print() {
    echo "$1" >> "$LOGFILE"
    echo "$1"
}

try_insmod() {
    MODPATH="$1"
    if [ -n "$MODPATH" ] && [ -f "$MODPATH" ]; then
        insmod "$MODPATH" 2>/dev/null
        log_print "cp-wifi-ko.sh: insmod attempted: $MODPATH"
    else
        log_print "cp-wifi-ko.sh: module missing: $MODPATH"
    fi
}

find_mod() {
    MODNAME="$1"
    find /vendor_dlkm /system_dlkm -type f -name "$MODNAME" 2>/dev/null | head -n 1
}

is_mounted() {
    mount | grep -q " on $1 "
}

mkdir -p /vendor_dlkm /system_dlkm /tmp/recovery /tmp/recovery/sockets
chmod 0777 /tmp/recovery 2>/dev/null
chmod 0777 /tmp/recovery/sockets 2>/dev/null

SLOT="$(getprop ro.boot.slot_suffix)"
VENDOR_DLKM_DEV="/dev/block/mapper/vendor_dlkm${SLOT}"
SYSTEM_DLKM_DEV="/dev/block/mapper/system_dlkm${SLOT}"

[ -e "$VENDOR_DLKM_DEV" ] || VENDOR_DLKM_DEV="/dev/block/mapper/vendor_dlkm"
[ -e "$SYSTEM_DLKM_DEV" ] || SYSTEM_DLKM_DEV="/dev/block/mapper/system_dlkm"

log_print "cp-wifi-ko.sh: slot=${SLOT}"
log_print "cp-wifi-ko.sh: VENDOR_DLKM_DEV=${VENDOR_DLKM_DEV}"
log_print "cp-wifi-ko.sh: SYSTEM_DLKM_DEV=${SYSTEM_DLKM_DEV}"

for i in 1 2 3 4 5 6 7 8 9 10; do
    [ -e "$VENDOR_DLKM_DEV" ] && [ -e "$SYSTEM_DLKM_DEV" ] && break
    log_print "cp-wifi-ko.sh: waiting for dlkm mapper nodes ($i)"
    sleep 1
done

if ! is_mounted /vendor_dlkm; then
    if [ -e "$VENDOR_DLKM_DEV" ]; then
        mount -t ext4 "$VENDOR_DLKM_DEV" /vendor_dlkm 2>/dev/null && \
        log_print "cp-wifi-ko.sh: vendor_dlkm mounted"
    else
        log_print "cp-wifi-ko.sh: vendor_dlkm not found"
    fi
fi

if ! is_mounted /system_dlkm; then
    if [ -e "$SYSTEM_DLKM_DEV" ]; then
        mount -t ext4 "$SYSTEM_DLKM_DEV" /system_dlkm 2>/dev/null && \
        log_print "cp-wifi-ko.sh: system_dlkm mounted"
    else
        log_print "cp-wifi-ko.sh: system_dlkm not found"
    fi
fi

if ! is_mounted /vendor_dlkm || ! is_mounted /system_dlkm; then
    log_print "cp-wifi-ko.sh: retrying dlkm mount after delay"
    sleep 3

    if ! is_mounted /vendor_dlkm && [ -e "$VENDOR_DLKM_DEV" ]; then
        mount -t ext4 "$VENDOR_DLKM_DEV" /vendor_dlkm 2>/dev/null && \
        log_print "cp-wifi-ko.sh: vendor_dlkm mounted on retry"
    fi

    if ! is_mounted /system_dlkm && [ -e "$SYSTEM_DLKM_DEV" ]; then
        mount -t ext4 "$SYSTEM_DLKM_DEV" /system_dlkm 2>/dev/null && \
        log_print "cp-wifi-ko.sh: system_dlkm mounted on retry"
    fi
fi

try_insmod "$(find_mod rfkill.ko)"
try_insmod "$(find_mod libarc4.ko)"

for MOD in \
cnss_prealloc.ko \
cnss_nl.ko \
cnss_utils.ko \
wlan_firmware_service.ko \
cnss_plat_ipc_qmi_svc.ko \
icnss2.ko \
cnss2.ko \
cfg80211.ko \
mac80211.ko \
qca_cld3_qca6750.ko
do
    try_insmod "$(find_mod "$MOD")"
done

if [ -f /vendor/bin/cnss-daemon ]; then
    /vendor/bin/cnss-daemon -n -l >/dev/null 2>&1 &
    log_print "cp-wifi-ko.sh: cnss-daemon started"
fi

log_print "cp-wifi-ko.sh: WiFi modules loaded"
resetprop twrp.cpko true
exit 0
