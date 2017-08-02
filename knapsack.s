#Creator: Gabriella Quattrone
#Purpose:  To recursively find the set of items that maximizes the amount of value in the knapsack
########## but whose weight doesn't exceed W. 
#Date: July 21, 2:20 PM
.global knapsack
.equ ws, 4
	
.text
max:
  #prologue
	push %ebp
	movl %esp, %ebp
	
	.equ a, (2*ws) #for arg a
	.equ b, (3*ws) #for arg b

	movl a(%ebp), %eax
	movl b(%ebp), %ecx
	
	cmpl %eax, %ecx 
	jb end_max
	movl %ecx, %eax
end_max:
	movl %ebp, %esp
	pop %ebp
        ret	
knapsack:
    #prologue
        push %ebp
	movl %esp, %ebp

	subl $(2*ws), %esp

	.equ weights,    (2*ws) #(%ebp) int*
	.equ values,     (3*ws) #(%ebp) unsigned int* 
	.equ num_items,  (4*ws) #(%ebp) unsigned int
	.equ capacity, 	 (5*ws) #(%ebp) int
	.equ cur_value,	 (6*ws) #(%ebp) unsigned int
	.equ i,          (-1*ws)#(%ebp) int
	.equ best_value, (-2*ws)#(%ebp) int

	#registers to use
	push %ebx
	push %esi
	push %edi

	movl cur_value(%ebp), %edx
	movl %edx, best_value(%ebp)
	movl values(%ebp), %edi
	movl weights(%ebp), %esi    
# for(i = 0; i < num_items; i++)
   movl $0, %ebx
   for_start:
	cmpl num_items(%ebp), %ebx #i - num_items < 0
	jae end_loop 
#if(capacity - weights[i] >= 0 )
	movl capacity(%ebp), %ecx 
	subl (%esi, %ebx, ws), %ecx #capacity - weights[i]
	jl next_iteration
#MAKE RECURSIVE CALL#	
	#cur_value + values[i]
	movl cur_value(%ebp), %edx
	addl (%edi, %ebx, ws), %edx #edx = cur_value + values[i]
	push %edx

	#capacity - weights[i]	
	push %ecx

	#num_items-i-1
	movl num_items(%ebp), %edx
	subl %ebx, %edx
	decl %edx
	push %edx

	#values+i+1
	leal ws(%edi, %ebx, ws), %edx
	push %edx

	#weights+i+1
	leal ws(%esi, %ebx, ws), %edx
	push %edx

	call knapsack
	
	push %eax
	push best_value(%ebp)

	call max
	movl %eax, best_value(%ebp)
	addl $(ws*(5+2)), %esp
next_iteration:
	incl %ebx
	jmp for_start
end_loop:
end_knapsack:
        pop %edi
	pop %esi
	pop %ebx
	movl best_value(%ebp), %eax
epilogue:
	movl %ebp, %esp
	pop %ebp
	ret
