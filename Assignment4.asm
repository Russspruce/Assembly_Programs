TITLE Intro: Composite Numbers     (Assignment4.asm)

; Author: Andrew Russo					  Email: russoa@oregonstate.edu
; Course/Section: CS271-400
; Project ID: Assignment #4				  Due Date: 02/18/2018
; Description:  Displays the number of composite numbers depending on the number entry submitted by the user.




INCLUDE Irvine32.inc

LOWER_LIMIT = 1
UPPER_LIMIT = 400

.data

intro	      BYTE		"Composite Numbers by Andrew Russo",0
xtraCrdt	  BYTE		"**EC: Aligned the output columns test**",0
prgInfo       BYTE		"Please enter the number of composites you would like to see. ",0
prgNote		  BYTE		"Program will accept entries up to 400 composites. ",0
numEntry	  BYTE		"Enter the number of composites to display between 1 and 400: ",0
errorMsg	  BYTE		"ERR0R. Out of range. Please try again. ",0
gbyeMsg 	  BYTE		"Thank you for participating, we hope you see you again soon!",0
verifyBye	  BYTE		"Results certified by Andrew Russo.",0
spaces		  BYTE		"    ",



userNum		  DWORD	?
countNum	  DWORD	?
currentNum	  DWORD	4	; number being evaluated. 4 is the first composite number
loopCount	  DWORD	0

.code
main PROC

	call introduction
	call getUserData
	call showComposites
	call farewell

	exit	
main ENDP

; procedure to introduce the program

introduction PROC
	mov edx, OFFSET intro
	call WriteString
	call CrLf
	mov edx, OFFSET xtraCrdt
	call WriteString
	call CrLf
	call CrLf

	ret

introduction ENDP

; procedure to acquire the number of orders from user

getUserData PROC
	mov edx, OFFSET prgInfo
	call WriteString
	call CrLf

	mov edx, OFFSET prgNote
	call WriteString
	call CrLf

	mov edx, OFFSET numEntry
	call WriteString
	call ReadInt
	mov userNum, eax
	call validate

	ret
getUserData ENDP

; procedure to validate the user entered number can work

validate PROC

	; check if number is between two limits
	numberEntryLoop:
		cmp userNum, UPPER_LIMIT
		jg errorLoop
		cmp userNum, LOWER_LIMIT
		jl errorLoop
		jmp validInputLoop

	; number is not between the limits
	errorLoop:
		mov edx, OFFSET errorMsg
		call WriteString
		call CrLf

		mov edx, OFFSET numEntry
		call WriteString
		call ReadInt
		mov userNum, eax
		call validate

	validInputLoop:
	ret
validate ENDP


; procedure to calculate and display the first composite numbers

showComposites PROC
	mov ecx, userNum ; loop counter

	compositeLoop:
		call isComposite
		mov eax, currentNum
		call WriteDec     ; print off composite number
		mov edx, OFFSET spaces
		call WriteString
		inc currentNum
		inc countNum

		; Check numbers present on the line
		cmp countNum, 10
		je newLineLoop
		loop compositeLoop
		jmp showCompositeDone

	newLineLoop:
		call CrLf
		mov countNum, 0
		loop compositeLoop

	showCompositeDone:
		ret

showComposites ENDP

; procedure to calculate next composite number
; registers changed to eax, ebx, and edx

isComposite PROC
	; is currentNum even? if so, it is a composite!
	mov edx, 0
	mov eax, currentNum
	mov ebx, 2
	div ebx
	cmp edx, 0
	je returnComposite


	mov edx, 0
	mov eax, currentNum
	mov ebx, 3
	div ebx
	cmp edx, 0
	je returnComposite

	; currentNum is odd and NOT divisible by 3
	; will calculate if it is a prime number

	mov countNum, 5

	calculationLoop:
		mov edx, 0
		mov eax, currentNum
		mov ebx, countNum

		;if countNum is equal to currentNum then it is prime
		cmp eax, ebx
		je currentNumIsPrime

		div ebx
		cmp edx, 0
		je returnComposite

		add countNum, 2
		mov edx, 0
		mov eax, currentNum
		mov ebx, countNum
		cmp eax, ebx ;if currentNum is same as countNum, then current is prime
		je currentNumIsPrime
		div ebx
		cmp edx, 0 ;if edx = 0 then currentNum is divisible by countNum
		je returnComposite

		add countNum, 4
		mov edx, 0
		mov eax, countNum
		mul countNum
		cmp eax, currentNum
		jle calculationLoop

	currentNumIsPrime: ;if number input is prime, then adding 1 using inc to the number will make it a composite number
		inc currentNum

	returnComposite:
		ret
isComposite ENDP

; procedure for farewell

farewell PROC 
  call	CrLf
  mov	edx, OFFSET gbyeMsg
  call	WriteString
  call	CrLf
  mov	edx, OFFSET verifyBye
  call	WriteString
  call	CrLf
  call	CrLf

	ret
farewell ENDP

END main
