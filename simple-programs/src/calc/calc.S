// Parts of code was based off of the in-class code from 1/14 

    .global main

    .data 

usage_msg: .String "Usage:\n %s N op N\n"
printfmt:  .String "%ld %c %ld = %ld\n"
add:       .String "+"
sub:       .String "-"
mul:       .String "*"
div:       .String "/"
    .text

// Variable Mapping:
// - argc is %rdi
// - argv is %rsi
//
// -- Safe Registers -- 
// - %rbx : %rsi (argv)
// - %r14 : the first number (atol'd)
// - %r15 : the second number (atol'd)
//
// -- Other Registers --
// - %r12b : the operand (char)
// - %r13b : used for checking the operand with hard coded operands
//
// -- Temporary Registers --
// - Used to temporarily hold values
// - %r10, %r11, %rax, %dl, %rcx 

main: 
    push %rbx
    push %r14
    push %r15
    
    enter $8, $0
    
    mov %rsi, %rbx

    cmp $4, %rdi
    jne bad_args

main_good_args:    
    mov 8(%rbx), %rdi
    call atol
    mov %rax, %r14

    mov $2, %r10
    mov (%rbx, %r10, 8), %rdi
    mov $0, %r10
    mov (%rdi, %r10, 1), %r12b

    mov $3, %r10
    mov (%rbx, %r10, 8), %rdi
    call atol 
    mov %rax, %r15

    mov %r14, %rdi
    mov %r15, %rsi

    mov $add, %r10
    mov $0, %r11
    mov (%r10, %r11, 1), %r13b
    cmp %r13b, %r12b 
    je calc_add

    mov $sub, %r10
    mov $0, %r11
    mov (%r10, %r11, 1), %r13b
    cmp %r13b, %r12b 
    je calc_sub

    mov $mul, %r10
    mov $0, %r11
    mov (%r10, %r11, 1), %r13b
    cmp %r13b, %r12b 
    je calc_mul
   
    mov $div, %r10
    mov $0, %r11
    mov (%r10, %r11, 1), %r13b
    cmp %r13b, %r12b 
    je calc_div

    jmp bad_args

calc_add:
    add %rsi, %rdi
    mov %rdi, %rax
    jmp good_args

calc_sub:   
    sub %rsi, %rdi
    mov %rdi, %rax
    jmp good_args

calc_mul:
    mov %rdi, %rax
    imul %rsi
    jmp good_args

calc_div: 
    mov %rdi, %rax
    idiv %rsi
    jmp good_args

bad_args:
    mov $usage_msg, %rdi
    call puts

    mov $1, %rax
    jmp main_done

good_args:
    mov $printfmt, %rdi
    mov %r14, %rsi
    mov %r12b, %dl
    mov %r15, %rcx
    mov %rax, %r8
    mov $0, %al
    call printf

    mov $0, %rax
    jmp main_done
    
main_done: 
    leave
    pop %r15
    pop %r14
    pop %rbx
    ret
