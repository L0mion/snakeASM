.bss
	snakex: 		.space 400
	snakey: 		.space 400
	applesx:		.space 40
	applesy:		.space 40
.data
	running: 		.long 1
	dir:	 		.long 1
	
	loopCount: 		.long 0
	loopCount2:		.long 0
	adressX2:		.long 0
	adressY2:		.long 0
	adressX: 		.long 0
	adressY: 		.long 0
	
	posX: 			.long 0
	posY: 			.long 0
	nrOfApples:		.long 10
	temp: 			.long 20
	
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
	movl $-1, %eax
	movl %eax, (%ebx)
	addl $4, adressX
	
	movl adressY, %ebx
	movl $-1, %eax
	movl %eax, (%ebx)
	addl $4, adressY
	
	addl $1, temp

	addl $1, loopCount
	
	jmp initLoop

init2:
	movl $50, snakex
	movl $20, snakey
	
	movl $snakex, adressX
	movl $snakey, adressY

	movl $0, loopCount
	movl $20, temp
initLoop2:
	cmpl $5, loopCount
	je init3
	
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
	
	jmp initLoop2

init3:
	#Initialize apples
	movl $applesx, adressX
	movl $applesy, adressY

	movl $0, loopCount
init3Loop:
	cmpl $10, loopCount
	je gameLoop
	
	movl adressX, %ebx
	movl $-1, %eax
	movl %eax, (%ebx)
	addl $4, adressX
	
	movl adressY, %ebx
	movl $-1, %eax
	movl %eax, (%ebx)
	addl $4, adressY

	addl $1, loopCount
	
	jmp init3Loop
	#initialize apples

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
	call nib_end
	
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
	
	movl adressX, %ebx													
	movl (%ebx), %eax
	cmpl $-1, %eax
	je lp1
	movl adressX, %ecx
	subl $4, %ecx
	movl (%ecx), %edx	
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

moveUp:
	subl $1, snakey
	jmp collission
moveDown:
	addl $1, snakey
	jmp collission

moveLeft:
	subl $1, snakex
	jmp collission

moveRight:
	addl $1, snakex
	jmp collission

collission:

#Collission with walls
	cmpl $0, snakex
	je exit
	cmpl $100, snakex
	je exit
	cmpl $0, snakey
	je exit
	cmpl $40, snakey
	je exit
#Collission with walls

#Collission of apples
	movl $0, loopCount
	movl $applesx, adressX
	movl $applesy, adressY
	subl $4, adressX
	subl $4, adressY
	
collissionApple:
	cmpl $10, loopCount
	je collissionSnake
	
	addl $1, loopCount
	addl $4, adressX
	addl $4, adressY
	
	movl adressX, %ebx
	movl (%ebx), %eax
	cmpl snakex, %eax
	jne collissionApple
	
	movl adressY, %ebx
	movl (%ebx), %eax
	cmpl snakey, %eax
	jne collissionApple
	
	movl $-1, (%ebx)
	movl adressX, %ebx
	movl $-1, (%ebx)
	
	movl $0, loopCount2
	movl $snakex, adressX2
	movl $snakey, adressY2
	subl $4, adressX2
	subl $4, adressY2
growSnake:
	cmpl $99, loopCount2
	je collissionApple
	
	addl $1, loopCount2
	addl $4, adressX2
	addl $4, adressY2
	
	#find -1
	movl adressX2, %ebx
	movl (%ebx), %eax
	cmpl $-1, %eax
	jne growSnake
	#find -1
	
	#add piece of snake
	movl adressX2, %eax
	movl %eax, posX
	movl adressY2, %eax
	movl %eax, posY
	
	subl $4, adressX2
	subl $4, adressY2
	
	movl adressX2, %eax
	movl (%eax), %ecx
	movl posX, %ebx
	movl %ecx, (%ebx)
	
	movl adressY2, %eax
	movl (%eax), %ecx
	movl posY, %ebx
	movl %ecx, (%ebx)
	
	jmp collissionApple
	#add piece of snake
	
	jmp collissionApple
	
#Collission of apples
collissionSnake:
	movl $0, loopCount
	movl $snakex, adressX
	movl $snakey, adressY

collissionLoop:
	cmpl $100, loopCount
	je jumpback2
	
	addl $1, loopCount
	addl $4, adressX
	addl $4, adressY
	
	movl adressX, %ebx
	movl (%ebx), %eax
	cmpl %eax, snakex
	jne collissionLoop
	
	movl adressY, %ebx
	movl (%ebx), %eax
	cmpl %eax, snakey
	jne collissionLoop
	
	jmp exit
	
render:

	movl $0, loopCount
	movl $applesx, adressX
	movl $applesy, adressY
	
appleRenderLoop:
	cmpl $10, loopCount
	je renderSnake
	
	
	movl adressX, %ebx
	movl (%ebx), %eax
	movl %eax, posX
	
	movl adressY, %ebx
	movl (%ebx), %eax
	movl %eax, posY
	
	pushl $111
	pushl posY
	pushl posX
	call nib_put_scr
	addl $12, %esp
	
	addl $4, adressX
	addl $4, adressY
	addl $1, loopCount
	
	jmp appleRenderLoop

renderSnake:
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
	call nib_poll_kbd
	cmpl $97, %eax
	je left
	cmpl $119, %eax
	je up
	cmpl $100, %eax
	je right
	cmpl $115, %eax
	je down
inputfinished:
	
	#Update apples
	movl $applesx, adressX
	movl $applesy, adressY
	
	subl $4, adressX
	subl $4, adressY

	movl $0, loopCount
appleLoop:
	cmpl $10, loopCount
	je jumpback
	
	addl $1, loopCount
	addl $4, adressX
	addl $4, adressY
	
	movl adressX, %ebx
	cmpl $-1, (%ebx)
	jne appleLoop
	
	#spawn granny smith
	call rand_x
	movl adressX, %ebx
	movl %eax,  (%ebx)
	
	call rand_y
	movl adressY, %ebx
	movl %eax,  (%ebx)
	
	jmp appleLoop
	#Update apples

left:
	cmpl $4, dir
	je inputfinished
	
	movl $2, dir
	jmp inputfinished
right:
	cmpl $2, dir
	je inputfinished

	movl $4, dir
	jmp inputfinished
up:
	cmpl $3, dir
	je inputfinished

	movl $1, dir
	jmp inputfinished
down:
	cmpl $1, dir
	je inputfinished

	movl $3, dir
	jmp inputfinished
