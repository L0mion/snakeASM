.bss
	snakex: .space 400
	snakey: .space 400
.data
	running: .short 1
	dir:	 .short 1
	
	loopCount: .long 0
	adressX: .long 0
	adressY: .long 0
	
	posX: .long 0
	posY: .long 0
	
	temp: .long 21
	
.section .text	
	.globl main
	
main:
	call init
	call gameLoop
init: 
	call nib_init
	
	movl $snakex, adressX
	movl $snakey, adressY

	movl $0, loopCount
initLoop:
	cmpl $100, loopCount
	je init2
	
	movl adressX, %ebx
	movl $50, %eax
	movl %eax, (%ebx)
	addl $4, adressX
	
	movl adressY, %ebx
	movl temp, %eax
	movl %eax, (%ebx)
	addl $4, adressY
	addl $1, temp

	addl $1, loopCount
	
	jmp initLoop

init2:
	movl $50, snakex
	movl $20, snakey
	jmp gameLoop

gameLoop:
	pushl $200000
	call usleep
	addl $4, %esp

	cmpl $0, running
	je exit

	call clearScr
	call tick
jumpback:
	call update
	
	call move
jumpback2:
	call render
	
exit:
	call endwin
	ret
	
move:
	movl $99, loopCount
	movl $snakex, adressX
	movl $snakey, adressY
	addl $400, adressX
	addl $400, adressY
	
	lp1:
	cmpl $0, loopCount
	je continue
	subl $1, loopCount
	subl $4, adressX
	subl $4, adressY
	
	movl adressX, %ebx													#X
	movl (%ebx), %eax
	cmpl $-1, %eax
	je lp1
	movl adressX, %ecx
	subl $4, %ecx
	movl (%ecx), %edx	#X
	movl %edx, (%ebx)
	
	movl adressY, %ebx													
	movl (%ebx), %eax
	cmpl $-1, %eax
	je lp1
	movl adressY, %ecx
	subl $4, %ecx
	movl (%ecx), %edx	
	movl %edx, (%ebx)
	
	jmp lp1

	continue:
	cmpl $1, dir
	je moveUp
	cmpl $2, dir
	je moveLeft
	cmpl $3, dir
	je moveDown
	cmpl $4,dir
	je moveRight
	
	//move heeeead!
	
	jmp jumpback2

moveUp:
	subl $1, snakey
	jmp jumpback2
moveDown:
	addl $1, snakey
	jmp jumpback2

moveLeft:
	subl $1, snakex
	jmp jumpback2

moveRight:
	addl $1, snakex
	jmp jumpback2
	
render:
	
	movl $0, loopCount
	movl $snakex, adressX
	movl $snakey, adressY
l1:
	cmpl $100, loopCount
	je gameLoop
	
	movl adressX, %ebx
	movl (%ebx), %eax
	movl %eax, posX
	addl $4, adressX
	
	movl adressY, %ebx
	movl (%ebx), %eax
	movl %eax, posY
	addl $4, adressY

	addl $1, loopCount
	
	movl posX, %ebx
	cmpl $-1, %ebx
	je l1
	
	pushl $43
	pushl posY
	pushl posX
	call nib_put_scr
	addl $12, %esp
	
	jmp l1
	
	#jmp gameLoop
	
tick:
	call nib_poll_kbd													#the int-return is delivered to %eax
	cmpl $97, %eax
	je left
	cmpl $119, %eax
	je up
	cmpl $100, %eax
	je right
	cmpl $115, %eax
	je down
inputfinished:
	
	jmp jumpback

left:
	movl $2, dir
	jmp inputfinished
right:
	movl $4, dir
	jmp inputfinished
up:
	movl $1, dir
	jmp inputfinished
down:
	movl $3, dir
	jmp inputfinished
