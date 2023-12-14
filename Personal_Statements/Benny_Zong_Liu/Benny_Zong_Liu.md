# Personal statement | Benny Zong Liu 

## Contribution to the stages:

### Version 1: Single cycle

Being the repo master for Lab 4, I decided to take on the broader role of overseeing and delegating tasks for the creation of the single cycle CPU. I first created the `F1.s` file using assembly, which allowed the team to work out which specific instructions were needed to create a functioning CPU that supports `F1.s`.

When creating `F1.s`, I realised that I could not get trigger to be activated manually without exposing some part of the CPU directly. For which, I decided to connect register `t0` directly to the the top layer outputs so that we can directly access and modify the CPU state to react to the trigger. This is hooked up to the rotary encoder of the vBuddy using `vbdFlag()`.  

Throughout the design and debugging process, I was involved with testing and refining code made by my teammates and giving them feedback to make improvements to the CPU design. Various bugs like unimplemented `x0` register behaviour and mismatched bit lengths were fixed by me. In return, my teammates also gave me feedback on testing with the `F1.s` program that allowed me to make relevant bugfixes. 

In addition, I also implemented additional instructions (`AND`, `XOR`, `SLL` and `SLR`) to accomodate a LFSR that I have coded into `F1.s`. 

#### Challenges and mistakes

The merging process of the different branches was particularly difficult, as I was making changes to the main branch while the other group members were continuing their work on different branches. Some of these changes were overlapping and this led to divergence and clashes when trying to merge. This was further complicated by group members creating new file structures that made it very hard to merge.

This was eventually solved, but not without the occasional erronous commits and rollbacks. This taught me the importance of having a good project structure since the start to allow for effective compartmentalisation of work. 

Making the `F1.s` program before the CPU was tested and verified to be working meant that we had to debug both the CPU and the `F1.s` file at the same time, making it hard to pin down the exact faults and fix them efficiently. I think if I were to do it again, I would write test files that systematically tests each instruction before jumping straight into the F1 program. 

Lastly, I realised that the main reason why my groupmates and I were having trouble compiling and running the program was due to the End of Line Sequence being different. Some group mates were using Anaconda and thus had CRLF for line ending, while other needed LF for their linux environments. Fixing this bug greatly sped up our development process since everyone could now debug faster without major overhaul to their workspace. 

### Version 2: Pipelining

I was responsible for creating the F-stage of the pipelining CPU. The planning and work division was done by Yueming Wang (@rrroooyyywang). Making the stage was a rather straightforward process since the underlying code was already done, and I just needed to correctly name the input and output of the new module according to the naming convention established. I also modified my `F1.s` to contain appropriate `nop` intructions to prevent data hazards when testing the program on the CPU. 

Working with Deniz (@DenizzG), we linked together the relevant pipeline registers with my F-stage. There were some inconsistencies with the naming which were fixed with our regular meetup sessions that consolidated all changes. Me and **Adrian** also created the new `top.sv` top level file to tie together all the new modules (F, D, E, M and W). This was a tedious process where all signals bit lengths and module i/o needed to be identified and debugged. 

Lastly, I worked together with **Adrian** to implement the additional logic needed to implement `JALR` and `JAL`. Since there is now an alternate source of `PC` from the `ALUResult` line. We solved this by simply applying a MUX to the signals and choosing the appropriate input to `PC` accordingly. By doing this, we eliminate the need for a complex logic gate design that would otherwise do the same thing.


#### Challenges and mistakes

The challenge for creating the pipeline stage for me was testing the whole thing. This is due to the vast increase in the number of inter-module connetions that arose from splitting the CPU into various stages and pipeline registers. This required stringent checks on all input and output names, bit lengths and clocking sensitivity. Consequently, debugging in the `.vcd` file also became harder and pipelining errors were much more difficult to dig out and correct.

### Version 3: Hazard Detection

For Hazard detection, I helped to create the Flush and Stalling feature for the hazard unit along with **Adrian** and **Deniz**. This was done by creating a new module `Hazard.sv` that took in the read/write register addresses and stalled the appropriate stages or cleared the pipeline registers when a flush is needed to clear incorrectly fetched instructions.

#### Challenges and mistakes

This was one of the stages with the least amount of code writing and most amount of debugging. The nature of the new module meant that testing was cruicial, and I managed to catch a conditional error that saw undesirable stalling behaviour that stalled instructions 1 cycle too late. 

