;Receives the arr and the X point and the power and calculate the polynom at that X point 
.data
myArr: 
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
	.double 0.0
 
prompt_msg1: .asciiz "Enter n:\n"

prompt_msg2: .asciiz "Enter X:\n"
prompt_msg3: .asciiz "Enter array: \n"

lenArr:
.word64 0x10

len1:

.word64 0x10

len2:

.word64 0x10

return_addr:

.word64 0
DOne:
    .double 1.0
DFive: 
    .double 5.0
DTen: 
    .double 10.0
Ten:
   .word64 0xA
MyZero: .asciiz "0.00000000e+0"
MyOne: .asciiz "1.00000000e+0"
MyMinusOne: .asciiz "-1.00000000e+0"
ZeroCode: .word64 0x30 ; Ascii '0' 
Dconsts:
    .double 1.0E100
    .double 1.0E200
    .double 1.0E300
    .double 1.0E10
    .double 1.0E20
    .double 1.0E30
    .double 1.0E40
    .double 1.0E50
    .double 1.0E60
    .double 1.0E70
    .double 1.0E80
    .double 1.0E90
    .double 1.0E1
    .double 1.0E2
    .double 1.0E3
    .double 1.0E4
    .double 1.0E5
    .double 1.0E6
    .double 1.0E7
    .double 1.0E8
    .double 1.0E9
Dconsts2:
    .double 1.0E100
    .double 1.0E200
    .double 1.0E300
    .double 1.0E50
    .double 1.0E10
    .double 1.0E20
    .double 1.0E30
    .double 1.0E40
    .double 1.0E5
    .double 1.0E1
    .double 1.0E2
    .double 1.0E3
    .double 1.0E4
    .double 1.0E5
    .double 1.0E6
    .double 1.0E7
    .double 1.0E8
    .double 1.0E9
OneLong:
.word64 1
One:
.double 1.0

DZero: 
.double 0.0

sum_text: .space 32

N_text: 
.space 32

arr_Text: 
.space 32

params_sys1: 
.word64 0

printf_param0: 
.word64 0
printf_param1: 
.word64 0
s1: .word64 0
s2: .word64 0
print_result: .space 32

X_text: .space 32
X: .double 0.0

N: .word64 0

N_Max: .word64 8


result_msg1: .asciiz "polynom P(%s)=%s"




sum:
.double 0.0
.text
main:

		; print out the introducting message of the enter the n var
addi r14,r0,printf_param0

addi r10,r0,prompt_msg1

sd r10,printf_param0(r0)

syscall 5

; r14 points to pramaters for syscall

daddi r8, r0,N_text ; r8 = N_text

daddi r14, r0, params_sys1 ; r14 = &params_sys1

daddi r9,r0,32 

jal read_keyboard_input

sd r1,len1(r0) ; Save first number length

ld r10,len1(r0) ; n = r10 = length of N_text

daddi r17,r0,N_text

jal convert_string_to_binary

sd r11,N(r0);store the int in its place
ldc1 f12,DZero(r0);zero out the f11 register just in case
ldc1 f23,DZero(r0); load zero into the register
mtc1 r11,f12 ; copies the lower 32 bit into the register
cvt.d.l f12,f12 ;reads the f11 as int and converts to double
ldc1 f24,One(r0); the +1 incrementer
movz r2,r0,r0 ;zero out the r2 , just in case
daddi r2,r2,myArr ; load the address of the arr in the register

addi r14,r0,printf_param0

addi r10,r0,prompt_msg3

sd r10,printf_param0(r0)

syscall 5


;initiate loop of recieving the numbers according to the n var that was input
While_Input_Loop:
c.eq.d 7,f12,f23; compare the upper limit according to what the user has inserted
bc1t 7,End_While_Input_Loop

daddi r14, r0, params_sys1

daddi r8, r0,arr_Text

daddi r9,r0,32 

jal read_keyboard_input
;

sd r1,lenArr(r0) ; Save the number length
;
ld r10,lenArr(r0) ; n = r10 = length of arr[i]

dadd r17,r0,r8

jal myatof
;
mov.d f20,f11 ; f20 = arr[i]

