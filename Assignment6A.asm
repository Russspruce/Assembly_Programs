TITLE Sum & Average using Macros      (Assignment6A.asm)

; Author: Andrew Russo					      Email: russoa@oregonstate.edu
; Course/Section: CS271-400
; Project ID: Assignment #6A					Due Date: 3/18/2018

; Description: This program uses macros to perform I/O procedures.
; It gets 10 unsigned integers from the user, stores them in an array,
; then displays them, the sum, and the average.




INCLUDE Irvine32.inc



; Macro: getString
; Description: Moves each of the user's inputed integers into a memory location.
; Parameters: address, length
; Registers: ecx, edx


getString	MACRO address, length
	push	edx
	push	ecx
	mov  	edx, address
	mov  	ecx, length
	call 	ReadString
	pop		ecx
	pop		edx
ENDM



; Macro: displayString
; Description: Shows the strings stored in each memory location. Will be used to display the info to the user and responses
; Parameters: theString
; Registers: edx


displayString	MACRO	theString
	push	edx
	mov		edx, OFFSET theString
	call	WriteString
	pop		edx
ENDM

;Constant for number of inputs
	NumArray = 10

.data
	buffer			  BYTE	255 DUP(0)
	stringTemp		BYTE	32 DUP(?);

  intro		    BYTE	"Sorting Random Integers by Andrew Russo", 0
	prgInfo		  BYTE	"Please provide 15 unsigned decimal integers.",0
	prgDscrpt   BYTE	"Each number needs to be small enough to fit inside a 32 bit register",13,10,
	                  " of the integers, their sum, and their average value.",0
	userPrompt	BYTE	"Enter an unsigned integer: ", 0
	errorMsg	  BYTE	"ERR0R. INVALID NUMBER INPUT. PLEASE TRY AGAIN: ", 0
	valueMsg		BYTE	"Your input: ",0
	sumMsg			BYTE	"The sum is: ",0
	averageMsg	BYTE	"The average is: ",0
  gbyeMsg 		BYTE "Thank you for participating, we hope you see you again soon!",0

	sum				  DWORD	?
	average			DWORD	?

	theArray		DWORD	10 DUP(0)

.code
main PROC

;Print intro
	displayString	intro
	call	CrLf
	displayString	prgInfo
	call	CrLf
	displayString	prgDscrpt
	call	CrLf
	call	CrLf



;Set loop controls
	mov		ecx, NumArray
	mov		edi, OFFSET theArray

userInputCode:
;Display prompt for user input
	displayString	userPrompt

;Push onto stack, call ReadVal
	push	OFFSET buffer
	push	SIZEOF buffer
	call	ReadVal

;Go to next array spot
	mov		eax, DWORD PTR buffer
	mov		[edi], eax
	add		edi, 4				;For next DWORD in array

;Loop if not 10 values yet
	loop	userInputCode



;Show the user what they entered into the array

;Set loop variables
	mov		ecx, NumArray
	mov		esi, OFFSET theArray
	mov		ebx, 0

;Display message
	displayString	valueMsg
	call			CrLf

;Calculates the sum total and print to console
sumAgainCode:
	mov		eax, [esi]
	add		ebx, eax

;Push parameters eax and stringTemp and call WriteVal to display it
	push	eax
	push	OFFSET stringTemp
	call	WriteVal
	add		esi, 4
	loop	sumAgainCode

;Display the sum
	mov				eax, ebx
	mov				sum, eax
	displayString	sumMsg

;Push sum and stringTemp parameters | Call WriteVal
	push	sum
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf



;Calculate the average (sum in eax)

;Clear edx | Move 10 into ebx
	mov		ebx, NumArray
	mov		edx, 0

;Divide the sum by 10
	div		ebx

;Determine if average total needs to be rounded
	mov		ecx, eax
	mov		eax, edx
	mov		edx, 2
	mul		edx
	cmp		eax, ebx
	mov		eax, ecx
	mov		average, eax
	jb		noRoundCode
	inc		eax
	mov		average, eax

noRoundCode:
	displayString	averageMsg

;Push parameters average and stringTemp and call WriteVal
	push	average
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf



;Display goodbye message

	displayString	gbyeMsg
	call	CrLf

	exit		; exit to operating system
main ENDP



; Procedure: ReadVal
; Description: Invokes getString macro to get the user's string of digits. Converts the digits string to numbers and validates input.
; Parameters: OFFSET buffer, SIZEOF buffer
; Registers: eax, ebx, ecx, edx, ebp, esp


readVal PROC
	push	ebp
	mov		ebp, esp
	pushad

StartCode:
	mov		edx, [ebp+12]	;@address of buffer
	mov		ecx, [ebp+8]	;size of buffer into ecx

;Read the input
	getString	edx, ecx

;Set registers
	mov		esi, edx
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, 10

;Load the string in byte by byte
LoadByteCode:
	lodsb					;loads from memory at esi
	cmp		ax, 0			;check if we have reached the end of the string
	je		DoneCode

;Check to see if within ASCII table
	cmp		ax, 48
	jb		ErrorResponse
	cmp		ax, 57
	ja		ErrorResponse


	sub		ax, 48
	xchg	eax, ecx
	mul		ebx
	jc		ErrorResponse
	jnc		NoErrorResponse

ErrorResponse:
	displayString	errorMsg
	jmp				StartCode


NoErrorResponse:
	add		eax, ecx
	xchg	eax, ecx		  ;Exchange next loop through
	jmp		LoadByteCode	;Next byte


DoneCode:
	xchg	ecx, eax
	mov		DWORD PTR buffer, eax	;Save int in passed variable
	popad
	pop ebp
	ret 8
readVal ENDP



; Procedure: WriteVal
; Description: Convert the numerical value to a string of digits and call displayString to produce output.
; Parameters: Integer and memory needed to write the output
; Registers: eax, ebx, ecx, edx, edi, ebp, esp


writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad		;save registers

;Set to loop through integers
	mov		eax, [ebp+12]	;move integer to convert to string to eax
	mov		edi, [ebp+8]	;move @address to edi to store string
	mov		ebx, 10
	push	0

ConvertCode:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	edx				;push the next digit onto the stack

;Check if at end
	cmp		eax, 0
	jne		ConvertCode

;Pop numbers off of stack
PopCode:
	pop		[edi]
	mov		eax, [edi]
	inc		edi
	cmp		eax, 0				;check if the end
	jne		PopCode

;Written as a string using macro
	mov				edx, [ebp+8]
	displayString	OFFSET stringTemp
	call			CrLf

	popad
	pop ebp
	ret 8
writeVal ENDP

END main
