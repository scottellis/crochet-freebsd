board_setup PandaBoard 

WORKDIR=/work
FREEBSD_SRC=/usr/home/scott/src-current

FREEBSD_BUILDWORLD_EXTRA_ARGS="-j10"
FREEBSD_BUILDKERNEL_EXTRA_ARGS="-j10"

option AutoSize

# uncomment these together
# option UsrSrc
# IMAGE_SIZE=$((4096 * 1000 * 1000))

customize_freebsd_partition () {
    pw moduser root -V etc/ -w yes
    sed -i -e 's/^#PermitRootLogin no/PermitRootLogin yes/' etc/ssh/sshd_config
    cp usr/share/zoneinfo/EST5EDT etc/localtime
    cat etc/motd | head -2 > etc/motd
}

