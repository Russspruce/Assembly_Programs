TITLE Intro: Fibonacci Sequence     (Assignment2.asm)

; Author: Andrew Russo					Email: russoa@oregonstate.edu
; Course/Section: CS271-400
; Project ID: Assignment #2				Due Date: 01/28/2018
; Description:  Create a program that will print out a specific number of fibonacci terms depending on how many the user wishes to see.  The number can only exist in the range between 1 and 46 for it to work properly




INCLUDE Irvine32.inc

UPPER_LIMIT = 47

.data

intro        			BYTE "Fibonacci Sequence by Andrew Russo",0
namePrompt   			BYTE "Hello.  What is your name?  ",0
greet				 	BYTE "Hello, ",0
prgInfo      			BYTE "Enter the number of Fibonacci terms to be displayed.",0
fibRange		 		BYTE "The range that you can enter is between 1 and 46.",0
prgRange		 		BYTE "Please enter a number within the range of 1 to 46: ",0
errorNum		 		BYTE "ERR0R: Number is out of range!",0
xtraCrdt				BYTE "**Program will automatically allign colums of numbers.**",0

gbyeMsg 		 		BYTE "Thank you for participating, we hope you see you again soon!",0
verifyBye		 		BYTE "Results certified by Andrew Russo.",0
space 					BYTE "   ",0

nameInput		 		DWORD ?
fibInput		 		DWORD ?
fibHolder		 		DWORD ?
fibPlaceholder			DWORD ?




.code
main PROC
	call Clrscr

;Introduction with name, title, and extra credit
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET namePrompt
	call	WriteString
	mov		ecx, 32
	mov		edx, offset nameInput
	call	ReadString

;print greeting
	mov		edx, OFFSET	greet
	call	WriteString
	mov		edx, OFFSET nameInput
	call	WriteString
	call	CrLf


;Display instructions
	mov		edx, OFFSET prgInfo
	call	WriteString
	call	CrLf
	call	CrLf
	mov		edx, OFFSET xtraCRDT
	call	WriteString
	call	CrLf
	call	CrLf
	mov     edx, OFFSET fibRange
	call    WriteString
	call	CrLf
	call	CrLf

errorMsg:
	mov		edx, OFFSET errorNum
	call	WriteString
	call	CrLf
	jmp		getFibNumberInput



getFibNumberInput:
;get number of terms from user
	mov		edx, OFFSET prgRange
	call	WriteString
	call	readInt
	mov		fibInput, eax


;checks to see in number is valid if valid
	js		errorMsg
	jz		errorMsg
	cmp		eax, UPPER_LIMIT
	jge		errorMsg

;print Fibonacci numbers
	mov		eax, 0
	mov		ebx, 1
	mov		ecx, fibInput
	mov		edx, 5


;Fibonacci setup
	mov		eax, 0
	mov		ebx, 1
	mov		ecx, fibInput
	mov		edx, 5


startFibs:
	mov		fibHolder, eax
	add		eax, ebx
	call	WriteDec
	dec		edx
	jnz		addSpace


nextRow:
	call	CrLf
	mov		edx, 5
	jmp		loopBack


addSpace:
	cmp		ecx, 1
	je		nextRow
	mov		fibPlaceholder, edx
	mov		edx, OFFSET space
	call	WriteString
	mov		edx, fibPlaceholder


loopBack:
	mov		ebx, fibHolder
	loop	startFibs

farewell:
	call	CrLf
	mov		edx, OFFSET gbyeMsg
	call	WriteString
	call	CrLf
	call	CrLf




    exit
main ENDP


END main
