#!/bin/bash

# Target arch
export RK_KERNEL_ARCH=arm64
# Uboot defconfig
export RK_UBOOT_DEFCONFIG=rk3308
# Kernel defconfig
export RK_KERNEL_DEFCONFIG=rk3308_robot_defconfig
# Kernel dts
export RK_KERNEL_DTS=rk3308-robot
# boot image type
export RK_BOOT_IMG=zboot.img
# kernel image path
export RK_KERNEL_IMG=kernel/arch/arm64/boot/Image.lz4
# parameter for GPT table
export RK_PARAMETER=parameter-64bit.txt
# Buildroot config
export RK_CFG_BUILDROOT=rockchip_rk3308_robot64
# Recovery config
export RK_CFG_RECOVERY=rockchip_rk3308_robot_recovery
# Pcba config
export RK_CFG_PCBA=rockchip_rk3308_pcba
# target chip
export RK_CHIP=rk3308
# Set rootfs type, including ext2 ext4 squashfs
export RK_ROOTFS_TYPE=squashfs
MIC_NUM=6
#misc image
export RK_MISC=wipe_all-misc.img
# Define WiFi BT chip
# # Compatible with Realtek and AP6XXX WiFi : RK_WIFIBT_CHIP=ALL_AP
# # Compatible with Realtek and CYWXXX WiFi : RK_WIFIBT_CHIP=ALL_CY
# # Single WiFi configuration: AP6256 or CYW43455: RK_WIFIBT_CHIP=AP6256
export RK_WIFIBT_CHIP=AP6255
# # Define BT ttySX
export RK_WIFIBT_TTY=ttyS0
# <dev>:<mount point>:<fs type>:<mount flags>:<source dir>:<image size(M|K|auto)>:[options]
export RK_EXTRA_PARTITIONS="oem:/oem:ext2:defaults:oem_empty:auto:resize@userdata:/userdata:ext2:defaults:userdata_empty:auto:resize"
