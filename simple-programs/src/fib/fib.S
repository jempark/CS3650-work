// Parts of code was based off of the in-class code from 1/14
	.global main

	.data

usage_msg: .String "Usage:\n %s N, where N >= 0\n"
printfmt: .String "fib(%ld) = %ld\n"

	.text

// Variable Mappings:
// argc is %rdi
// argv is %rsi
// 
// Safety Registers:
// %rbx used to hold the original number x
// %r12 used to hold x-1
// %r13 used to hold x-2
//
// Temporary Registers:
// Temporarily hold values 
// -%rax

main: 
	push %rbx
	enter $8, $0
	
	cmp $2, %rdi
	jne bad_args

main_good_args:
	mov 8(%rsi), %rdi
	call atol
	mov %rax, %rdi
	mov %rax, %rbx

	cmp $0, %rdi
	jl bad_args

	call fib
	jmp good_args

fib:
	push %r12
	push %r13
	
	cmp $1, %rdi
	jle cond_then
	jmp cond_done

cond_then: 
	mov %rdi, %rax
	jmp fib_done
	
cond_done: 
	mov %rdi, %r13 		//r13 holds og fib num x
	sub $1, %rdi 		//rdi has x - 1
	call fib 
	mov %rax, %r12 

	mov %r13, %rdi 		//move x into rdi
	sub $2, %rdi 		//rdi has x - 2
	call fib

	add %r12, %rax

	jmp fib_done

fib_done:
	pop %r13
	pop %r12
	ret

bad_args: 
	mov $usage_msg, %rdi
	call puts
	
	mov $1, %rax
	jmp main_done

good_args: 
	mov $printfmt, %rdi
	mov %rbx, %rsi
	mov %rax, %rdx
	mov $0, %al
	call printf 

	mov $0, %rax
	jmp main_done

main_done:
	leave
	pop %rbx
	ret
