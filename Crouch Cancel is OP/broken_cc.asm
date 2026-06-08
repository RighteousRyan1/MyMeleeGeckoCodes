# address: 8008d974

bl code
.float 0.0

code:
mflr r8
lfs f5, 0(r8) # load float from the link register

fmuls f0, f5, f0