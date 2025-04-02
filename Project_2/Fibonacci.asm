.data
n: .word 12  # Input value (n = 12)
result: .word 0  # Store Fibonacci result

.text
.globl main

main:
    la $t0, n        # Load n from memory
    lw $a0, 0($t0)   # Loads n into $a0

    slti $t0, $a0, 2     # $t0 = 1 if n < 2
    bnez $t0, return_n   # Branch if n < 2
    
    # Initialize for iteration
    li $t1, 1   # b = 1
    li $t2, 0   # a = 0
    addi $t3, $a0, -1  # counter = n-1

loop:
    beqz $t3, end_fib   # branch to return when counter = 0
    move $t4, $t1       # temp = b
    add $t1, $t1, $t2   # b = a + b
    move $t2, $t4       # a = temp
    addi $t3, $t3, -1   # decrement counter
    j loop

end_fib:
    move $v0, $t1    # result = b
    la $t1, result   # load address of result into $t1
    sw $v0, 0($t1)   # store result into address
    j DONE
    
return_n:
    la $t1, result   # Load address of result
    sw $a0, 0($t1)   # Store n in result
 
DONE:
