#!/usr/bin/python3
#
# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: 2023 Red Hat

import sys
import argparse

def install(bootsector, message, image):
    with open(bootsector, "rb") as fh:
        bs = fh.read()

    with open(message, "rb") as fh:
        msg = fh.read()

    # 512 sector, minus
    #  - length of boot sector code
    #  - length of boot marker 0xaa55
    #  - length of protective MBR
    #  - NUL terminator
    maxmsg = 512 - (len(bs) + 2 + 64 + 1)

    if len(msg) > maxmsg:
        print(f"Message in {message} is too long, maximum {maxmsg} characters permitted")
        sys.exit(1)

    pad = maxmsg - len(msg)

    with open(image, "rb+") as fh:
        fh.write(bs)
        fh.write(msg)
        # Message NUL terminator
        fh.write(bytes([0]))
        # Pad until start of MBR
        fh.write(bytes([0] * pad))
        # Partition 1
        fh.write(bytes([
            0x00, # status
            0x00, 0x02, 0x00, # start CHS
            0xEE, # type
            0xFF, 0xFF, 0xFF, # end CHS
            0x01, 0x00, 0x00, 0x00, # start LBA
            0xFF, 0xFF, 0x9F, 0x00 # LBA count
        ]))
        # Partitions 2-4 are empty
        fh.write(bytes([0] * 16 * 3))
        fh.write(bytes([0x55, 0xAA]))


def main():
    parser = argparse.ArgumentParser(
        description='Install UEFI warning boot sector')

    parser.add_argument("--boot-stub", "-b", metavar="BOOT-STUB-PATH",
                        default="/usr/share/byebyebios/bootstub.bin",
                        help="path to boot sector code stub")
    parser.add_argument("--message", "-m", metavar="MESSAGE-PATH",
                        default="/usr/share/byebyebios/nouefi.txt",
                        help="path to file with UEFI warning message")
    parser.add_argument("disk_image", metavar="DISK-IMAGE-PATH",
                        help="path to disk image to install boot sector in")

    args = parser.parse_args()

    install(args.boot_stub,
            args.message,
            args.disk_image)

main()
