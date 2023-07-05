#!/bin/bash -e

SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname "$(realpath "$0")")}"
SDK_DIR="${SDK_DIR:-$SCRIPTS_DIR/../../../..}"

cd "$SDK_DIR"

for c in $(find device/rockchip/.chips/ \
	-mindepth 2 -maxdepth 2 -type f -name "rockchip_*_defconfig"); do
	./build.sh $c
	make savedefconfig
	sed -i '/RK_KERNEL_VERSION/d' $c
done
