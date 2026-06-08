# address: 80087c70

#lbz r5, 0xC(r3)
#lwz r6, -0x49e4(r13)
#lbz r7, 0(r6)

#cmpw r5, r7
mr r3, r4
#bnelr

# get match frame
lis r8, 0x8046
ori r8, r8, 0xB6A0

lhz r8, 0x2C(r8)
andi. r8, r8, 3

cmpwi r8, 1
beq high

cmpwi r8, 2
beq low

# regular pitch fighter
blr

# highpitch fighter
high:
addi r3, r4, 2
blr

# lowpitch fighter
low:
addi r3, r4, 1
blr