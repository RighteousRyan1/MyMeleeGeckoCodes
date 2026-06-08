# address: 80079c6c

# r7 = the player

# free registers, r10, r11, r12

#load floating point single precision
#lfs r10, 0x8C(r7)

#fmuls r10, 10

# addi r3, r3, 1000
fmuls f1, f1, 10

blr