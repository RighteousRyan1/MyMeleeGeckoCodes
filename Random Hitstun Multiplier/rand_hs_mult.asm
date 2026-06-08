# address: 8008eca8

.include "../Common.s"

backupall

# reads ptr at 0x804D6554
lis r3, 0x804D
lwz r3, 0x6554(r3)
cmpwi r3, 0 
beq END # don't do anything if the pointer is null

# stores address in r14
# Save original r14 first
stw r14, 0x1C(r1)     
addi r14, r3, 0x154  # r14 = ptr + 0x154

# generates a random number
lis r12, 0x8038
ori r12, r12, 0x0528
mtctr r12
bctrl

# scales result by 0.8
bl GET_DATA
.float 0.8
GET_DATA:
mflr r12         # addr of 0.8 const
lfs f0, 0(r12)   # loads it into f0
fmuls f1, f1, f0 # f1 = rand * 0.8

# 6. Store to memory
stfs f1, 0(r14) # writes float to ptr + 0x154

restoreall

li r30, 0