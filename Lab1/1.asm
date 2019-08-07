cpu "8085.tbl"
hof "int8"
org 9000h
MVI H,88H   ;Taking operator details at address 8800
MVI L,00H
MOV A,M
DCR A       ;If user enters 1, then addition of 8bit numbers
JZ ADD8
DCR A       ;If user enters 2, then subtraction of 8bit numbers
JZ SUB8
DCR A       ;If user enters 3, then multiplication of 8bit numbers
JZ MUL8
DCR A       ;If user enters 4, then division of 8bit numbers
JZ DIV8
DCR A       ;If user enters 5, then addition of 16bit numbers
JZ ADD16
DCR A       ;If user enters 6, then subtraction of 16bit numbers
JZ SUB16
DCR A       ;If user enters 7, then multiplication of 16bit numbers
JZ MUL16
DCR A       ;If user enters 8, then division of 16bit numbers
JZ DIV16

ADD8:
    MVI H,88H   ;Taking first operand at 8801 address
    MVI L,01H
    MOV A,M     ;Moving data from memory to accumulator
    INR L       ;Taking second operand at 8802 address
    MOV B,M     ;Moving data from memory to Register B
    ADD B       ;Adding contents of Accumulator and Reg B and storing in A
    MVI H,89H   
    MVI L,01H
    MOV M,A     ;Storing my result at memory location 8901
    JMP END

SUB8:
    MVI H,88H   ;Taking first operand at 8801 address
    MVI L,01H
    MOV A,M     ;Moving data from memory to accumulator
    INR L       ;Taking second operand at 8802 address
    MOV B,M     ;Moving data from memory to Register B
    SUB B       ;Subtracting contents of Reg B from Accumulator and storing in A
    MVI H,89H
    MVI L,01H
    MOV M,A     ;Storing my result at memory location 8901
    JMP END

MUL8:               ;Basically repeated addition is done to perform Multiplication
    MVI H,88H       ;Taking first operand at 8801 address
    MVI L,01H
    MOV C,M         ;Moving data from memory to register C
    MVI B,00H       ;Moving value 0 at register B 
    INR L           ;Taking second operand at 8802 address
    MOV A,M         ;Moving data to accumulator A
    MVI H,00H       ;Initializing (H)(L) with zero, which will store my result
    MVI L,00H

    L1:
        JZ L1E      ;If my Accumulator value becomes zero
        DAD B       ;DAD will add contents of (H)(L) and (B)(C) and store in (H)(L)
        DCR A       ;Decrement the value in Register A
        JMP L1      ;Loop back to L1 Label : Basically adding A times the contents of (B)(C)
    L1E:
        MOV B,H     ;Moving contents of H to register B
        MOV C,L     ;Moving contents of L to register C
        MVI H,89H   ;Storing my result at memory location 8900 and 8901
        MVI L,00H
        MOV M,B     ;Storing contents of B at location 8900
        INR L
        MOV M,C     ;Storing contents of C at location 8901
        JMP END

DIV8:               ;Basically repeated subtraction is done to perform Divison
    MVI H,88H       ;Taking first operand at 8801 address
    MVI L,01H
    MOV A,M         ;Storing the contents in Accumulator A
    INR L           ;Taking second operand at 8802 address
    MOV B,M         ;Storing the contents in Register B
    MVI C,00H       ;Register C will store my result, initialzed with zero
    SUB B           ;This is done to avoid getting ceil(A/B), as we want floor(A/B)

    L2:
        JM L2E      ;If my accumulator value becomes less than 0, Jump to label L2E
        INR C       ;Increment my counter register C
        SUB B       ;Subtract B from A, i.e A = A-B;
        JMP L2      ;Loop back to L2 Label
    L2E:
        MVI H,89H   ;Storing my result at address 8901
        MVI L,01H
        MOV M,C     ;Moving the content of Register C to 8901 address
        JMP END

ADD16:
    MVI H,88H       ;Setting memory Address
    MVI L,01H
    MOV B,M         ;Storing higher 8 bits of first operand
    INR L
    MOV C,M         ;Storing lower 8 bits of first operand
    INR L
    MOV D,M         ;Storing higher 8 bits of second operand
    INR L
    MOV E,M         ;Storing lower 8 bits of second operand

    MVI H,00H       ;Initializing register pair to 0000
    MVI L,00H
    DAD B           ;Adding first operand
    DAD D           ;Adding second operand

    MOV B, H        ;Storing higher 8 bits of answer
    MOV C, L        ;Storing lower 8 bits of answer
    MVI H, 89H      ;Storing higher 8 bits of answer at memory location 8900
    MVI L, 00H
    MOV M,B
    INR L
    MOV M,C         ;Storing lower 8 bits of answer at memory location 8901
    JMP END

