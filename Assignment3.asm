TITLE Intro: Integer Accumulator     (Assignment3.asm)

; Author: Andrew Russo					Email: russoa@oregonstate.edu
; Course/Section: CS271-400
; Project ID: Assignment #3				Due Date: 02/11/2018
; Description:  Greet the user, then prompt the user to enter negative numbers between -100 and -1.
;				After the user enters in the desired numbers, they enter a positive number to end the program and it will calculate the sum and averages of the numbers.




INCLUDE Irvine32.inc

LOWER_LIMIT = -100

.data

intro        		BYTE	"Integer Accumulator by Andrew Russo",0
namePrompt   		BYTE	"Hello.  What is your name?  ",0
greet				BYTE    "Hello, ",0
prgInfo      		BYTE    "Enter a series of numbers between -100 and -1.",0
prgEndNote			BYTE	"To stop number input, enter in a positive number.",0
promptNum		    BYTE	" Enter number: ", 0
msgEntered			BYTE	"You entered ", 0
msgValidnum			BYTE	" valid numbers.", 0
sumTotal			BYTE	"The sum of your valid numbers is:  ", 0
avgTotal			BYTE	"The rounded average is:  ", 0
period				BYTE	".", 0
xtraCrdt			BYTE	"**EC: Lines will be numbered during user input.**", 0
nameInput		 	DWORD   ?
userNum				DWORD	?
sum					DWORD	0
average				DWORD	0
count				DWORD	0
currentNum			DWORD	1
incrNum 			DWORD	1
gbyeMsg 		 	BYTE    "Thank you for participating, we hope you see you again soon!",0
verifyBye		 	BYTE	"Results certified by Andrew Russo.",0



.code
main PROC
	call Clrscr

;Introduction with name, title, and extra credit
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET xtraCrdt
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
	mov		edx, OFFSET prgEndNote
	call	WriteString
	call	CrLf
	call	CrLf


getNumbers:
;prompt user for a number to be inputted
	mov		eax, currentNum
	call	WriteDec
	mov		edx, OFFSET period
	call	WriteString
	mov		edx, OFFSET promptNum
	call	WriteString
	call	ReadInt
	mov		userNum, eax

 ;check to see if number is within range of -100 to -1
 ;if not, jump to the end of program
	jns		printNums				;if number is positive, jump to printNum
	cmp		eax, LOWER_LIMIT		;if number is less than -100, restart
	jl		getNumbers


 ;if valid, update count
	mov		eax, count
	mov		ebx, incrNum
	add		eax, ebx
	mov		count, eax

 ;update sum
	mov		eax, sum
	mov		ebx, userNum
	add		eax, ebx
	mov		sum, eax

 ;update current number
	mov		eax, currentNum
	mov		ebx, incrNum
	add		eax, ebx
	mov		currentNum, eax

 ;continue until user enters a positive number
	jmp		getNumbers

 printNums:
 ;print number of valid numbers
	mov		edx, OFFSET msgEntered
	call	WriteString
	mov		eax, count
	call	WriteDec
	mov		edx, OFFSET	msgValidnum
	call	WriteString
	call	CrLf

 ;print sum total of entered numbers
	mov		edx, OFFSET sumTotal
	call	WriteString
	mov		eax, sum
	call	WriteInt
	call	CrLf

 ;check if there are valid numbers

	mov		eax, count
	cmp		eax, 0
	jz		noAverage
 ;calculate and print average if there are numbers to calculate
	mov		eax, sum
	cdq							;clear extra data from edx for division
	mov		ebx, count
	idiv	ebx
	mov		average, eax
	mov		edx, OFFSET avgTotal
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf
	jmp		farewell

noAverage:
;print rounded average of valid numbers
	mov		edx, OFFSET avgTotal
	call	WriteString
	mov		eax, average
	call	WriteInt
	call	CrLf



  farewell:
  	call	CrLf
  	mov		edx, OFFSET gbyeMsg
  	call	WriteString
	call	CrLf
  	mov		edx, OFFSET verifyBye
  	call	WriteString
  	call	CrLf
  	call	CrLf



    exit
main ENDP


END main
