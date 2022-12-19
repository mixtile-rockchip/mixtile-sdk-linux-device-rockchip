#!/bin/bash -e

BOARD=$(echo $RK_KERNEL_DTS_NAME | tr '[:lower:]' '[:upper:]')

build_all()
{
	echo "============================================"
	echo "TARGET_KERNEL_ARCH=$RK_KERNEL_ARCH"
	echo "TARGET_CHIP_FAMILY=$RK_CHIP_FAMILY"
	echo "TARGET_CHIP=$RK_CHIP"
	echo "TARGET_UBOOT_CONFIG=$RK_UBOOT_CFG"
	echo "TARGET_SPL_CONFIG=$RK_UBOOT_SPL_CFG"
	echo "TARGET_KERNEL_CONFIG=$RK_KERNEL_CFG"
	echo "TARGET_KERNEL_DTS=$RK_KERNEL_DTS_NAME"
	echo "TARGET_BUILDROOT_CONFIG=$RK_BUILDROOT_CFG"
	echo "TARGET_RECOVERY_CONFIG=$RK_RECOVERY_CFG"
	echo "TARGET_PCBA_CONFIG=$RK_PCBA_CFG"
	echo "TARGET_RAMBOOT=$RK_ROOTFS_INITRD"
	echo "============================================"

	rm -rf $RK_FIRMWARE_DIR
	mkdir -p $RK_FIRMWARE_DIR

	# NOTE: On secure boot-up world, if the images build with fit(flattened image tree)
	#       we will build kernel and ramboot firstly,
	#       and then copy images into u-boot to sign the images.
	if [ -z "$RK_SECURITY" ];then
		"$SCRIPTS_DIR/mk-loader.sh" loader
	fi

	"$SCRIPTS_DIR/mk-security.sh" security_check

	"$SCRIPTS_DIR/mk-kernel.sh"
	"$SCRIPTS_DIR/mk-rootfs.sh"
	"$SCRIPTS_DIR/mk-recovery.sh"

	if [ "$RK_SECURITY" ];then
		"$SCRIPTS_DIR/mk-loader.sh" loader
	fi

	finish_build
}

build_save()
{
	OUT_DIR="$RK_OUTDIR/$BOARD/$(date  +%Y%m%d_%H%M%S)"
	mkdir -p "$OUT_DIR"

	echo "Saving images..."
	mkdir -p "$OUT_DIR/kernel"
	cp kernel/.config "$OUT_DIR/kernel"
	cp kernel/vmlinux "$OUT_DIR/kernel"

	mkdir -p "$OUT_DIR/IMAGES/"
	cp "$RK_FIRMWARE_DIR"/* "$OUT_DIR/IMAGES/"

	echo "Saving patches..."
	mkdir -p "$OUT_DIR/PATCHES"
	.repo/repo/repo forall -j $(( $CPUS + 1 )) -c \
		"\"$SCRIPTS_DIR/save-patches.sh\" \
		\"$OUT_DIR/PATCHES/\$REPO_PATH\" \$REPO_PATH \$REPO_LREV"

	echo "Saving build info..."
	yes | ${PYTHON3:-python3} .repo/repo/repo manifest -r \
		-o "$OUT_DIR/manifest_${DATE}.xml"

	cp "$RK_FINAL_ENV" "$RK_CONFIG" "$RK_DEFCONFIG" "$OUT_DIR"/
	ln -rsf "$RK_CONFIG" "$OUT_DIR/build_info"

	echo "Saving build logs..."
	cp -r "$RK_LOG_DIR" $OUT_DIR

	finish_build
}

build_allsave()
{
	build_all
	"$SCRIPTS_DIR/mk-firmware.sh"
	"$SCRIPTS_DIR/mk-updateimg.sh"
	build_save

	finish_build
}

# Hooks

usage_hook()
{
	echo "all                - build all basic image"
	echo "save               - save images and build info"
	echo "allsave            - build all & firmware & updateimg & save"
}

clean_hook()
{
	rm -rf "$RK_OUTDIR"/$BOARD*
}

BUILD_CMDS="all allsave"
build_hook()
{
	case "$1" in
		all) build_all ;;
		allsave) build_allsave ;;
	esac
}

POST_BUILD_CMDS="save"
post_build_hook()
{
	build_save $@
}

source "${BUILD_HELPER:-$(dirname "$(realpath "$0")")/../build-hooks/build-helper}"

case "${1:-allsave}" in
	all) build_all ;;
	allsave) build_allsave ;;
	save) build_save ;;
	*) usage ;;
esac
