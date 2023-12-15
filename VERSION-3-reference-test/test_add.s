li a2, 0
li a1, 255

sw a1, 0(a2)
lw a1, 0(a2)

add a0, zero, a1
sw a1, 0(a2)
lw a1, 0(a2)
add a0, zero, a1

add a1, a1, 1
add a0, zero, a1