s.d f11,0(r2) ; store the number in the array

daddi r2,r2,0x8 ;increment to the next i 
;
add.d f23,f23,f24; increment ++1 to the loop counter
b While_Input_Loop
End_While_Input_Loop:

;reading X

addi r14,r0,printf_param0

addi r10,r0,prompt_msg2

sd r10,printf_param0(r0)

syscall 5

; 

daddi r14, r0, params_sys1

daddi r8, r0,X_text

daddi r9,r0,32 

jal read_keyboard_input

sd r1,len2(r0) ; Save second number length

daddi r17,r0,X_text

ld r10,len2(r0) ; n =r10 = length of X_text

jal myatof

;

mov.d f20,f11 ; f20 = X

sdc1 f11,X(r0);store the x in the memory
movz r14,r0,r0

daddi r17,r0,X_text ; r17 = &X_text 
ldc1 f11,X(r0)
jal myftoa

movz r2,r0,r0 ;zero out the r2 , just in case
daddi r2,r2,myArr ; load the address of the arr in the register
ld r4,N(r0) ;load the N in r4 so it can be used later
l.d f3,X(r0);load the X into f3 so it can be used later
jal compute_polynom 


print_polynom:
sd r17,s1(r0)	 
mov.d f11,f1	
daddi r17,r0,print_result
 
jal myftoa
sd r18,len2(r0)
daddi r13,r0,result_msg1
sd r13,printf_param1(r0)
daddi r13,r0,X_text
sd r13,s1(r0)
daddi r13,r0,print_result
sd r13,s2(r0)
daddi r14,r0,printf_param1
syscall 5

syscall 0



compute_polynom:
;expected  r2 as the arr , r4 as the N , f3 as the X
;calculates the value of polynom according to the polynom that was given 
;return is in f0 
sd r31 ,return_addr(r0); save the return address to the main
movz r22,r4,r0
ld r3,OneLong(r0)
dsubu r4,r4,r3 ; inital -1 to the power since we begin from n-1


whileMainLoop:
beqz r22,EndMainLoop
movz r24,r4,r0 ;send the power of the X
jal X_to_power; r16 is the result of the power
l.d f10,0(r2)
mul.d f6,f10,f16;arr[i]*x**(n-i)
add.d f1,f6,f1;sum+arr[i]*x**(n-i),f1 is the return value of the sum


dsubu r4,r4,r3 ;power  counter
dsubu r22,r22,r3;main loop counter
daddi r2,r2,0x8; increment the arr[i]

b whileMainLoop
EndMainLoop:
movz r2,r0,r0 ;zero out the r2 , just in case
daddi r2,r2,myArr ; load the address of the arr in the register
l.d f10,0(r2);add the arr[0] again - it says so in the expression
add.d f1,f10,f1



ld r31 ,return_addr(r0);load the return address and jump back to the printing
jr $ra


X_to_power:
;expects the value of the power in r24
;return the x to the power of the n in f16
beqz r24,EndPowerLoop ;power that was sent is 0

ld r3,OneLong(r0);for the --1 decremnt
dsubu r24,r24,r3;when load the return with value of x it is already used 1 power
mov.d f16,f3; init with X
loopOfPower:
BEQZ r24,returnTheValue
mul.d f16,f16,f3 ;make the multiplication of the power
dsubu r24,r24,r3; --1 to the loop 
b loopOfPower

EndPowerLoop:
l.d f16,DOne(r0);in case the power is 0 return 1 since number in power 0 is 1
returnTheValue:
jr $ra



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

myatof:
; function, expects r10 =string length, r17 = &Source string
; returns computed number in f11

