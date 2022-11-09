#!/bin/bash

# Target arch
export RK_ARCH=arm64
# Uboot defconfig
export RK_UBOOT_DEFCONFIG=rk3326
# Kernel defconfig
export RK_KERNEL_DEFCONFIG=rk3326_linux_robot_defconfig
# Kernel dts
export RK_KERNEL_DTS=rk3326-evb-lp3-v10-robot-no-gpu-linux
# boot image type
export RK_BOOT_IMG=zboot.img
# kernel image path
export RK_KERNEL_IMG=kernel/arch/arm64/boot/Image.lz4
# parameter for GPT table
export RK_PARAMETER=parameter-robot.txt
# Buildroot config
export RK_CFG_BUILDROOT=rockchip_rk3326_robot64_no_gpu
# Recovery config
export RK_CFG_RECOVERY=rockchip_rk3326_robot_recovery
# Pcba config
export RK_CFG_PCBA=rockchip_rk3326_pcba
# target chip
export RK_TARGET_PRODUCT=rk3326
# Set rootfs type, including ext2 ext4 squashfs
export RK_ROOTFS_TYPE=squashfs
# Set oem partition type, including ext2 squashfs
export RK_OEM_FS_TYPE=ext2
# Set userdata partition type, including ext2, fat
export RK_USERDATA_FS_TYPE=ext2
#OEM config
export RK_OEM_DIR=oem_normal
#userdata config
export RK_USERDATA_DIR=userdata_normal
#misc image
export RK_MISC=wipe_all-misc.img
# Define WiFi BT chip
# Compatible with Realtek and AP6XXX WiFi : RK_WIFIBT_CHIP=ALL_AP
# Compatible with Realtek and CYWXXX WiFi : RK_WIFIBT_CHIP=ALL_CY
# Single WiFi configuration: AP6256 or CYW43455: RK_WIFIBT_CHIP=AP6256
export RK_WIFIBT_CHIP=AP6212A1
# Define BT ttySX
export RK_WIFIBT_TTY=ttyS1
