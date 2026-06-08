# address: 80079c6c

mflr r0 # brings r0 from the injectee
stw r0, 0x4(r1)
stwu r1, -0x10(r1)

.set HSD_Randf, 0x80380528 # HSD_Randf location in melee memory
lis r12, HSD_Randf@h
ori r12,r12,HSD_Randf@l
mtctr r12
bctrl

bl code
.float 200.0

code:
mflr r8
lfs f5, 0(r8) # load float from the link register

fmuls f1, f1, f5

addi r1, r1, 0x10
lwz r0, 0x4(r1)
mtlr r0 # brings r0 back to link register before returning

blr