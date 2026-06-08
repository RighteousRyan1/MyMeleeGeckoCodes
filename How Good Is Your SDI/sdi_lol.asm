# address: 8006a378

# original instruction
lwz r3, 0x2c(r3)

li r0, 0             # r0 = 0 (The NULL value we want to write)
addi r4, r3, 0x914   # r4 = base address of first HitCapsule (0x914)
    
# outer loop (6 hitcapsules)
li r5, 6             # total capsules (4 from x914 + 2 from xDF4)
mtctr r5             # Put 6 into the Count Register (CTR)
    
outer_loop:
    addi r5, r4, 0x74    # r5 = first HitVictim
    
	# inner loop (12 hitvictims)
	li r6, 12            # r6 = inner loop counter
    
inner_loop:
    stw r0, 0(r5)        # sets HitVictim->victim to null
    addi r5, r5, 8       # advance by size of HitVictim struct
    
    subic. r6, r6, 1     # decrements inner loop counter until it goes back to the outer loop
    bne inner_loop
    
# advances outer loop
    addi r4, r4, 0x138   # advance by HitCapsule size (0x138)
    bdnz outer_loop      # decrement ctr. if ctr != 0, branch back to outer_loop
