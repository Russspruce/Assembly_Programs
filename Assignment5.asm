TITLE Sorting Random Integers     (Assignment5.asm)

; Author: Andrew Russo					Email: russoa@oregonstate.edu
; Course/Section: CS271-400
; Project ID: Assignment #5					Due Date: 3/4/2018
; Description: This program will get a number (10-200) from the user, generate random numbers and organize them into lists that will be
; sorted from highest to lowest number, as well as sort them from highest to lowest within a range of 100-900 integers.

INCLUDE Irvine32.inc

MIN_GENERATED = 10
MAX_GENERATED = 200

LOWER_LIMIT = 100
UPPER_LIMIT = 999

.data

titleMsg		BYTE	"Sorting Random Integers by Andrew Russo ",0
progMsg			BYTE	"This program generates random numbers in the range [100 .. 999], ",13,10
				BYTE	"displays the original list, sorts the list, and calculates the ",13,10
				BYTE	"median value.  Finally, it displays the list sorted in decending order. ",0
xtraCrdt		BYTE    "**Recursive Sorting Algorithm: QUICKSORT**",0
numPrompt		BYTE	"How many numbers would you like to generate? [10 .. 200]: ",0
errorMsg		BYTE	"ERR0R. INVALID INPUT. ENTER INPUT WITHIN RANGE.", 0
unsortedMsg		BYTE	"The unsorted random numbers: ",0
medianMsg	    BYTE	"The median is: ",0
sortedMsg	    BYTE	"The sorted list of random numbers: ",0
gbyeMsg 		BYTE    "Thank you for participating, we hope you see you again soon!",0
verifyBye		BYTE	"Results certified by Andrew Russo.",0
singleSpace	    BYTE	" ",0
doubleSpaces	BYTE	"  ",0
tripleSpaces	BYTE	"   ",0

numArray		DWORD	MAX_GENERATED DUP(0)
userInput		DWORD	?
numPerLine		DWORD	10
numTest			DWORD	?


.code
main PROC
	call Randomize


	call introduction


	push OFFSET userInput
	call getData


	push userInput
	push OFFSET numArray
	call fillArray


	mov edx, OFFSET unsortedMsg
	call WriteString
	call CrLf


	push userInput
	push OFFSET numArray
	call printList


	push OFFSET numArray ;sort array
    push 0
    mov eax, userInput
    dec eax
    push eax
    call quicksort


	mov edx, OFFSET medianMsg
	call WriteString
	call CrLf
	push userInput
	push OFFSET numArray
	call printMedian


    mov edx, OFFSET sortedMsg
    call WriteString
    call CrLf


    push userInput
    push OFFSET numArray
    call printList


  call farewell


	exit	; exit to operating system
main ENDP


; Introduction of the program
; info about program, extra credit, and procedures


introduction PROC
	mov edx, OFFSET titleMsg
	call WriteString
	call CrLf
	call CrLf

	mov edx, OFFSET xtraCrdt
	call WriteString
	call CrLf
	call CrLf

	mov edx, OFFSET progMsg
	call WriteString
	call CrLf
	call CrLf

	ret
introduction ENDP

; procedure to acquire the total number of random numbers to be generated from user
; will compare to max and min generated to insure that the input is valid and within the range
; Uses eax, edx, and ebp registeres


getData PROC USES eax edx ebp
	mov ebp, esp

	numberEntryLoop:
		mov edx, OFFSET numPrompt
		call WriteString
		call ReadInt

		cmp eax, MAX_GENERATED
		jle lessThanMaxGenerated
		jg errorLoop

	lessThanMaxGenerated:
		cmp eax, MIN_GENERATED
		jl errorLoop
		jmp inputOK

	errorLoop:
		mov edx, OFFSET errorMsg
		call WriteString
		call CrLf
		jmp numberEntryLoop

	inputOK:
		mov ebx, [ebp+16]
		mov [ebx], eax
		call CrLf

	ret 4

getData ENDP

; Procedure to fill the array with random numbers and puts them into an array depending on the number requested by the user based on inputs
; Uses eax, ecx, esi, and ebp registers

fillArray PROC USES esi ecx eax ebp

	mov ebp, esp
	mov esi, [ebp+20]
	mov ecx, [ebp+24] ; counts down

	mov eax, UPPER_LIMIT
	sub eax, LOWER_LIMIT
	inc eax

	fillUpArray:
		call RandomRange
		add eax, LOWER_LIMIT
		mov [esi], eax
		add esi, SIZEOF DWORD
		loop fillUpArray

	ret 8

fillArray ENDP


; Procedure to print off the array numbers
; Receives the address of array and value of count on system stack
; Uses ebx, ecx, esi, and ebp registers

printList PROC USES ebx ecx esi ebp

	mov ebp, esp
	mov esi, [ebp+20]
	mov ecx, [ebp+24]
	mov ebx, 0

	printArray:
		mov eax, [esi]
		call WriteDec

		mov numTest, eax
		push numTest
		call numberAlign

		add esi, SIZEOF DWORD
		inc ebx
		cmp ebx, numPerLine
		jl loopAgain

	newLine:
		call CrLf
		mov ebx, 0

	loopAgain:
		loop printArray

	call CrLf

	ret 8

