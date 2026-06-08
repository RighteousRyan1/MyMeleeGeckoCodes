# address: 8006a378


# data + pointers

# user_data (Fighter*)
lwz r12, 0x2C(r3)           # r12 = Fighter Data (fd)

# StageCameraInfo ptr
lis r11, 0x8049
ori r11, r11, 0xE6C8

lis r11, 0x8049             # r11 = StageCameraInfo base address
ori r11, r11, 0xE6C8

# Create a safe stack frame to load float constants -- ai tripping?
stwu r1, -16(r1)

# Store 0.0f
li r10, 0
stw r10, 4(r1)
lfs f0, 4(r1)               # f0 = 0.0f

# Store -1.0f
lis r10, 0xBF80
stw r10, 8(r1)
lfs f11, 8(r1)              # f11 = -1.0f

# Store -0.5f
lis r10, 0xBF00
stw r10, 12(r1)
lfs f12, 12(r1)             # f12 = -0.5f

# real camera bounds storage

lfs f1, 0x10(r11)           # f1 = offsetX
lfs f2, 0x14(r11)           # f2 = offsetY

lfs f3, 0x0(r11)            # left
fadds f3, f3, f1            # f3 = Real Left

lfs f4, 0x4(r11)            # right
fadds f4, f4, f1            # f4 = Real Right

lfs f5, 0x8(r11)            # top
fadds f5, f5, f2            # f5 = Real Top

lfs f6, 0xC(r11)            # bottom
fadds f6, f6, f2            # f6 = Real Bottom

# fighter data

lfs f7, 0x8C(r12)           # f7 = fd.Knockback.X
lfs f8, 0x90(r12)           # f8 = fd.Knockback.Y

lfs f9, 0xB0(r12)           # f9 = fd.Position.X (Assuming TopN X)
lfs f10, 0xB4(r12)          # f10 = fd.Position.Y (Assuming TopN Y)

# y axis kb

fcmpo cr0, f8, f0           # Compare KB.Y to 0.0f
ble check_kb_y_neg          # If KB.Y <= 0, check negative Y

# if fd.Knockback.Y > 0:
fcmpo cr0, f10, f5          # Compare Pos.Y to Real Top
ble x_axis_checks           # If Pos.Y <= Real Top, skip to X axis

# Pos.Y > Real Top
fmuls f8, f8, f12           # KB.Y = KB.Y * -0.5f
stfs f8, 0x90(r12)          # Store new KB.Y
b x_axis_checks             # Done with Y, move to X

check_kb_y_neg:
fcmpo cr0, f8, f0           # Compare KB.Y to 0.0f
bge x_axis_checks           # If KB.Y >= 0 (it is exactly 0), skip to X axis

# If fd.Knockback.Y < 0:
fcmpo cr0, f10, f6          # Compare Pos.Y to Real Bottom
bge x_axis_checks           # If Pos.Y >= Real Bottom, skip to X axis

# Pos.Y < Real Bottom
fmuls f8, f8, f11           # KB.Y = KB.Y * -1.0f
stfs f8, 0x90(r12)          # Store new KB.Y

# x axis kb 
x_axis_checks:
fcmpo cr0, f7, f0           # Compare KB.X to 0.0f
ble check_kb_x_neg          # If KB.X <= 0, check negative X

# If fd.Knockback.X > 0:
fcmpo cr0, f9, f4           # Compare Pos.X to Real Right
ble end_logic               # If Pos.X <= Real Right, finish

# Pos.X > Real Right
fmuls f7, f7, f11           # KB.X = KB.X * -1.0f
stfs f7, 0x8C(r12)          # Store new KB.X
b end_logic

check_kb_x_neg:
fcmpo cr0, f7, f0           # Compare KB.X to 0.0f
bge end_logic               # If KB.X >= 0, finish

# If fd.Knockback.X < 0:
fcmpo cr0, f9, f3           # Compare Pos.X to Real Left
bge end_logic               # If Pos.X >= Real Left, finish

# Pos.X < Real Left
fmuls f7, f7, f11           # KB.X = KB.X * -1.0f
stfs f7, 0x8C(r12)          # Store new KB.X





end_logic:
addi r1, r1, 16             # Restore the stack pointer

lwz r3, 0x2C(r3)