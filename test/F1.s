addi    a0, zero, 0         /*a0 is storing state of F1 FSM. Initialise to 0*/
addi    t1, zero, 1         /*t1 is storing 1 to compare with trigger and shift amount*/
addi    a1, zero, 7         /*set a 7 to compare state at which to start random countdown*/
addi    a3, zero, 1234		/*Some number to initialise LFSR (2^31)*/

start: 
bne     t0, t1, wait        /*Branch to continuously loop until trigger is reached*/
addi    t0, zero, 0         /*Reinitialise trigger to low after triggering*/

mainloop:
addi    a0, a0, 1           /*Increment 1 to the state of the F1 FSM*/
beq     t0, a1, lastState   /*If t0 == a1, then random Countdown*/
jalr    ra, 5     /*Jumps to the secondTimer subroutine to count 1s*/
jal     zero, mainloop            /*Always jumps back to increment to next state*/

lastState:
jalr    ra, 7
addi    a0, zero, 0         /*Return the state to 0*/
jal     zero, start            /*Always jump back outside the main loop to reset and wait for trigger again*/

wait:
jal     zero, start         /*Always loop back to start and continuously listen for trigger*/


/*one second timer subroutine*/
secondTimer:
addi    a2, zero, 100		/*The immediate is the number of cycles for 1s*/
minusloop1:
addi    a2, a2, -1
bne     a2, zero, minusloop1/*Keep looping back to -1 until 1s is reached*/
jalr    zero, 0(ra)         /*Resume program execution*/

/*random time timer subroutine*/
randTimer:
and     a4, a3, 1           /*extract the last */
and     a5, a3, 2           /*extract the second last*/
xor     a4, a4, a5          /*XOR the last 2 digits*/
sll     a3, a3, t1          /*Shift the LFSR by 1 bit*/

add    a2, zero, a3         /*initialise the counting register to LFSR*/
minusloop2:
addi    a2, a2, -1
bne     a2, zero, minusloop2/*Keep looping back to -1 until 1s is reached*/

jalr    zero, 0(ra)         /*Resume program execution*/