ldc1 f11,DZero(r0)
ldc1 f10,DTen(r0)
ldc1 f8,DOne(r0)
ldc1 f0,DZero(r0)
movz r9,r0,r0 ; r9 == i =0
movz r18,r17,r0 ; r18 = &str[0]
movz r6,r0,r0
lb r6,0(r18)
daddi r7,r0,45; r7 = '-'
bne r6,r7,Skipa1
sub.d f8,f0,f8 ; f8 = -1;
daddi r18,r18,1
b Skipa2
Skipa1:
daddi r7,r0,43; r7 = '+'
bne r6,r7,Skipa2
daddi r18,r18,1
Skipa2:
ldc1 f22,DOne(r0)
div.d f29,f22,f10 ; f22 = 0.1
mov.d f22,f29
movz r6,r0,r0
lb r6,0(r18); r6 = str[i]
daddi r6,r6,-48 ; r6 =  r6 - '0'
dmtc1 r6,f5
cvt.d.l f5,f5  ; f5 = (double) (str[i] - '0')
add.d f11,f11,f5
daddi r18,r18,2
Whilea1:
daddi r7,r0,101 ; r7 = 'e'
movz r6,r0,r0
lb r6,0(r18); r6 = str[i]
beq r6,r7,EndWhilea1 
daddi r7,r0,69; r7 ='E'
beq r6,r7,EndWhilea1 
daddi r7,r0,48; r7 = '0'
dsub r6,r6,r7 ; r6 = r6 - '0'
dmtc1 r6,f5
cvt.d.l f5,f5 ; f5 = (double) (str[i] - '0')
mul.d f5,f5,f22
add.d f11,f11,f5
div.d f22,f22,f10
daddi r18,r18,1
b Whilea1
EndWhilea1:

daddi r18,r18,1
mov.d f22,f10
movz r5,r0,r0
daddi r24,r0,1
daddi r7,r0,45; r7 = '-'
movz r6,r0,r0
lb r6,0(r18); r6 = str[i]
bne r6,r7,Skipa3
daddi r24,r0,-1
;daddi r18,r18,1
Skipa3:
;daddi r18,r18,1
daddi r18,r18,1
dsub r25,r18,r17 ; r25 = i;
movz r19,r0,r0
ld r20,Ten(r0)
Whilea2:
  dsub r21,r25,r10
  beqz r21,EndWhilea2
  dmult r19,r20
  mflo r19
  movz r6,r0,r0
  lb r6,0(r18); r6 = str[i]
  daddi r6,r6,-48  ; r6 = r6 - '0'
  dadd r19,r19,r6
  daddi r18,r18,1
  daddi r25,r25,1
b Whilea2
EndWhilea2:
 movz r29,r19,r0
bgez r24,PositivePower

daddi r21,r0,8 ; r21 = 8
addi r10,r0,100; r10 = 100
ddiv r29,r10
mflo r15
movz r16,r15,r0
beqz r16,NoHundred1
addi r16,r16,-1
dmult r16,r21
mflo r16
ldc1 f28,Dconsts(r16)
div.d f11,f11,f28
NoHundred1:
dmult r15,r10
mflo r16
dsub r16,r29,r16
addi r10,r0,10
ddiv r16,r10
mflo r15
movz r16,r15,r0
beqz r16,NoTen1
addi r16,r16,2
dmult r16,r21
mflo r16
ldc1 f28,Dconsts(r16)
div.d f11,f11,f28
NoTen1:
ddiv r29,r10
mfhi r15
movz r16,r15,r0
beqz r16,NoOne1
addi r16,r16,11
dmult r16,r21
mflo r16
ldc1 f28,Dconsts(r16)
div.d f11,f11,f28

NoOne1:


b NoOne2

PositivePower:

daddi r21,r0,8
addi r10,r0,100
ddiv r29,r10
mflo r15
movz r16,r15,r0
beqz r16,NoHundred2
addi r16,r16,-1
dmult r16,r21
mflo r16
ldc1 f28,Dconsts(r16)
mul.d f11,f11,f28
NoHundred2:
dmult r15,r10
mflo r16
dsub r16,r29,r16
addi r10,r0,10
ddiv r16,r10
mflo r15
movz r16,r15,r0
beqz r16,NoTen2
addi r16,r16,2
dmult r16,r21
mflo r16
ldc1 f28,Dconsts(r16)
mul.d f11,f11,f28
NoTen2:
ddiv r29,r10
mfhi r15
movz r16,r15,r0
beqz r16,NoOne2
addi r16,r16,11
dmult r16,r21
mflo r16
ldc1 f28,Dconsts(r16)
mul.d f11,f11,f28

