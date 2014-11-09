### Overview 

Manufactured by [Gumstix][gumstix], the Duovero COMs are small 
form-factor ARM boards based on the TI OMAP4430 Dual Cortex-A9
processor.

The Duovero COMS come in 2 flavors

*[Duovero Crystal][duovero-crystal] 
*[Duovero Zephyr][duovero-zephyr] - adds a Marvell Wifi/Bluetooth (supports AP) 

They each come with 1 GB of memory and boot from a microSD card.

The Duovero COMs require an expansion board for use.

I recommend the [Parlor][parlor] expansion board for getting
started.

The [Chateau][chateau] expansion board gives direct access to more
of the lines coming from the COM, but is less convenient when getting
started. 

Don't forget to get a 5V power supply from Gumstix for the expansion
board. At least for your first board. The power jack is not the standard
barrel size.

### Status

* The system recognizes both processors and all memory.
* The system boots from an SD card.
* Serial console (UART3) and UART2 are both working.
* The I2C busses and USB Host are recognized but I have not tested
either. (I don't know how to use either with FreeBSD ;-)
* Ethernet does not work. Needs a driver and setup in the dts.
* I haven't tried a Zephyr but I'm pretty sure (about 100% sure) that
Wifi/BT won't work since there is no definition for them in the dts.


The Duovero board is not explicitly supported by FreeBSD.

I started playing with it based on the existing *PANDABOARD* machine
in *CURRENT*.

I now have a proper *DUOVERO* board definition with some changes from
the original *PANDABOARD*.

You can follow the progress in this [duovero-freebsd][duovero-freebsd]
repository.

When I get a little further along, I'll provide a patch set to
*CURRENT* to make it easier to build.

Until then, I'll be posting the latest binary disk image from my
builds [here][download]. 

### Booting the Duovero 

1. Get a Parlor expansion board and power supply

2. Connect a USB serial cable to the console port (next to the
   power supply jack).
 
3. The serial console config is 115200,8N1

4. Copy the image to a microSD card (use *dd*) 

5. Power up


[duovero-freebsd]: https://github.com/scottellis/duovero-freebsd
[gumstix]: http://www.gumstix.com
[duovero-coms]: https://store.gumstix.com/index.php/category/43/
[duovero-crystal]: https://store.gumstix.com/index.php/products/285/
[duovero-zephyr]: https://store.gumstix.com/index.php/products/355/
[parlor]: https://store.gumstix.com/index.php/products/287/
[chateau]: https://store.gumstix.com/index.php/products/286/
[download]: http://www.jumpnowtek.com/downloads/freebsd/duovero/

