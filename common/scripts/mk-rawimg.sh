#!/bin/bash -e

RK_PROGRAMMER_TOOL="$RK_SDK_DIR/tools/linux/programming_image_tool/programmer_image_tool"

do_build_rawimg()
{
	check_config RK_UPDATE || false

	OUT_DIR="$RK_OUTDIR/raw"
	IMAGE_DIR="$OUT_DIR/Image"
	UPDATE_IMG="$RK_FIRMWARE_DIR/update.img"
	TARGET="$RK_FIRMWARE_DIR/raw.img"
	STORAGE_TYPE="${1:-emmc}"

	# Make sure that the update.img is ready
	if [ ! -r "$UPDATE_IMG" ]; then
		notice "update.img is not ready, building it..."
		"$RK_SCRIPTS_DIR/mk-updateimg.sh"
	fi

	message "=========================================="
	message "          Start packing raw image"
	message "=========================================="

	rm -rf "$TARGET" "$OUT_DIR"
	mkdir -p "$IMAGE_DIR"
	cd "$IMAGE_DIR"

	notice "Generating raw image from update.img for $STORAGE_TYPE..."

	if [ ! -x "$RK_PROGRAMMER_TOOL" ]; then
		error "programmer_image_tool not found or not executable at $RK_PROGRAMMER_TOOL"
		exit 1
	fi

	"$RK_PROGRAMMER_TOOL" -i "$UPDATE_IMG" -t "$STORAGE_TYPE" -o "$IMAGE_DIR"

	# Find the generated raw image
	RAW_IMG=$(ls -t out_image.bin 2>/dev/null | head -n1)
	if [ -z "$RAW_IMG" ] || [ ! -r "$RAW_IMG" ]; then
		error "Failed to generate raw image"
		exit 1
	fi

	# Rename the generated raw image to raw.img
	mv "$RAW_IMG" "raw.img"
	RAW_IMG="raw.img"

	ln -rsf "$IMAGE_DIR/$RAW_IMG" "$OUT_DIR/raw.img"
	ln -rsf "$IMAGE_DIR/$RAW_IMG" "$TARGET"

	notice "Raw image generated: $TARGET"
}

do_build_rawimg emmc
