## Usage of test_toolkit
### New Usage
- copy and paste [./test_toolkit](../test_toolkit/) itself and rename it. This will be the testing folder you are working on.

- `cd` into the folder you copy and renamed(your working folder).

- write or modified your assembly code in file [test.s](test.s) in your working folder.
- run command `python testit.py --version=1` for singlecycle
- run command `python testit.py --version=2` for singlecycle
- or if you rename your test assembly flle in your working folder, run `python testit.py --version=1 --assembly=<your_file_name>`(do not include '<' and '>)
### Different from last usage
- we do not copy and past all file in [./test_toolkit](../test_toolkit/) into rtl, instead we copy rtl folder into the [./test_toolkit](../test_toolkit/) (you should rename it) 
- the new `testit.py` will now looking for keyword **version** and **assembly** to specify which version you want to test and which assembly code you want to use.
- new version works on wsl