printList ENDP


; Align the numbers to improve readability
; Uses eax, edx, ebp, and esp registers


numberAlign PROC

	mov ebp, esp
	mov eax,[ebp+16]
	mov edx, OFFSET doubleSpaces
	call WriteString
	ret 4

numberAlign ENDP


; Procedure to calculate and print the median of the random numbers previously generated
; Uses eax, ebx, ecx, edx esi, ebp, and esp registers


printMedian PROC
	pushad
	mov ebp, esp
	mov esi, [ebp+36]
	mov ecx, [ebp+40]
	cdq          ; convert doubleword to quadword and extend sign bit of eax
	mov eax, ecx
	mov ecx, 2
	div ecx
	mov ecx, eax
	cmp edx, 0
	je evenNumber ; if the remainder is zero, then it's an even number
	jmp oddNumber

	oddNumber:
		mov ebx, SIZEOF DWORD
		mul ebx
		mov ebx, [esi+eax]
		mov eax, ebx
		jmp printNumbers

	evenNumber:
		mov ebx, SIZEOF DWORD
		mul ebx
		mov ebx, [esi+eax]
		mov eax, ecx
		sub eax, 1
		mov ecx, SIZEOF DWORD
		mul ecx
		mov ecx, [esi+eax]
		cdq
		mov eax, ebx
		add eax, ecx
		mov ebx, 2
		div ebx
		jmp printNumbers

	printNumbers:
		call WriteDec
		call CrLf
		call CrLf

	popad    ; pop doubleword
	ret 8

printMedian ENDP


; Sorts the numbers in descending order using QUICKSORT!
; Uses eax, ebx, ecx, ebp, and esi registers
; source: https://www.geeksforgeeks.org/quick-sort/



quicksort PROC USES eax ebx ecx esi ebp

    mov     ebp, esp
    sub     esp, 4
    mov     esi, [ebp+32]

    mov     eax, [ebp+28]
    cmp     eax, [ebp+24]
    jl      sort
    jmp     sortEnd

    sort:
        lea     esi, [ebp-4]
        push    esi
        push    [ebp+32]
        push    [ebp+28]
        push    [ebp+24]
        call    quicksortCalc

        push    [ebp+32]
        push    [ebp+28]
        mov     eax, [ebp-4]
        dec     eax
        push    eax
        call    quicksort

        push    [ebp+32]
        mov     eax, [ebp-4]
        inc     eax
        push    eax
        push    [ebp+24]
        call    quicksort

    sortEnd:
    mov     esp, ebp ;moves everything back
    ret 12
quicksort ENDP


; Procedure swaps numbers in the array for quicksort
; Uses eax, ebx, ecx, esi, and ebp registers
; source: https://www.geeksforgeeks.org/quick-sort/


quicksortCalc PROC USES eax ebx ecx esi ebp

    mov     ebp, esp
    sub     esp, 8
    mov     esi, [ebp+32]

    mov     eax, [ebp+28]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     eax, [esi+eax]
    mov     [ebp-4], eax

    mov     eax, [ebp+28]
    mov     [ebp-8], eax
    inc     eax
    mov     ecx, eax

    outerLoop:
        cmp     ecx, [ebp+24]
        jg      endLoop

        inner:
        mov     eax, ecx
        mov     ebx, SIZEOF DWORD
        mul     ebx
        mov     eax, [esi+eax]
        cmp     eax, [ebp-4]
        jl      incLoop

        push    [ebp+32]
        mov     eax, [ebp-8]
        inc     eax
        push    eax
        push    ecx
        call    numberShuffle
        push    [ebp+32]
        push    [ebp-8]
        mov     eax, [ebp-8]
        inc     eax
        push    eax
        call    numberShuffle

        mov     eax, [ebp-8]
        inc     eax
        mov     [ebp-8], eax

	incLoop:
        inc     ecx
        jmp     outerLoop


    endLoop:
    mov     eax, [ebp+36]
    mov     ebx, [ebp-8]
    mov     [eax], ebx
    mov     esp, ebp
    ret 12
quicksortCalc ENDP


; Shuffles numbers in the array for quicksort
; source: https://www.geeksforgeeks.org/quick-sort/
; Uses eax, ebx, ecx, esi, and ebp registers


numberShuffle PROC USES eax ebx ecx esi ebp

    mov     ebp, esp
    sub     esp, 4
    mov     esi, [ebp+32]

    mov     eax, [ebp+28]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ebx, [esi+eax]
    mov     DWORD PTR [ebp-4], ebx

    mov     eax, [ebp+24]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ecx, [esi+eax]
    mov     eax, [ebp+28]
    mul     ebx
    mov     [esi+eax], ecx

    mov     eax, [ebp+24]
    mov     ebx, SIZEOF DWORD
    mul     ebx
    mov     ecx, [ebp-4]
    mov     [esi+eax], ecx

    mov     esp, ebp
    ret 12
numberShuffle ENDP


; Procedure for farewell
; Uses edx register


farewell PROC
  call	CrLf
  mov		edx, OFFSET gbyeMsg
  call	WriteString
  call	CrLf
  mov		edx, OFFSET verifyBye
  call	WriteString
  call	CrLf
  call	CrLf

	ret
farewell ENDP


END main