This bugfix was particularly difficult since this was a runtime error that disguised itself as a timing issue. This resulted in many unsuccessful attempts to fix it where I changed the rising edge sensitivity of pipeline registers. 

However, this error was caught after realising that an instruction was always lost when the delayed stall took place. This led me to discover that the logic for the pipeline register between the Fetch and Decode stages led to the signal being forwarded despite a stall signal being asserted. 



## Special design decisions I made

### LFSR in `F1.s`
![Alt text](Images/image.png)
<p style="text-align: center;">Fig 1: LFSR in F1.s</p>

In order to achieve a pseudo-random number generator for counting down, I created a very simple 4-bit LFSR, where only the 2 least significant bits are "XORed" to be appended to the start after shifting. 

### `t0` as Trigger

I made t0 the register directly controlled by `vbdFlag()`, acting as a trigger for `F1.s`. This choice was made for easy testing of the `F1.s` file since we can start the lights at will. Although this comes with the disadvantage of being unable to use that particular register for anything else if `vbdFlag()` is used. 


## Reflection

The project had taught me about the various design choices a CPU designer would have to go through, and the possible consequences if that standard was not enforced diligently. These problems would materialise in the form of difficult to read code and incomplete documentation of the different functions of the code. 

I also learnt an important skill of debugging by looking at the waveform, where hard to catch bugs can be systematically broken down and pinpointed to a specific module by tracing the error down to the last wire at which it occured at.

![Alt text](Images/Debugging.png)
<p style="text-align: center;">Fig 2: Debugging screenshot of delayed stall</p>

Looking at the non-technical aspect of the project, I had learn many things about working together as a group with different things that we are good at. My group had a slow start to the project initially, and I did not think that we could achieve so much over the short span of a few weeks. 

However, I was surprised by how much more we could achieve as a group despite our initially differing schedules and delayed communication. Everyone was able to chip in and contribute with a willingness to put in the necessary effort to achieve our collective goal of making a working CPU.

I felt that there were things that I could've done differrently, like create better testing that would cut down debugging time significantly and create a more comprehensive testing environment to better catch edge cases. 

I also wished that I had more finely spread out my commits so that it would be easier to track my changes rather than grouping together all the commits I have done for the entire sitting.

### Appendix

*Note: some co-authoring commits has my wrong email and are thus do not appear in the thumbnail*

#### Github commit list
| Link Label | Commit ID |
| --- | --- |
| 1 | 57d934c001c7dc2e352b4107524a48f96c0dfd0c - ALU_tb.cpp |
| 2 | 5df411bf2577158a17063475d5ca581c1b75c140 |
| 3 | 583b7194fc3a339f3d5d8ab2e8ee801a32ded487 |
| 4 | ac947c6af1baca64fbffbaf8802fa3818d9b032c |
| 5 | 374ef6e617c396ee9108c29b0837f8187235bccc |
| 6 | 90142baea7e55ca33bc4fa09f20e8da781e482b6 |
| 7 | b9fe63291a632db5b4879c04be311d1da0ac57d0 |
| 8 | a83f6df37b37a67f2618dafdb002c7759cd09b65 - branch at this point in time |
| 9 | a83f6df37b37a67f2618dafdb002c7759cd09b65 - extend.sv |
| 10 | 8c28c049dcc600c6b9c44c4b03577ac5279d2c71 |
| 11 | 6ae5fc18cee93446964ce3ad045b3ec334266605 - top.sv |
| 12 | 3fdee793342eb58524334bf9b30df2768d3b8d2b - top.sv |
| 13 | cac18fe623ec26e5eca4c6bccd3f4279f1045904 |
| 14 | ec5f69b54184b0f475f56ded2c19071fb2627128 |
| 15 | 1a23d21faf1c1aac70a5ed8facdb83c39aab47b3 |
| 16 | Cache branch readme |
| 17 | 750bde6b8d7c206d772e9cf135408d1172da3f3d - direct_mapped_cache.sv |
| 18 | 750bde6b8d7c206d772e9cf135408d1172da3f3d - two_way_associative_cache.sv |
| 19 | df081640c1d045bd836ade11acea0297a3761f54 - readme.md |
| 20 | 57d934c001c7dc2e352b4107524a48f96c0dfd0c - ALU.sv |
| 21 | df081640c1d045bd836ade11acea0297a3761f54 - two_way_associative_cache.sv |

