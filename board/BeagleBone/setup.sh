KERNCONF=BEAGLEBONE
UBOOT_BINDIR=/usr/local/share/u-boot/u-boot-beaglebone
IMAGE_SIZE=$((1024 * 1000 * 1000))
TARGET_ARCH=armv6

#
# BeagleBone requires a FAT partition to hold the boot loader bits.
#
beaglebone_partition_image ( ) {
    disk_partition_mbr
    disk_fat_create 64m
    disk_ufs_create
}
strategy_add $PHASE_PARTITION_LWW beaglebone_partition_image

#
# BeagleBone uses U-Boot.
#
beaglebone_check_uboot ( ) {
    if [ ! -f ${UBOOT_BINDIR}/MLO ]; then
        echo "${UBOOT_BINDIR}/MLO not found"
        echo "Please build port: sysutils/u-boot-beaglebone"
        exit 1
    fi

    if [ ! -f ${UBOOT_BINDIR}/u-boot.img ]; then
        echo "${UBOOT_BINDIR}/u-boot.img not found"
        echo "Please build port: sysutils/u-boot-beaglebone"
        exit 1
    fi

    echo "Found sysutils/u-boot-beaglebone binaries"
}
strategy_add $PHASE_CHECK beaglebone_check_uboot

beaglebone_uboot_install ( ) {
    # Current working directory is set to BOARD_BOOT_MOUNTPOINT
    echo "Installing U-Boot onto the boot partition"
    cp ${UBOOT_BINDIR}/MLO .
    cp ${UBOOT_BINDIR}/u-boot.img .
}
strategy_add $PHASE_BOOT_INSTALL beaglebone_uboot_install

#
# BeagleBone uses ubldr
#
strategy_add $PHASE_BUILD_OTHER freebsd_ubldr_build UBLDR_LOADADDR=0x88000000
strategy_add $PHASE_BOOT_INSTALL freebsd_ubldr_copy_ubldr ubldr

# Install the kernel on the FreeBSD UFS partition.
strategy_add $PHASE_FREEBSD_BOARD_INSTALL board_default_installkernel .

# ubldr help and config files go on the UFS partition (after boot dir exists)
strategy_add $PHASE_FREEBSD_BOARD_INSTALL freebsd_ubldr_copy_ubldr_help boot

#
# Make a /boot/msdos directory so the running image
# can mount the FAT partition.  (See overlay/etc/fstab.)
#
strategy_add $PHASE_FREEBSD_BOARD_INSTALL mkdir boot/msdos

