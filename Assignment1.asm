TITLE Intro: Basic Mathematical Operations     (Assignment1.asm)

; Author: Andrew Russo					Email: russoa@oregonstate.edu
; Course/Section: CS271-400
; Project ID: Assignment #1					Due Date: 01/21/2018
; Description:

INCLUDE Irvine32.inc

.data

firstNum     DWORD ?
secondNum    DWORD ?

intro        BYTE "Elementary Arithmetic by Andrew Russo", 0
instruction  BYTE "Please enter two numbers to see their results using basic math.", 0
xtrCrdt1     BYTE "**Program will check to see if the second number is less than the first number.**",0
xtrCrdt2     BYTE "**Program will repeat until user chooses option to exit.**",0
numError	 BYTE "ERR0R: Please try again with the second number being smaller",0

firstLine    BYTE "First Number Input: ",0
secondLine   BYTE "Second Number Input: ",0

sumTotal     DWORD ?
diffTotal    DWORD ?
prodTotal    DWORD ?
divTotal     DWORD ?
remTotal     DWORD ?
rptInpt 	 DWORD ?

sumResult		 BYTE	"Sum: ",0
diffResult	 BYTE	"Difference: ",0
prodResult   BYTE	"Product: ",0
divResult		 BYTE	"Quotient: ",0
remResult		 BYTE	"Remainder: ",0

repeatPrompt BYTE "To restart, enter 0 to reset or any key to exit.",0
endProg      BYTE "Thank you for participating, farewell!",0


.code
main PROC
	call Clrscr


  ;Introduction with name, title, and extra credit
  	mov		edx, OFFSET intro
  	call	WriteString
    call	CrLf
    mov		edx, OFFSET xtrCrdt1
    call	WriteString
    call	CrLf
    mov		edx, OFFSET xtrCrdt2
    call	WriteString
  	call	CrLf
  	call	CrLf


  ;Display instructions
  	mov		edx, OFFSET instruction
  	call	WriteString
  	call	CrLf
  	call	CrLf


  start:


  ;Get first number
  	mov		edx, OFFSET firstLine
  	call	WriteString
  	call	ReadInt
  	mov		firstNum, eax

  ;Get second number
  	mov		edx, OFFSET secondLine
  	call	WriteString
  	call	ReadInt
  	mov		secondNum, eax
  	call	CrLf


  ;Compare two numbers
   	mov		eax, firstNum
   	cmp		eax, secondNum
   	jle		PrintError
   	jmp		CalculateStuff



  PrintError:
    mov		edx, OFFSET numError
  	call	WriteString
  	call	CrLf
  	call	CrLf
  	jmp		Restart

 CalculateStuff:
  ;Sum calculations and print
  	mov		eax, firstNum
  	mov		ebx, secondNum
  	add		eax, ebx
  	mov		sumTotal, eax


  	mov		edx, OFFSET sumResult
  	call	WriteString
  	mov		edx, OFFSET sumTotal
  	call	WriteInt
  	call	CrLf


  ;Difference calculations and print
  	mov		eax, firstNum
  	mov		ebx, secondNum
  	sub		eax, ebx
  	mov		diffTotal, eax


  	mov		edx, OFFSET	diffResult
  	call	WriteString
  	mov		edx, OFFSET diffTotal
  	call	WriteInt
  	call	CrLf


  ;Product calculations and print
  	mov		eax, firstNum
  	mov		ebx, secondNum
  	mul		ebx
  	mov		prodTotal, eax


  	mov		edx, OFFSET prodResult
  	call	WriteString
  	mov		edx, OFFSET prodTotal
  	call	WriteInt
  	call	CrLf


  ;Quotient calculations and print of booth quotient and remainder
  	mov		eax, firstNum
  	mov		ebx, secondNum
  	mov		edx, 0
  	div		ebx
  	mov		divTotal, eax
  	mov		remTotal, edx


  	mov		edx, OFFSET divResult
  	call	WriteString
  	mov		edx, OFFSET divTotal
  	call	WriteInt


  	mov		edx, OFFSET remResult
  	call	WriteString
  	mov		edx, OFFSET remTotal
  	call	WriteInt
  	call	CrLf


  Restart:                 ;Where program will restart if user wishes
  	mov		edx, OFFSET repeatPrompt
  	call	WriteString
  	call	ReadInt
  	mov		rptInpt, eax
  	call	CrLf
  	cmp		rptInpt, 0			  ;If input is a 0, repeat again
  	je		start						  ;Otherwise, it will start back at number inputs


  Farewell:
  	mov		edx, OFFSET endProg
  	call	WriteString
  	call	CrLf


    exit
main ENDP


END main