NoOne2:

mul.d f11,f11,f8

jr $ra



myftoa:
; function, expects f11 =source number, r17 = &destination string
; returns length in r18
;
; id f == 0.0?

mov.d f12,f11 ; f12 = x
ldc1 f0,DZero(r0)
ldc1 f1,DOne(r0)
c.eq.d 7,f12,f0 ; f == 0.0?
bc1f 7,NotZero  ; No, Skip
movz r18,r17,r0; r18 = &str[0]
addi r9,r0,13
addi r29,r0,MyZero
MemCpy:
 beqz r9,EndMemCpy
 lb r6,0(r29)
 sb r6,0(r18)
 addi r18,r18,1
 addi r29,r29,1
 addi r9,r9,-1
 b MemCpy
EndMemCpy:
 addi r18,r0,13
 jr $ra
NotZero:


mov.d f22,f12 ; f22 = x
c.eq.d 7,f12,f1 ; f == 1.0?
bc1f 7,NotOne  ; No, Skip
movz r18,r17,r0; r18 = &str[0]
addi r9,r0,13
addi r29,r0,MyOne
MemCpy2:
 beqz r9,EndMemCpy2
 lb r6,0(r29)
 sb r6,0(r18)
 addi r18,r18,1
 addi r29,r29,1
 addi r9,r9,-1
 b MemCpy2
EndMemCpy2:
daddi r18,r18,13
jr $ra

NotOne:

mov.d f22,f12 ; f22 = x
sub.d  f1, f0,f1 ; f1  = - 1.0
c.eq.d 7,f12,f1 ; f == -1.0?
bc1f 7,NotMinusOne  ; No, Skip
     

movz r18,r17,r0; r18 = &str[0]
addi r9,r0,14
addi r29,r0,MyMinusOne
MemCpy3:
 beqz r9,EndMemCpy3
 lb r6,0(r29)
 sb r6,0(r18)
 addi r18,r18,1
 addi r29,r29,1
 addi r9,r9,-1
 b MemCpy3
EndMemCpy3:
daddi r18,r18,14
jr $ra


NotMinusOne:



movz r18,r17,r0; r18 = &str[0]
ldc1 f0,DZero(r0)
ldc1 f1,DOne(r0)
ldc1 f10,DTen(r0)
c.lt.d 7,f11,f0 ; x < 0 ?
bc1f 7,NonNeg; No, x >= 0.0
sub.d f12,f0,f12; f12 = -x (|x|)
;sub.d f11,f0,f11; f11 = -x (|x|)
daddi r6,r0,45 ; str[0] = '-'
sb r6,0(r18);
daddi r18,r18,1
NonNeg:
; f < 1.0
c.lt.d 7,f12,f1 ; x < 1 ?
bc1t 7,LessOne	; No, x >= 0.0


addi r3,r0,3
movz r9,r0,r0 ; r9 = 0
movz r4,r0,r0 ; r4 = 0
addi r29,r0,Dconsts2
Whilefh1:
ldc1 f29,0(r29)
c.lt.d 7,f12,f29
bc1t 7,EndWhilefh1
beqz r3,EndWhilefh1 
addi r4,r4,1
addi r3,r3,-1
addi r29,r29,8
addi r9,r9,100
b Whilefh1
EndWhilefh1:

beqz r4,NoH1
addi r29,r29,-8
ldc1 f29,0(r29)
div.d f12,f12,f29
NoH1:
addi r29,r0,Dconsts2
addi r29,r29,24
;addi r4,r0,0
;addi r3,r0,9

; Compare with 1E50
ldc1 f29,0(r29)
c.lt.d 7,f12,f29 
bc1t 7,Skipft1
addi r9,r9,50
div.d f12,f12,f29
Skipft1:
addi r29,r0,Dconsts2
addi r29,r29,32
addi r3,r0,4
addi r4,r0,0

