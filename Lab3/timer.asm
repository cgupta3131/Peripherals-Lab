cpu "8085.tbl"
hof "int8"

org 9000h
;MONITOR ROUTINES DEFINITIONS
GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

LXI H,8900H
MVI M,00H

LXI H,8FBFH
MVI M,0C3H
INX H
MVI M,0E9H
INX H
MVI M,90H

; LXI H,7300H
; MVI M,00H

MVI A,00H
MVI B,00H

; HOURS
LXI H,8840H
MVI M,00H

LXI H,8841H
MVI M,00H

; MINUTES
LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,00H

LXI H,8840H
CALL OUTPUT

MVI A,00H
MVI B,00H
CALL GTHEX ;taking hours and minutes
MOV H,D
MOV L,E
SHLD 8000H

MVI A,00H
MVI B,01H
CALL GTHEX ;taking hours and minutes
MOV A,E
STA 8050H

MVI B,00H

FIRST:
	LHLD 8000H
	MOV A,H
	CPI 24H
	JC SECOND
	; if Accumulator(Hour) < 24 ==> Valid and jump to SECOND
START:   ; start decreasing by seconds
	MVI H,00H
	JC HR_MIN
SECOND:
	MOV A,L
	CPI 60H
	JC HR_MIN
	; if Accumulator(mINUTE) < 60 ==> Valid and jump to loop
THIRD:
	MVI L,00H

HR_MIN:
	SHLD CURAD 	; VALUE OF HL IS STORED IN CURAD
	LDA 8050H	; taking input seconds which is stored in 8050
	JMP NXT_SEC

NDCALL:
	SHLD CURAD
	MVI A,59H
NXT_SEC:
	STA CURDT
	CALL UPDAD
	CALL UPDDT
	CALL DELAY

	;;INTERRUPT WORK
	STA 7000H  ;store accumulator value
	MVI A,0BH  ; For interrupt
	SIM
	EI
	LDA 7000H ;restore accumulator value as previous


	LHLD CURAD   ; loading current data on address field
	MOV A,H
	CPI 00H   ; if time is 00:00:00 then stop
	JNZ NORMAL
	MOV A,L
	CPI 00H
	JNZ NORMAL
	LDA CURDT
	CPI 00H
	JNZ NORMAL
	HLT  ;halt for 00:00:00

	NORMAL:  		;decrement(loop) by 1 sec in each iteration
	LDA CURDT
	CALL DEC
	JNC NXT_SEC		;decrement by 1 second
	LHLD CURAD
	MVI A,59H
	STA CURDT
	MOV A,L
	CALL DEC  		;decrement minute by 1 if second is 0
	MOV L,A
	JNC NDCALL
	MVI L,59H
	MOV A,H
	CALL DEC  		;decrement hours by 1 is seconds and minute is 0
	MOV H,A
	JNC NDCALL
	LXI H,2359H
	JMP NDCALL
DELAY:
	MVI C,03H
OUTLOOP:
	LXI D,9F00H
INLOOP:
	DCX D ; DECREMENT REG PAIR BY ONE
	MOV A,D
	ORA E ; LOGICAL OR OPERATION WITH FF(VALUE OF REG E)
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET

DEC:  ;decimal adjust after subtraction
	STA 8004H
	ANI 0FH
	CPI 00H
	JNZ LOOP8
	LDA 8004H
	SBI 07H  ;decreasing by seven when 0 comes to go to 9
	RET
LOOP8:
 LDA 8004H
 SBI 01H
 RET

RST 5

PUSH PSW

LDA 8900H
CMA

STA 8900H

CPI 00H
JNZ INF
INF:
	EI
	LDA 8900H
	CPI 00H
	JNZ INF

EXIT:
	POP PSW
	EI
	RET
