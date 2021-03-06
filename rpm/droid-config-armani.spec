# These and other macros are documented in
# ../droid-configs-device/droid-configs.inc
%define device armani
%define vendor xiaomi
%define vendor_pretty Xiaomi
%define device_pretty Redmi 1S
%define dcd_path ./
# Adjust this for your device
%define pixel_ratio 1.25
# We assume most devices will
%define have_modem 1
%define community_adaptation 1
%define ofono_enable_plugins bluez5,hfp_ag_bluez5
%define ofono_disable_plugins bluez4,dun_gw_bluez4,hfp_ag_bluez4,hfp_bluez4,dun_gw_bluez5,hfp_bluez5

Provides: ofono-configs
%include droid-configs-device/droid-configs.inc
