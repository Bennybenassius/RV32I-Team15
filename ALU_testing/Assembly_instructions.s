addi t1, zero, 10
addi t0, zero, 12
addi a0, t0, 12          /*should return 24*/
addi a0, a0, 1 
and a0, t0, t1         /*and for 12 and 10 is all possible cases, should return 8, 1000*/
xor a0, t0, t1          /*should return 6*/
sll a0, t0, t1           /*should return 3000*/

addi t1, zero, 500   /*number is 2^31*/
sll a0, t1, t0           /*should return 0  jalr, jal test next*/