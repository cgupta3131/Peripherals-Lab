cpu "8085.tbl"
hof "int8"
org 9000h
MVI H,88H
MVI L,00H
MOV A,M
DCR A
JZ ADD8
DCR A
JZ SUB8
DCR A
JZ MUL8
DCR A
JZ DIV8
DCR A
JZ ADD16
DCR A
JZ SUB16
DCR A
JZ MUL16
DCR A
JZ DIV16

ADD8:
    MVI H,88H   ;Taking first operand at 8801 address
    MVI L,01H
    MOV A,M     ;Moving data from memory to accumulator
    INR L       ;Taking second operand at 8802 address
    MOV B,M     ;Moving data from memory to Register B
    ADD B       ;Adding contents of Accumulator and Reg B and storing in A
    MVI H,89H   ;
    MVI L,01H
    MOV M,A
    JMP END

SUB8:
    MVI H,88H
    MVI L,01H
    MOV A,M
    INR L
    MOV B,M
    SUB B
    MVI H,89H
    MVI L,01H
    MOV M,A
    JMP END

MUL8:
    MVI H,88H
    MVI L,01H
    MOV C,M
    MVI B,00H
    INR L
    MOV A,M
    MVI H,00H
    MVI L,00H

    L1:
        JZ L1E
        DAD B
        DCR A
        JMP L1
    L1E:
        MOV B,H
        MOV C,L
        MVI H,89H
        MVI L,00H
        MOV M,B
        INR L
        MOV M,C
        JMP END

DIV8:
    MVI H,88H
    MVI L,01H
    MOV A,M
    INR L
    MOV B,M
    MVI C,00H
    SUB B

    L2:
        JM L2E
        INR C
        SUB B
        JMP L2
    L2E:
        MVI H,89H
        MVI L,01H
        MOV M,C
        JMP END

ADD16:
    MVI H,88H
    MVI L,01H
    MOV B,M
    INR L
    MOV C,M
    INR L
    MOV D,M
    INR L
    MOV E,M

    MVI H,00H
    MVI L,00H
    DAD B
    DAD D

    MOV B, H
    MOV C, L
    MVI H, 89H
    MVI L, 00H
    MOV M,B
    INR L
    MOV M,C
    JMP END

SUB16:
    MVI H,88H
    MVI L,01H
    MOV B,M
    INR L
    MOV C,M
    INR L
    MOV D,M
    INR L
    MOV E,M

    MOV A,D
    CMA
    MOV D,A

    MOV A,E
    CMA
    MOV E,A

    MVI H,00H
    MVI L,01H
    DAD D
    DAD B

    MOV B, H
    MOV C, L
    MVI H, 89H
    MVI L, 00H
    MOV M,B
    INR L
    MOV M,C
    JMP END

MUL16:
    MVI H,88H
    MVI L,01H
    MOV B,M
    INR L
    MOV C,M
    MOV H,B
    MOV L,C

    SPHL

    MVI H,88H
    MVI L,03H
    MOV B,M
    INR L
    MOV C,M
    MOV D,B
    MOV E,C

    MVI H,00H
    MVI L,00H
    MVI B,00H
    MVI C,00H

    L3:
        MOV A, D
        ORA E

        JZ L3E

        DAD SP
        JNC L4

        INX B

        L4:
            DCX D
            JMP L3

    L3E:
        MOV D, H
        MOV E, L

        MVI H, 89H
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
    MVI H,88H
    MVI L,01H
    MOV B,M
    INR L
    MOV C,M
    INR L
    MOV D,M
    INR L
    MOV E,M

    MOV H,B
    MOV L,C

    MVI B,00H
    MVI C,00H

    L5:
        MOV A,L
        SUB E
        MOV L,A 
        MOV A,H
        SBB D
        MOV H,A

        JC L5E

        INX B
        JMP L5

    L5E:
        MVI H, 89H
        MVI L, 00H
        MOV M,B
        INR L
        MOV M,C

        JMP END

END:
    RST 5