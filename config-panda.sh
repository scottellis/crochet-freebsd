#
# Custom PandaBoard configuration
#
# Copy this to another file and use that when running Crochet, e.g.
#  $ sudo /bin/sh crochet.sh -c <myconfig>
#

board_setup PandaBoard

#PANDABOARD_UBOOT_SRC=${TOPDIR}/../u-boot-2012.07
PANDABOARD_UBOOT_SRC=${TOPDIR}/../u-boot-2014.10

option AutoSize

KERNCONF=PANDABOARD

#FREEBSD_SRC=/usr/src

WORKDIR=${TOPDIR}/work-panda

#IMG=${WORKDIR}/FreeBSD-${KERNCONF}.img

#FREEBSD_INSTALL_WORLD=y

