# SPDX-License-Identifier: MIT-0

.code16
.global bye_bye_bios

bye_bye_bios:
  mov $something_important, %si
  mov $0xe, %ah
  mov $0x3f8,%dx

say_a_little_more:
  lodsb
  cmp $0, %al
  je this_is_the_end
  int $0x10
  outb %al,%dx
  jmp say_a_little_more

this_is_the_end:
  hlt
  jmp this_is_the_end

something_important:
# The string message will be appended here at time of install
