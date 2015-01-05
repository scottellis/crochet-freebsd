KERNCONF=DUOVERO
UBOOT_BINDIR=/usr/local/share/u-boot/u-boot-duovero
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
# Duovero uses U-Boot built with ports
#
duovero_check_prerequisites() {
    if [ ! -f ${UBOOT_BINDIR}/MLO ]; then
        echo "${UBOOT_BINDIR}/MLO not found"
        echo "Please build port: sysutils/u-boot-duovero"
        exit 1
    fi

    if [ ! -f ${UBOOT_BINDIR}/u-boot.img ]; then
        echo "${UBOOT_BINDIR}/u-boot.img not found"
        echo "Please build port: sysutils/u-boot-duovero"
        exit 1
    fi

    echo "Found sysutils/u-boot-duovero binaries"
}
strategy_add $PHASE_CHECK duovero_check_prerequisites

duovero_install_uboot ( ) {
    # Current working directory is set to BOARD_BOOT_MOUNTPOINT
    echo "Installing U-Boot onto the boot partition"
    cp ${UBOOT_BINDIR}/MLO .
    cp ${UBOOT_BINDIR}/u-boot.img .
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
