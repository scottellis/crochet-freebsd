board_setup Duovero 

WORKDIR=/work
FREEBSD_SRC=/usr/src-current

FREEBSD_BUILDWORLD_EXTRA_ARGS="-j10"
FREEBSD_BUILDKERNEL_EXTRA_ARGS="-j10"

option AutoSize
option UsrSrc

customize_freebsd_partition () {
    pw moduser root -V etc/ -w yes
    sed -i -e 's/^#PermitRootLogin no/PermitRootLogin yes/' etc/ssh/sshd_config
    cp usr/share/zoneinfo/EST5EDT etc/localtime
    cat etc/motd | head -2 > etc/motd
}

