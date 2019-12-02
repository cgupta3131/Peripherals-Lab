Steps to execute the program on esa-x85 kit

1. Convert the .asm file to a .hex file via this command: c16 -h out.hex -l test.lst asn1.asm
2. Connect the serial cable from the esa-x85 Kit to the COM port of your PC.
3. Switch the 4th DIP switch to the right side.
4. Double click the utility xt85.exe from the installation folder.
5. Press Ctrl+D and RESET key on the kit. Enter the input file name when asked to do so.
6. Press 'Enter' till it says the download is complete.
7. Shift the 4th DIP switch back to the left side.
8. Press RESET key and then EXAM MEM key to examine the memory content.
9. Enter the address of the memory where the inputs are to be put.
10. Click on NEXT key. The address is displayed with the data written on the memory address.
11. Enter the value you wish to enter.
12. Repeat the steps 10-11 until all the inputs are entered in the memory.
13. Click on GO key and enter the starting address of the code.
14. Click on EXEC key to execute the code.
15. The code has been executed now. Check the output data by entering the respective address as in steps 10-11.
