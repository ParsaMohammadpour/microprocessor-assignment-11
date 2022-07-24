.MODEL SMALL
.386
.STACK 64
.DATA
	;;;;;;;;;; PRINT NUMBER DATA ;;;;;;;;;;;
	OUT_NUMBER DB 9 DUP('$')
	TEST_NUMBER DD 39EF7CB5H
	
	;;;;;;;;;; MULT NUMBER DATA ;;;;;;;;;;;;
	DATA1 DD 0000000AH
	DATA2 DD 0000000AH

	RESULT DD 0,0
	
	;;;;;;;;;; GETNUM DATA ;;;;;;;;;;;;;;;;
	NEW_LINE DB 13,10,'$'
	MAX_LENGTH	DB	9 ;  ;MAX LENGTH OF THE INPUT , IT IS 11 BECAUSE 
	BUFFER_READER    DB  ? ;
	BUFFER    DB  9 DUP('$');
	
	NUMBER DD ?
	
	
	;;;;;;;;;; DIVISION DATA ;;;;;;;;;;;;;
	DIV_RESULT DD 0
	
.CODE  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINTNUM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRINTNUM PROC FAR 
	PUSH BX

	MOV AL, 0
	MOV SI, OFFSET OUT_NUMBER
	
	ADD BX, 3
	
	
LOOP_START:
	CMP AL, 4
	JGE LOOP_END
	MOV DL, [BX]
	
	SHR DL, 4
	
	MOV [SI], DL
	ADD SI, 1
	
	
	MOV DL, [BX]
	
	SHL DL, 4
	
	SHR DL, 4
	
	MOV [SI], DL
	SUB BX, 1
	ADD SI, 1
	ADD AL, 1
	JMP LOOP_START
	
LOOP_END:

	MOV SI, OFFSET OUT_NUMBER
LOOP1:
	MOV DL, [SI]
	CMP DL, '$'
	JE  LOOP_END2
	MOV AL, [SI]
	CMP DL, 9H
	JG  CHAR_CONVERSION
	JMP DIGIT_CONVERSION
CHAR_CONVERSION:
	ADD AL, 37H
	JMP END_OF_CONVERSION
DIGIT_CONVERSION:
	ADD AL, 30H
END_OF_CONVERSION:
	MOV [SI], AL
	ADD SI, 1
	JMP LOOP1
	
LOOP_END2:
	
	POP BX
	
	MOV DX, OFFSET OUT_NUMBER
    MOV AH,9
    INT 21H 
	RET
	
PRINTNUM ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MULTNUMS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MULTNUMS	PROC FAR
	; INITIALIZING REGISTERS FOR SIGNED MULT INSTRUCTION (IMULT)
	MOV EAX, DATA1
    IMUL DATA2 
	
	; SETTING RESULT
	MOV SI, OFFSET RESULT
	MOV [SI], EDX 
	
	ADD SI, 4 
	MOV [SI], EAX 
	
	
	;LEA SI, OUT_STR
	MOV BX, OFFSET RESULT
	CALL PRINTNUM
	
	;LEA SI, OUT_STR
	MOV BX, OFFSET RESULT+4
	CALL PRINTNUM
	RET
	
	
	
MULTNUMS ENDP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GETNUM ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GETNUM		PROC FAR 
	MOV DX , OFFSET MAX_LENGTH
	MOV AH,0AH
	INT 21H
	
	MOV AH, 9 
    MOV DX, OFFSET NEW_LINE 
    int 21h
	
	MOV DI, OFFSET NUMBER
	MOV SI, OFFSET BUFFER
	ADD SI, 7
	MOV BL, 0
	
LOOP2:
	CMP BL, 4
	JGE  LOOP2_END
	MOV AL, [SI]
	CMP AL, '9'
	JG CONV1
	JMP CONV2
CONV1:
	SUB AL, 37H
	JMP END_CONV
CONV2:
	SUB AL, 30H
END_CONV:

	SUB SI, 1
	MOV AH, [SI]
	CMP AH, '9'
	JG  CONV11
	JMP CONV22
CONV11:
	SUB AH, 37H
	JMP END_CONV2
CONV22:
	SUB AH, 30H
END_CONV2:
	
	SHL AH, 4
	OR AH, AL
	MOV [DI], AH
	ADD DI, 1
	SUB SI, 1
	ADD BL, 1
	JMP LOOP2
	
	
LOOP2_END:
	
	MOV BX, OFFSET NUMBER
	CALL PRINTNUM
	RET 
GETNUM ENDP



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DIVNUMS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DIVNUMS	PROC FAR
; INITIALIZING REGISTERS FOR SIGNED DIVISION INSTRUCTION (IDIV)
	MOV EAX, DATA1 
	IDIV DATA2  
	
	; SETTING RESULT
	MOV DIV_RESULT, EAX 
	
	MOV BX, OFFSET DIV_RESULT
	CALL PRINTNUM	
	RET
	
DIVNUMS ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MAIN ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MAIN    PROC FAR
        MOV AX,@DATA
        MOV DS,AX
		
		
		MOV BX, OFFSET TEST_NUMBER
		
		;CALL PRINTNUM
		
		;CALL  MULTNUMS
		
		;CALL GETNUM
		
		CALL DIVNUMS
		
		
		MOV AH,4CH
        INT 21H
MAIN    ENDP

        END MAIN