Whileft1:
ldc1 f29,0(r29)
c.lt.d 7,f12,f29
bc1t 7,EndWhileft1
beqz r3,EndWhileft1 
addi r4,r4,1
addi r3,r3,-1
addi r29,r29,8
addi r9,r9,10
b Whileft1
EndWhileft1:

beqz r4,NoD1
addi r29,r29,-8
ldc1 f29,0(r29)
div.d f12,f12,f29
NoD1:

addi r29,r0,Dconsts2
addi r29,r29,64

; Compare with 1E5
ldc1 f29,0(r29)
c.lt.d 7,f12,f29 
bc1t 7,Skipfs1
addi r9,r9,5
div.d f12,f12,f29
Skipfs1:
addi r29,r0,Dconsts2
addi r29,r29,72

addi r4,r0,0
addi r3,r0,4

Whilefs1:
ldc1 f29,0(r29)
c.lt.d 7,f12,f29
bc1t 7,EndWhilefs1
beqz r3,EndWhilefs1 
addi r4,r4,1
addi r3,r3,-1
addi r29,r29,8
addi r9,r9,1
b Whilefs1
EndWhilefs1:

beqz r4,NoS1
addi r29,r29,-8
ldc1 f29,0(r29)
div.d f12,f12,f29
NoS1:

b GrOne
LessOne:
ldc1 f1,DOne(r0)
 
addi r3,r0,3
movz r9,r0,r0 ; r9 = 0
movz r4,r0,r0 ; r4 = 0
addi r29,r0,Dconsts2
Whilefh2:
ldc1 f29,0(r29)
mul.d f13,f12,f29
c.lt.d 7,f13,f1
bc1f 7,EndWhilefh2
beqz r3,EndWhilefh2 
addi r4,r4,1
addi r3,r3,-1
addi r29,r29,8
addi r9,r9,-100
b Whilefh2
EndWhilefh2:

beqz r4,NoH2
addi r29,r29,-8
ldc1 f29,0(r29)
mul.d f12,f12,f29
NoH2:

addi r29,r0,Dconsts2
addi r29,r29,24
addi r4,r0,0
addi r3,r0,9
; Compare f*1.0E+50 < 1
ldc1 f29,0(r29)
mul.d f13,f12,f29
c.lt.d 7,f13,f1
bc1f 7,Skipft2
addi r9,r9,-50
mul.d f12,f12,f29
Skipft2:
addi r29,r0,Dconsts2
addi r29,r29,32
addi r3,r0,4
addi r4,r0,0
Whileft2:
ldc1 f29,0(r29)
mul.d f13,f12,f29
c.lt.d 7,f13,f1
bc1f 7,EndWhileft2
beqz r3,EndWhileft2
addi r4,r4,1
addi r3,r3,-1
addi r29,r29,8
addi r9,r9,-10
b Whileft2
EndWhileft2:

beqz r4,NoD2
addi r29,r29,-8
ldc1 f29,0(r29)
mul.d f12,f12,f29
NoD2:
addi r29,r0,Dconsts2
addi r29,r29,64

; Compare f*1.0E+5 < 1
ldc1 f29,0(r29)
mul.d f13,f12,f29
c.lt.d 7,f13,f1
bc1f 7,Skipfs2
addi r9,r9,-5
mul.d f12,f12,f29
Skipfs2:
addi r29,r0,Dconsts2
addi r29,r29,72
addi r3,r0,4
addi r4,r0,0

Whilefs2:
ldc1 f29,0(r29)
mul.d f13,f12,f29
c.lt.d 7,f13,f1
bc1f 7,EndWhilefs2
beqz r3,EndWhilefs2 
addi r4,r4,1
addi r3,r3,-1
addi r29,r29,8
addi r9,r9,-1
b Whilefs2
EndWhilefs2:
addi r9,r9,-1

beqz r4,NoS2
addi r29,r29,-8
ldc1 f29,0(r29)
mul.d f12,f12,f29
NoS2:
ldc1 f10,DTen(r0)
mul.d f12,f12,f10

c.lt.d 7,f12,f1
bc1f 7,NotLessOne
mul.d f12,f12,f10
NotLessOne:
movz r5,r5,r0
GrOne:
daddi r6,r0,46 ; str[i] = '.'
sb r6,1(r18)
daddi r19,r18,1 ;r19 == pos1


