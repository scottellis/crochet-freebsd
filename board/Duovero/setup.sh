KERNCONF=DUOVERO
DUOVERO_UBOOT_SRC=${TOPDIR}/u-boot-2014.10
IMAGE_SIZE=$((1024 * 1000 * 1000))
TARGET_ARCH=armv6

#
# Duovero uses MBR image with 64mb FAT partition for booting.
#
duovero_partition_image ( ) {
    disk_partition_mbr
    disk_fat_create 64m
    disk_ufs_create
}
strategy_add $PHASE_PARTITION_LWW duovero_partition_image

#
# Duovero uses U-Boot
#
duovero_check_prerequisites ( ) {
    uboot_set_patch_version ${DUOVERO_UBOOT_SRC} ${DUOVERO_UBOOT_PATCH_VERSION}

    uboot_test \
        DUOVERO_UBOOT_SRC \
        "${DUOVERO_UBOOT_SRC}/board/gumstix/duovero/Makefile"
    strategy_add $PHASE_BUILD_OTHER uboot_patch ${DUOVERO_UBOOT_SRC} `uboot_patch_files`
    strategy_add $PHASE_BUILD_OTHER uboot_configure ${DUOVERO_UBOOT_SRC} duovero_config
    strategy_add $PHASE_BUILD_OTHER uboot_build ${DUOVERO_UBOOT_SRC}
}
strategy_add $PHASE_CHECK duovero_check_prerequisites

duovero_install_uboot ( ) {
    # Current working directory is set to BOARD_BOOT_MOUNTPOINT
    echo "Installing U-Boot onto the boot partition"
    cp ${DUOVERO_UBOOT_SRC}/MLO .
    cp ${DUOVERO_UBOOT_SRC}/u-boot.img .
}
strategy_add $PHASE_BOOT_INSTALL duovero_install_uboot

#
# Duovero uses ubldr
#
strategy_add $PHASE_BUILD_OTHER freebsd_ubldr_build UBLDR_LOADADDR=0x88000000
strategy_add $PHASE_BOOT_INSTALL freebsd_ubldr_copy_ubldr ubldr


# Install the kernel on the FreeBSD UFS partition.
strategy_add $PHASE_FREEBSD_BOARD_INSTALL board_default_installkernel .

# ubldr help file goes on the UFS partition (after boot dir exists)
strategy_add $PHASE_FREEBSD_BOARD_INSTALL freebsd_ubldr_copy_ubldr_help boot

#
# Make a /boot/msdos directory so the running image
# can mount the FAT partition.  (See overlay/etc/fstab.)
#
strategy_add $PHASE_FREEBSD_BOARD_INSTALL mkdir boot/msdos
