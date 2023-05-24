Bye Bye BIOS
============

The x86 platform has traditionally used the "BIOS" firmware for booting
machines. Modern physical hardware has essentially completed the transition
over to UEFI firmware instead. Virtual machines, however, have been slower
to adapt and so while UEFI is increasingly available as an option, it may
not always be the default. Where it is the default, users may intentionally
or inadvertantly boot machines with BIOS firmware (or equivalently UEFI CSM
mode). If the operating system install has not installed any code in the
boot sector, users will be faced with a non-bootable system giving little
indication of the problem.

This project aims to aid users in understanding their deployment mistake,
by providing a x86 boot sector that prints a message to both the VGA console
and first serial port, informing them that the installation required UEFI
firmware.

The code is placed under the `MIT No Attribution` license (SPDX: `MIT-0`)

Build and install
-----------------

The code is written for the GNU assembler and can be built using the provided
makefile::

  $ make
  $ sudo make install

Or in a virtual root::

  $ sudo make install DESTDIR=/some/virtual/root

Usage example
-------------

The command ``byebyebios`` will modify a disk image to install the custom
boot stub with a informative message::

  $ byebyebios somedisk.img

The informative message can be customized by providing a text file, with
DOS line endings (\r\n)::

  $ echo "Go Away" | figlet | unix2dos > goaway.txt
  $ byebyebios -m goaway.txt somedisk.img

The behaviour can be demostrated using the QEMU emulator::

  $ qemu-system-x86_64 -nodefaults -device VGA -serial stdio \
      -drive file=somedisk.img,if=ide,format=raw

  STOP: Machine was booted from BIOS or UEFI CSM
   _   _          _   _ ___________ _____   ___
  | \ | |        | | | |  ___|  ___|_   _| |__ \
  |  \| | ___    | | | | |__ | |_    | |      ) |
  | . ` |/ _ \   | | | |  __||  _|   | |     / /
  | |\  | (_) |  | |_| | |___| |    _| |_   |_|
  \_| \_/\___/    \___/\____/\_|    \___/   (_)

  Installation requires UEFI firmware to boot