movz r21,r0,r0
daddi r22,r0,8

  ldc1 f23,DFive(r0)
  c.lt.d 7,f23,f12 ; 5.0 < f12?
  bc1f 7,LessThanDfive
  daddi r23,r0,4 ; digit = 4
  b  SkipDfive  
LessThanDfive:
  mov.d f23,f1 ; f23 = 1.0
  daddi r23,r0,0 ; r23 == digit = 0
SkipDfive:
movz r5,r5,r0
  whilef3a:
     c.lt.d 7,f12,f23 ; f12  < f23? f < g?
     bc1t 7,EndWhilef3a  ; Yes, break f < g
     daddi r23,r23,1 ; digit++ g <= f
     add.d f23,f23,f1
  b whilef3a
  EndWhilef3a:

  daddi r23,r23,48; r23 = r23 + '0'
  sb r23,0(r18) ; str[i] = digit
  addi r18,r18,2
  add.d f12,f12,f1
  sub.d f12,f12,f23
  mul.d f12,f12,f10


Forf1:
;break
  beq r21,r22,EndForf1 ; i < 8?

  ldc1 f23,DFive(r0)
  c.lt.d 7,f23,f12 ; 5.0 < f12?
  bc1f 7,LessThanDfive2
  daddi r23,r0,4 ; digit = 4
  b  SkipDfive2  
LessThanDfive2:
  mov.d f23,f1 ; f23 = 1.0
  daddi r23,r0,0 ; r23 == digit = 0
SkipDfive2:
movz r5,r5,r0

  whilef3b:
     c.lt.d 7,f23,f12 ; f23 < f12?
     bc1f 7,EndWhilef3b ; No, break
     daddi r23,r23,1 ; digit++
     add.d f23,f23,f1
  b whilef3b
  EndWhilef3b:



  daddi r23,r23,48; r23 = r23 + '0'
  sb r23,0(r18) ; str[i] = digit
  daddi r18,r18,1
  add.d f12,f12,f1
  sub.d f12,f12,f23
  mul.d f12,f12,f10
  addi r21,r21,1
  b Forf1  

 
movz r5,r5,r0

EndForf1:
  daddi r23,r0,101; r23 = 'e'
  sb r23,0(r18) ; str[i] = 'e'
  daddi r18,r18,1 ; i++
  bgez r9,Skipf2 ; is e > 0?
  beqz r9,Skipf2 ; is e == 0?
;No e < 0
  daddi r23,r0,45; r23 = '-'
  sb r23,0(r18) ; str[i] = '-'
  daddi r18,r18,1 ; i++
  dsub r9,r0,r9 ; r9 = -r9 = |r9|
  b Skipf3   
Skipf2:
  daddi r23,r0,43 ; r23 = '+'
  sb r23,0(r18) ; str[i] = '+'
  daddi r18,r18,1 ; i++
Skipf3:
  movz r14,r9,r0 ; r14 = e
  daddi r15,r0,0
  ld r10,Ten(r0)
Whilef4:
   daddi r15,r15,1
   ddiv r14,r10  
   mflo r14
   beqz r14,EndWhilef4
   b Whilef4
EndWhilef4:  
   daddi r15,r15,-1
   dadd r15,r15,r18
   movz r18,r15,r0 ; set up result
  movz r14,r9,r0 ; r14 = e
  ld r10,Ten(r0)
Whilef5:
   ddiv r14,r10  
   mflo r14
   mfhi r23
   daddi r23,r23,48 ; r23 = r23 + '0'
   sb r23,0(r15)
   daddi r15,r15,-1
   beqz r14,EndWhilef5
   j Whilef5
EndWhilef5:  
dsub r18,r18,r17  
daddi r18,r18,2
jr $ra

print_string:
; function, expects r14 =&parameter address, r8 = &Source string
; r9 = source size
; 
daddi r23,r0,2
sd r23,0(r14) ; Write to output screen
sd  r8,8(r14) ; Source address
sd  r9,16(r14) ; Source size
syscall 4
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
