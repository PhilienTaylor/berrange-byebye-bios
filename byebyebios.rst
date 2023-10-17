.. SPDX-License-Identifier: MIT-0
.. SPDX-FileCopyrightText: 2023 Red Hat

==========
byebyebios
==========

------------------------
x86 boot sector injector
------------------------

:Manual section: 1
:Manual group: Virtualization Support

SYNOPSIS
========


``byebyebios`` [*OPTION*]... *RAW-DISK-IMAGE*

``byebyebios`` [*OPTION*]... *BLOCK-DEVICE*

DESCRIPTION
===========

The ``byebyebios`` tool is to be used when an operating
system installation for the x86 architecture is only
intended to boot via UEFI firmware.

When pointed to either a raw disk image file, or a block
device, containing the installation, it will inject a
dummy x86 boot sector. If a user subsequently attempts
to boot via legacy BIOS firmware, instead of UEFI, a
message will be printed (on both the primary serial port
and VGA display) indicating that UEFI is required.

OPTIONS
=======

 * ``--boot-stub`` *FILE-PATH*

   Override the default file path identifying the precompiled
   boot stub binary that will be injected

 * ``--message`` *FILE-PATH*

   Override the default message text that is printed when the
   installation is booted under legacy BIOS firmware.

   The message file must fit within the remaining free space
   of the boot sector. The dummy MBR and boot signature take
   66 bytes, the boot stub 21 bytes, and the message ``<NUL>``
   terminator a single byte. This leaves 424 bytes for the
   text message.

   Note, the message file must use ``<CR><LF>`` line terminators.

EXAMPLES
========

Injection post install
~~~~~~~~~~~~~~~~~~~~~~

Create a disk image using ``virt-install(1)`` and inject a boot
sector after installation is complete::

  $ virt-install \
      --virt-type kvm \
      --arch x86_64 \
      --boot uefi \
      --name demo \
      --disk bus=virtio,format=raw,size=4 \
      ...other args...

  $ byebyebios /var/lib/libvirt/images/demo.img

Injection during install
~~~~~~~~~~~~~~~~~~~~~~~~

Inject a boot sector as part of the installation process from an
``anaconda(1)`` kickstart file (or equivalent)::

  $ cat demo.ks
  ...snip...

  ignoredisk --only-use=vda
  clearpart --none --initlabel
  part /boot/efi --fstype="efi" --ondisk=vda --size=1007 --fsoptions="umask=0077,shortname=winnt"
  part / --fstype="ext4" --ondisk=vda --size=3087

  ..snip...

  %post

  byebyebios /dev/vda

  %end


Customized warning message
~~~~~~~~~~~~~~~~~~~~~~~~~~

To customize the warning message provide a custom text file
with ``<CR><LF>`` line terminators::

  $ echo "Bye Bye BIOS" | figlet -f bubble | unix2dos > msg.txt
  $ byebyebios --message msg.txt /var/lib/libvirt/images/demo.img

BUGS
====

Please report all bugs you discover to the upstream repository:

  `https://gitlab.com/berrange/byebyebios`

Alternatively, you may report bugs to your software distributor / vendor.


AUTHORS
=======

Daniel P. Berrangé

COPYRIGHT
=========

Copyright (C) 2023 Red Hat


LICENSE
=======

``byebyebios`` is distributed under the terms of the MIT No Attribution
license.

SEE ALSO
========

virt-install(1), anaconda(1)

