Crochet is a tool for building bootable FreeBSD images.

This [duovero] branch has only been tested with CURRENT.

The Duovero and PandaBoard builds assume a u-boot already
built with ports.

I am not using xdev tools.

The builds also assume patches from [duovero-freebsd][duovero-freebsd]
have been applied to the source tree.

The Wandboards scripts have NOT been updated to use a u-boot
built with ports. (TODO)

Duovero, PandaBoard and Wandboards are the only boards I
have been working with.

BeagleBone and RPi are also on the TODO.

[duovero-freebsd]: https://github.com/scottellis/duovero-freebsd
