addi    a0, zero, 0        				/*a0 is storing state of F1 FSM. Initialise to 0*/
addi    t1, zero, 1         			/*t1 is storing 1 to compare with trigger and shift amount*/
addi	t2, zero, 2						/*t2 is the and mask*/
addi	t3, zero, 3						/*t3 is the shift left amount for XOR*/
addi    a1, zero, 255         			/*set a 7 to compare state at which to start random countdown*/
addi    a3, zero, 12  				    /*Some number to initialise LFSR (2^31)*/

start: 
	bne     t0, t1, wait        		/*Branch to continuously loop until trigger is reached*/
    nop
    nop
	nop
	nop
	addi    t0, zero, 0         		/*Reinitialise trigger to low after triggering*/
mainloop:
	sll     a0, a0, t1					/*Shift state left by 1 bit*/
    nop
    nop
	addi    a0, a0, 1           		/*Increment 1 to the state of the F1 FSM*/
    nop
    nop
	beq     a0, a1, lastState   		/*If a0 == a1, then random Countdown*/
    nop
    nop
	nop
	nop
	jal     ra, secondTimer    		    /*Jumps to the secondTimer subroutine to count 1s*/
	nop
	nop
	jal     zero, mainloop            	/*Always jumps back to increment to next state*/
	nop
	nop

lastState:
	jal     ra, randTimer               /*Random timer countdown*/
	nop
	nop
	addi    a0, zero, 0        			/*Return the state to 0*/
	jal     zero, start            		/*Always jump back outside the main loop to reset and wait for trigger again*/
	nop
	nop

wait:
	jal     zero, start         		/*Always loop back to start and continuously listen for trigger*/
	nop
	nop

/*one second timer subroutine*/
secondTimer:
	addi    a2, zero, 10  				/*The immediate is the number of cycles for 1s*/
	nop
	nop
	minusloop1:
		addi    a2, a2, -1
		bne     a2, zero, minusloop1	/*Keep looping back to -1 until 1s is reached*/
		nop
		nop
		nop
		nop
	jalr    zero, ra, 0          		/*Resume program execution*/
	nop
	nop

/*random time timer subroutine*/
randTimer:
	and     a4, a3, t1           		/*extract the last */
	and     a5, a3, t2           		/*extract the second last*/
    nop
    nop
	srl		a5, a5, t1					/*shift right by 1 bit so can xor*/
	nop
    nop
    xor     a4, a4, a5          		/*XOR the last 2 digits*/
	srl     a3, a3, t1          		/*Shift the LFSR by 1 bit to the right*/
	nop
    sll		a4, a4, t3					/*Append XOR result to left (start of LFSR)*/
	add    	a2, zero, a3         		/*initialise the counting register to LFSR*/
	nop
	nop
minusloop2:
	addi    a2, a2, -1
    nop
    nop
	bne     a2, zero, minusloop2		/*Keep looping back to -1 until 1s is reached*/
    nop
    nop
	nop
	nop
	jalr    zero, ra, 0                 /*Resume program execution*/
	nop
	nop
