	.global main

	.data

bad_input: .string "bad input" 
scanfmt: .string "%ld"
printfmt1: .string "%ld\n"
printfmt2: .string "%ld "
newLine: .string "\n"

	.text

// Variable Mapping:
// Argument registers:
// %rdi is xs
// %rsi is ii
// %rdx is jj
// Temporary registers:
// %r10 and %r11 to hold xs[ii] and xs[jj]
swap:
	enter $0, $0
	
	cmp %rsi, %rdx // ii != jj
	je swap_done
	
	mov (%rdi, %rsi, 8), %r10	// set xs[ii] to temp 
	mov (%rdi, %rdx, 8), %r11	// set xs[jj] to temp --> error otherwise
	
	mov %r11, (%rdi, %rsi, 8)	// xs[ii] = xs[jj]
	mov %r10, (%rdi, %rdx, 8)	// xs[jj] = temp 	

swap_done:
	leave
	ret

// Variable Mapping:
// Argument registers: 
// %rdi is xs
// %rsi is low
// %rdx is high
// Safety registers: 
// %rbx is ii
// %r12 is jj
// %r13 is xs
// %r14 is low and ii 
// %r15 is high
// Temporary registers:
// %r10 is pivot 
partition:
	push %rbx
	push %r12
	push %r13
	push %r14
	push %r15
	enter $8, $0 
		
	mov %rdi, %r13		  // xs to safety r13
	mov %rsi, %r14		  // low in safety r14 (will be ii)
	mov %rdx, %r15		  // high in safety r15

	dec %r15               	  // high - 1 
	mov (%r13, %r15, 8), %rbx // long pivot = xs[hi - 1] into %rbx 
	mov %r14, %r12		  // long jj = low into safety

partition_loop_cond:
	cmp %r15, %r12		  // jj < high - 1
	jge partition_loop_done   // jj >= high - 1 then jump to loop done
	
	cmp %rbx, (%r13, %r12, 8) // xs[jj] >=  pivot 
	jge partition_cond_done    // if above statement is true, go to then

	mov %r13, %rdi
	mov %r14, %rsi
	mov %r12, %rdx
	call swap
	inc %r14

partition_cond_done:
	inc %r12
	jmp partition_loop_cond

partition_loop_done:
	mov %r13, %rdi		  // move xs to rdi 
	mov %r14, %rsi 		  // move ii to rsi
	mov %r15, %rdx 		  // move high - 1 to rdx
	call swap 
	
	mov %r14, %rax	  	  // move ii to return
	
	leave
	pop %r15
	pop %r14
	pop %r13
	pop %r12
	pop %rbx
	ret

// Variable Mapping:
// Argument Registers:
// %rdi is xs
// %rsi is low
// %rdx is high
// Safety Registers:
// %rbx is high
// %r12 is result of partition
// %r13 is xs
// %r14 is low 
quicksort:
	push %rbx
	push %r12
	push %r13
	push %r14
	enter $0, $0 

	mov %rdi, %r13 // move xs to r13
	mov %rsi, %r14 // move low to r14
	mov %rdx, %rbx // move high to safety rbx
	
	sub %rsi, %rdx // high - low; result in rdx
	cmp $1, %rdx   // if rdx < 1 return 
	jl quicksort_done

	mov %r13, %rdi
	mov %r14, %rsi
	mov %rbx, %rdx
	call partition // call partition on xs low high
	mov %rax, %r12 // mov result of partition into safety r12
	
	mov %r13, %rdi
	mov %r14, %rsi
	mov %r12, %rdx
	call quicksort // call on xs, low, and pp 

	mov %r13, %rdi
	mov %rbx, %rdx 
	inc %r12       // adds 1 to pp
	mov %r12, %rsi  // moves pp + 1 to low 
	call quicksort // call on array, pp + 1, high 

quicksort_done:
	leave
	pop %r14
	pop %r13
	pop %r12
	pop %rbx
	ret
	
// Variable Mapping:
// Argument Registers: 
// %rdi and %rsi is ptr
read_int:
	enter $0, $0

	mov %rdi, %rsi	   //move ptr to rsi
	mov $scanfmt, %rdi //scanfmt to $rdi
	mov $0, %al	   //move 0 to al 
	call scanf
	
	cmp $1, %rax	   // compared 1 and result
	jne read_bad

	leave
	ret

read_bad:
	mov $bad_input, %rdi
	call puts
	call exit

// Variable Mapping:
// Safety Registers:
// %r12 is xs
// %r13 is ii 
main:
	push %r12
	push %r13
 	enter $16, $0

	lea 0(%rsp), %rdi
	call read_int
	
	mov $8, %r10
	imul 0(%rsp), %r10
	mov %r10, %rdi
	call malloc
	mov %rax, %r12

	mov $0, %r13
	
main_loop_cond:
	cmp 0(%rsp), %r13
	jge main_loop_done

   	lea (%r12, %r13, 8), %rdi
	call read_int
	inc %r13
	jmp main_loop_cond 

main_loop_done:
	mov %r12, %rdi
	mov $0, %rsi
	mov 0(%rsp), %rdx
    	call quicksort

	mov $printfmt1, %rdi 
	mov 0(%rsp), %rsi
	mov $0, %al
	call printf

	mov $0, %r13

main_print_loop_cond:
	cmp 0(%rsp), %r13
	jge main_print_loop_done
	
	mov $printfmt2, %rdi
	mov (%r12, %r13, 8), %rsi
	mov $0, %al
	call printf

	inc %r13
	jmp main_print_loop_cond

main_print_loop_done:
	mov $newLine, %rdi
	call printf

main_done:
	mov %r12, %rdi 
	call free
	mov $0, %rax	

	leave
	pop %r13
	pop %r12
	ret
