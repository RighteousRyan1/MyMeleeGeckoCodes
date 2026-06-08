# address: 80076f10

.include "../Common.s"

# store staled damage into f3, original instr
lfs f3, 0xC(r27)

backupall

bl      get_data

# data
.float  0.0333  # [+0]  crit threshold
.float  5.0   # [+4]  crit multiplier
.int    223   # [+8]  sfx id for SFX_PlaySFX

get_data:
    mflr    r31

    # f1 = [0, 1)
    .set HSD_Randf, 0x80380528
    lis     r12, HSD_Randf@h
    ori     r12, r12, HSD_Randf@l
    mtctr   r12
    bctrl                       # f1 = rand, lr is now junk (return addr)

    # loads data into memory
    lfs     f5, 0(r31)          # f5 = 0.01 (threshold)
    lfs     f6, 4(r31)          # f6 = 3.0  (multiplier)
    lwz     r4, 8(r31)          # r4 = sfx id

    # compare rand < threshold?
    fcmpo   cr0, f1, f5         # cr0: f1 (rand) vs f5 (threshold)
    bge cr0, no_crit

crit:
    # mult damage by crit mult
    # fmuls   f31, f31, f4        # f31 = damage * 3.0 (old)
    fmuls f3, f3, f6 # f3 (staled dmg) = f3 * f6 (multiplier) (try f31 cuz fmr?)
    stfs  f3, 0xC(r27)

    # calls SFX_PlaySFX(sfx_id)
    mr      r3, r4              # r3 = sfx id (first arg)
    .set SFX_PlaySFX, 0x8038cff4
    # r3 = 223, r4 = 254, r5 = 128
    # args provided by ness's bat swing
    li r5, 254
    li r6, 0
    li r7, 0
    lis     r12, SFX_PlaySFX@h
    ori     r12, r12, SFX_PlaySFX@l
    mtctr   r12
    bctrl

no_crit:
    restoreall
    cmplwi r5, 0