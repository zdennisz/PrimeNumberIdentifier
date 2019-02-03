;Q3 prime number identification
;helps calculate if the number that was given is a prime , if it is not then show the possible dividers
.data
Num: 
list: .word64 7,11,13,17,19,23,29,31
;prompt_msg1: .asciiz "Enter First number"
;prompt_msg2: .asciiz "Enter Second number"
params_sys1: 
.word64 0
param2: 
.word64 0
param3:
.word64 0x10
len1:
.word64 0x10
len2:
.word64 0x10
len3:
.word64 0x10
Number1_text: .space 32
result_msg1: .asciiz " * "
Number2_text: .space 32
result_msg2: .asciiz " = "
result_msg: .asciiz "%s is prime "
.word64 0
result_msgFalse: .asciiz "%s is NOT a prime. %i * %i = %i"
.word64 0
printf_param:
.word64 0
x1:
.word64 0
x2:
.word64 0
x3:
.word64 0
x4:
.word64 0
Zero: 
  .word64 0x0
One: 
  .word64 0x1
Two: 
  .word64 0x2
Five: 
  .word64 0x5
Three: 
  .word64 0x3
Ten:
   .word 0xA
Eight:
   .word64 0x8
Thirty:
   .word64 0x1E

ZeroCode: .word64 0x30 ; Ascii '0' 	
.text
main: 
; r14 points to pramaters for syscall
daddi r8, r0,Number1_text ; r8 = Number1_text
daddi r14, r0, params_sys1 ; r14 = &params_sys1
daddi r9,r0,32 
jal read_keyboard_input
sd r1,len1(r0) ; Save first number length

;
sd r1,len2(r0) ; Save first number length
ld r10,len1(r0) ; n = r10 = length of Number1_text
daddi r17,r0,Number1_text
jal convert_string_to_binary
;

;
;checks if the number divides  by 3,2,5
jal check_for_two_three_five

ld r1,One(r0); check if the number is 2,3 or 5
beq r1,r12,Prime

jal check_if_Divides_two_three_five;check if the number can be divided by 2,3,5 with reminder 0
ld r1,One(r0)
beq r12,r1,NotPrime
;break - enable fore debugging mode
jal check_via_algorithem
beq r12,r0,NotPrime
b Prime ; need to add the r18,r15 into the string, which are the divisors
 sd r11,x3(r0)
;
Prime:
 daddi r13,r0,result_msg
b continue
 NotPrime:
daddi r13,r0,result_msgFalse

sd r13,printf_param(r0) 
sd r13,x1(r0)

 daddi r13,r0,Number1_text;insert the n
 sd r13,x1(r0)

 daddi r13,r0,Number2_text ;; insert the first divisor
 sd r15,x2(r0)
 daddi r13,r0,Number2_text ; insert the second divisor
 sd r18,x3(r0)
daddi r13,r0,Number1_text ;insert the n
 sd r11,x4(r0)
b skipToEnd
continue:
sd r13,printf_param(r0) 
sd r13,x1(r0)
daddi r13,r0,Number1_text
sd r13,x1(r0)
skipToEnd:
daddi r14,r0,printf_param
 syscall 5
end:
syscall 0

read_keyboard_input:
; function, expects r14 =&parameter address, r8 = &Destination string
; r9 = max destination size
; returns computed number in r1
;
sd r0,0(r14) ; read from keyboard
sd  r8,8(r14) ; Destinatiom address
sd  r9,16(r14) ; Destination size
syscall 3
jr $ra

convert_string_to_binary:
; function, expects r10 =string length, r17 = &Source string
; returns computed number in r11
daddi r13,r0,1 ; r13 = constant 1
daddi r20,r0,10 ; r20 = constant 10
movz r11,r0,r0 ; x1 = r11 = 0
ld   r19,ZeroCode(r0) ; r19 = '0'
For1:
  beq r10,r0,EndFor1 ; if (n == 0) break;
  dmultu r11,r20  ; lo = x * 10
  mflo r11        ;  x = r11 = lo = r11 * 10
  movz r16,r0,r0  ;  r16 = 0
  lbu r16,0(r17) ; r16 = text[i]
  dsub r16,r16,r19 ; r16 = text[i] - '0'
  dadd r11,r11,r16  ;x = x + text[i] - '0'
  dsub r10,r10,r13 ; n--
  dadd r17,r17,r13 ; i++ 
  b For1
EndFor1:
jr $ra

check_for_two_three_five:
;function ,expects the input at r11
;return in r12- 1 if number is equal to 2,3,5 else returns 0

ld r3,Two(r0)
beq r3,r11,IsPrime


ld r3,Three(r0)
beq r3,r11,IsPrime


ld r3,Five(r0)
beq r3,r11,IsPrime
b NotPrimeCurrently

IsPrime:
ld r12,One(r0)
b contine
NotPrimeCurrently:
ld r12,Zero(r0)
contine:
jr $ra



check_if_Divides_two_three_five:
;function ,expects the input at r11
;return in r12- 1 if number can be divided by 2,3,5 else returns 0
;return r15,18 -later we use the r15 as one of the dividers and we load the the other divider into r18 

ld r15,Two(r0)
ddivu r11,r15
mfhi r3
beq r3,r0,NotAPrime


ld r15,Three(r0)
ddivu r11,r15
mfhi r3
beq r3,r0,NotAPrime


ld r15,Five(r0)
ddivu r11,r15
mfhi r3
beq r3,r0,NotAPrime

ld r12,Zero(r0)
b continueWithExit
NotAPrime:
mflo r18
ld r12,One(r0)
continueWithExit:

jr $ra



check_via_algorithem:
;r11 the number that we are checking
;return r12- the result if prime return 1 else 0
;if the result is 0 - r18 , r15 returns the numbers that were the divisors

ld r3,Eight(r0); the upper boundry of the array

ld r13,One(r0); load 1 for the increments
ld r14,Zero(r0); the i init to 0
movz r2,r0,r0 ;r2 is the j  and equal to 0
movz r23,r0,r0
daddi r23,r23,list

For2:
  beq r2,r3,EndFor2 ; if (j == 8) break;
  ld r5,Thirty(r0); r5=30
	
whileLoop:  
dmultu r14,r5
mflo r1
;break
ld r7,0(r23);r7=arr[j]
dadd r4,r1,r7;arr[j]+30*i
ddiv r11,r4;n/((arr[j]+30*i)==k)
mfhi r19
beq r19,r0, DefinatlyNotPrime
mflo r19
dsub r20,r19,r4 ; n/k-arr[j]+30*i
bgez r20,innerIf
b NextJ 
innerIf:
ddiv r4,r11;arr[j]+30*i%n
mfhi r19
beq r19,r0,DefinatlyNotPrime
daddi r14,r14,0x1;i++
b whileLoop
NextJ:

 
  
movz r14,r0,r0; i=0
dadd r2,r2,r13 ; j++
daddi r23,r23,0x8 ; increment the pointer of the array
b For2
EndFor2:
ld r12,One(r0)
b EndOfFuncIsPrime

DefinatlyNotPrime:
movz r18,r4,r0 ;the return number that divides the current n
ddiv r11,r18
mflo r15 ;return the second divisor of the n
ld r12,Zero(r0) ;the return 1 because number is not prime

EndOfFuncIsPrime:

jr $ra