SUB16:
    MVI H,88H       ;Setting memory Address
    MVI L,01H
    MOV B,M         ;Storing higher 8 bits of first operand
    INR L
    MOV C,M         ;Storing lower 8 bits of first operand
    INR L
    MOV D,M         ;Storing higher 8 bits of second operand
    INR L
    MOV E,M         ;Storing lower 8 bits of second operand
                    ;Now we take 2s complement of second operand
    MOV A,D         ;Taking complement of lower 8 bits
    CMA
    MOV D,A

    MOV A,E         ;Taking complement of higher 8 bits
    CMA
    MOV E,A

    MVI H,00H       
    MVI L,01H
    DAD D           ;Adding 1 to get 2's complement
    DAD B           ;Adding first operand

    MOV B, H        ;Storing higher 8 bits of answer
    MOV C, L        ;Storing lower 8 bits of answer
    MVI H, 89H
    MVI L, 00H
    MOV M,B         ;Storing higher 8 bits of answer at memory location 8900
    INR L
    MOV M,C         ;Storing lower 8 bits of answer at memory location 8901
    JMP END

MUL16:
    MVI H,88H       ;Setting memory Address
    MVI L,01H
    MOV B,M         ;Storing higher 8 bits of first operand
    INR L
    MOV C,M         ;Storing lower 8 bits of first operand
    MOV H,B         ;Storing first operand in register pair HL
    MOV L,C

    SPHL            ;Storing first operand in SP

    MVI H,88H       ;Setting memory Address
    MVI L,03H
    MOV B,M         ;Storing higher 8 bits of second operand
    INR L
    MOV C,M         ;Storing lower 8 bits of second operand
    MOV D,B         ;Storing first operand in register pair HL
    MOV E,C

    MVI H,00H       ;Answer is stored in registers BCHL so initializing them to zero
    MVI L,00H
    MVI B,00H
    MVI C,00H
        ;Loop for repeated Addition
    L3:
        MOV A, D    ;To check whether first operand is zero or not we Or the digits of first operand
        ORA E

        JZ L3E      ;If first operand is zero then break;

        DAD SP      ;Add second operand
        JNC L4      ;If There is no carry then skip

        INX B       ;If carry then add 1 to higher 16 bits of answer

        L4:
            DCX D   ;Decrement first operand
            JMP L3  ;Repeat loop

    L3E:
        MOV D, H        ;Higher 16 bits of Answer stored in register pair DE
        MOV E, L

        MVI H, 89H      ;Storing the 32 bit Answer from memory location 89000 to 8903
        MVI L, 00H
        MOV M,B
        INR L
        MOV M,C
        INR L
        MOV M,D
        INR L
        MOV M,E

        JMP END

DIV16:
    MVI H,88H       ;Take first input from address 8801H
    MVI L,01H
    MOV B,M         ;Store the value in register B
    INR L           ;Increment L so that new address is 8802H
    MOV C,M         ;Store the value in register C
    INR L           ;Increment L so that new address is 8803H
    MOV D,M         ;Store the value in register D
    INR L           ;Increment L so that new address is 8804H
    MOV E,M         ;Store the value in register E
                    ;One input is in register pair (B,C) and other in (D,E)
    MOV H,B         ;Move pair value (B,C) to (H,L)
    MOV L,C

    MVI B,00H       ;Initialize (B,C) to 0000H
    MVI C,00H       
        ;Loop for repeated subtraction
    L5:
        MOV A,L     ;Subtracting divisor from dividend
        SUB E
        MOV L,A
        MOV A,H
        SBB D
        MOV H,A

        JC L5E      ;If answer is negative then ther is carry So break the loop if carry

        INX B       ;Increment quotient
        JMP L5      ;Repeat Loop

    L5E:
        MVI H, 89H
        MVI L, 00H
        MOV M,B     ;Storing higher 8 bits of answer at memory location 8900
        INR L
        MOV M,C     ;Storing lower 8 bits of answer at memory location 8901

        JMP END     ;Jump to END label

END:
    RST 5   ;End the program
