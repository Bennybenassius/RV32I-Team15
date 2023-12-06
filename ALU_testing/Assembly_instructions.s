addi t1, zero, 10

addi a0, t0, 10          /should return 22/
addi a0, a0, 1 
and a0, t0, 10          /and for 12 and 10 is all possible cases, should return 8, 1000/
xor a0, t0, 10          /*should return 6*/
sll a0, t0, 1           /should return 24/

addi t1, zero, 500   /number is 2^31/
sll a0, t1, 1           /should return 0  jalr, jal test next/